<?php

if (!defined('AREA')) {
    die('Access denied');
}

use Tygh\Enum\NotificationSeverity;
use Tygh\Tygh;

require_once 'MiaPosSdk.php'; // Include the MiaPos SDK

if (defined('PAYMENT_NOTIFICATION')) {
    $order_id = !empty($_REQUEST['orderId']) ? (int)$_REQUEST['orderId'] : 0;
    $salt = !empty($_REQUEST['salt']) ? $_REQUEST['salt'] : '';

    if ($mode == 'success') {
        processRedirectUrl('MIA POS success', $order_id, $salt);
    } elseif ($mode == 'fail') {
        processRedirectUrl('MIA POS fail', $order_id, $salt);
    } elseif ($mode == 'return') {
        $data = file_get_contents("php://input");
        processCallback($data);
    }
} else {
    processPaymentRequest($order_info, $processor_data);
}

function processPaymentRequest($order_info, $processor_data)
{
    try {
        // Validate order information
        if (!$order_info) {
            throw new Exception(__('mia_pos.error_no_order'));
        }

        // Validate module configuration
        if (empty($processor_data['processor_params']['merchant_id']) ||
            empty($processor_data['processor_params']['terminal_id'])) {
            throw new Exception(__('mia_pos.error_configuration'));
        }

        // Validate currency
        if ($order_info['secondary_currency'] !== 'MDL') {
            throw new Exception(__('mia_pos.error_currency_not_supported'));
        }

        // Generate a unique salt for URL protection
        $salt = uniqid('mia_', true);
        $order_id = $order_info['order_id'];

        // Prepare payment request data
        $payment_data = [
            'terminalId' => $processor_data['processor_params']['terminal_id'],
            'orderId' => (string)$order_id,
            'amount' => (float)number_format($order_info['total'], 2, '.', ''),
            'currency' => 'MDL',
            'language' => $processor_data['processor_params']['language'],
            'payDescription' => sprintf(__('mia_pos.text_order_description'), $order_id),
            'paymentType' => $processor_data['processor_params']['payment_type'],
            'clientName' => substr(trim($order_info['firstname'] . ' ' . $order_info['lastname']), 0, 128),
            'clientPhone' => getCleanPhoneNumber($order_info['phone']),
            'clientEmail' => $order_info['email'],
            'callbackUrl' => fn_url('payment_notification.return?payment=mia_pos', 'C'),
            'successUrl' => fn_url('payment_notification.success?payment=mia_pos&orderId=' . $order_id . '&salt=' . $salt, 'C'),
            'failUrl' => fn_url('payment_notification.fail?payment=mia_pos&orderId=' . $order_id . '&salt=' . $salt, 'C'),
        ];

        // Log payment request data
        logEvent('[MIA POS] Payment request data: ' . json_encode($payment_data, JSON_PRETTY_PRINT));

        // Create payment via SDK
        $sdk = MiaPosSdk::getInstance(
            $processor_data['processor_params']['base_url'],
            $processor_data['processor_params']['merchant_id'],
            $processor_data['processor_params']['secret_key']);

        $response = $sdk->createPayment($payment_data);

        // Validate SDK response
        if (!isset($response['paymentId']) || !isset($response['checkoutPage'])) {
            throw new Exception(__('mia_pos.error_invalid_response'));
        }

        updateOrderInfoByCreatedMiaPay($order_id, $response['paymentId'], $salt);

        list($carts) = fn_get_carts(array(
            'user_id' => $order_info['user_id']
        ));
        $cart = reset($carts);
        $cart['products'] = fn_get_cart_products($cart['user_id'], $payment_data);
        fn_extract_cart_content($cart, $order_info['user_id']);

        fn_update_order($cart, $order_id);

        // Change order status to "Pending Payment"
        fn_change_order_status(
            (int)$order_id,
            $processor_data['processor_params']['pending_status_id'],
            $order_info['status'],
            fn_get_notification_rules(['notify_user' => true])
        );

        // Log successful payment initialization
        logEvent(
            '[MIA POS] Payment initiated successfully. Payment ID: ' . $response['paymentId'] . ', Salt: ' . $salt . ', orderId: ' . $order_id,
            'Redirecting to: ' . $response['checkoutPage']
        );

        // Redirect the user to the payment page
        header('Location: ' . $response['checkoutPage']);
        exit;
    } catch (Exception $e) {
        // Log the error
        logEvent('[MIA POS] Payment error: ' . $e->getMessage() . ', orderId: ' . $order_info['order_id']);

        // Notify the admin about the error
        $failed_message = __('mia_pos.payment_failed_note', ['[error]' => $e->getMessage()]);
        fn_set_notification(NotificationSeverity::ERROR, __('error'), $failed_message);

        // Redirect the customer back to the checkout page
        fn_redirect(fn_url('checkout.checkout'));
    }
}

function processRedirectUrl($mode, $order_id, $received_salt)
{
    if (!$order_id || !$received_salt) {
        logEvent("{$mode} URL: Missing or invalid orderId/salt.");
        fn_set_notification(NotificationSeverity::ERROR, __('error'), __('mia_pos.error_invalid_request'));
        fn_redirect(fn_url('checkout.checkout'));
        return;
    }

    logEvent("{$mode} URL - Order ID: $order_id, receivedSalt: $received_salt");
    $order_info = fn_get_order_info($order_id);

    if (empty($order_info)) {
        logEvent("{$mode} URL: Order not found. Order ID: {$order_id}");
        fn_set_notification(NotificationSeverity::ERROR, __('error'), __('mia_pos.error_no_order'));
        fn_redirect(fn_url('checkout.checkout'));
        return;
    }

    $payment_data = db_get_row('SELECT * FROM ?:mia_pos_payments WHERE order_id = ?i', $order_id);
    $pay_id = $payment_data['payment_id'];
    $salt = $payment_data['salt'];
    logEvent("{$mode} URL - Payment details by order id $order_id: payId $pay_id, salt $salt");

    if (empty($payment_data) || $salt !== $received_salt) {
        logEvent("{$mode} URL: Salt mismatch or payment data not found. Received salt: {$received_salt}, Stored salt: {$salt}");
        fn_set_notification(NotificationSeverity::ERROR, __('error'), __('mia_pos.error_invalid_session'));
        fn_redirect(fn_url('checkout.checkout'));
        return;
    }

    if (!$pay_id) {
        logEvent("{$mode} URL: Payment ID not found for Order ID: {$order_id}.");
        fn_set_notification(NotificationSeverity::ERROR, __('error'), __('mia_pos.error_payment_id_not_found'));
        fn_redirect(fn_url('checkout.checkout'));
        return;
    }

    logEvent("{$mode} URL - Mia Payment ID: $pay_id by orderId: $order_id start check");
    try {
        $sdk = MiaPosSdk::getInstance(
            $order_info['payment_method']['processor_params']['base_url'],
            $order_info['payment_method']['processor_params']['merchant_id'],
            $order_info['payment_method']['processor_params']['secret_key']
        );

        $payment_status = $sdk->getPaymentStatus($pay_id);
        logEvent("{$mode} URL - Payment status response: " . json_encode($payment_status, JSON_PRETTY_PRINT));

        $status = isset($payment_status['status']) ? $payment_status['status'] : 'unknown';

        switch ($status) {
            case 'SUCCESS':
                processPaymentSuccess($order_id, $order_info, $payment_status, $mode);
                fn_redirect(fn_url('checkout.complete?order_id=' . $order_id));
                break;

            case 'PENDING':
            case 'CREATED':
                processPaymentPending($order_id, $order_info, $payment_status, $mode);
                fn_redirect(fn_url('checkout.checkout'));
                break;

            default:
                processPaymentFailure($order_id, $order_info, $payment_status, $mode);
                fn_set_notification(NotificationSeverity::ERROR, __('error'), __('mia_pos.payment_failed'));
                fn_redirect(fn_url('checkout.checkout'));
                break;
        }
    } catch (Exception $e) {
        logEvent("{$mode} URL - Error processing payment: {$e->getMessage()}, orderId: {$order_id}");

        fn_set_notification(NotificationSeverity::ERROR, __('error'), __('mia_pos.error_payment_verification'));
        fn_redirect(fn_url('checkout.checkout'));
    }
}

function processCallback($raw_post)
{
    try {
        logEvent("MIA POS callback received raw data: $raw_post");

        $callback_data = json_decode($raw_post, true);
        if (json_last_error() !== JSON_ERROR_NONE) {
            logEvent("MIA POS callback JSON decode error: " . json_last_error_msg(), 'error');
            http_response_code(400);
            exit('Invalid JSON data');
        }

        // Проверка структуры данных
        if (!isset(
            $callback_data['result'],
            $callback_data['signature'],
            $callback_data['result']['orderId'],
            $callback_data['result']['status'],
            $callback_data['result']['paymentId']
        )) {
            logEvent("MIA POS invalid callback data structure: " . json_encode($callback_data, JSON_PRETTY_PRINT), 'error');
            http_response_code(400);
            exit('Invalid callback data structure');
        }

        $result = $callback_data['result'];
        $order_id = (int)$result['orderId'];
        $pay_id = $result['paymentId'];

        logEvent("MIA POS callback started for order ID: $order_id, payment ID: $pay_id");

        $order_info = fn_get_order_info($order_id);
        if (!$order_info) {
            logEvent("MIA POS callback order not found for ID: $order_id", 'error');
            http_response_code(404);
            exit('Order not found');
        }

        $mia_payment_id = $order_info['payment_id'];
        $payment_method_data = fn_get_payment_method_data($mia_payment_id);
        $processor_params = isset($payment_method_data['processor_params']) ? $payment_method_data['processor_params'] : null;

        if (!$processor_params) {
            logEvent("MIA POS callback: Failed to load processor configuration.", 'error');
            http_response_code(500);
            exit('Configuration error');
        }

        $sdk = MiaPosSdk::getInstance(
            $processor_params['base_url'],
            $processor_params['merchant_id'],
            $processor_params['secret_key']
        );

        $result_str = formSignStringByResult($result, $order_id);
        if (!$sdk->verifySignature($result_str, $callback_data['signature'])) {
            logEvent("MIA POS Invalid signature for callback data: " . json_encode($callback_data, JSON_PRETTY_PRINT), 'error');
            http_response_code(400);
            exit('Invalid signature');
        }

        logEvent("MIA POS callback signature is valid for order ID: $order_id");

        $current_order_status = $order_info['status'];
        $result_status = $result['status'];

        if (!in_array($current_order_status, [
            $order_info['payment_method']['processor_params']['pending_status_id'],
            $order_info['payment_method']['processor_params']['failed_status_id']
        ])) {
            logEvent("MIA POS callback order $order_id is already in a final state [$current_order_status]. Ignoring callback for status $result_status.");
            http_response_code(200);
            exit('OK');
        }

        switch ($result_status) {
            case 'SUCCESS':
                processPaymentSuccess($order_id, $order_info, $result, 'callback');
                break;

            case 'PENDING':
            case 'CREATED':
                processPaymentPending($order_id, $order_info, $result, 'callback');
                break;

            case 'DECLINED':
            case 'FAILED':
            case 'EXPIRED':
                processPaymentFailure($order_id, $order_info, $result, 'callback');
                break;

            default:
                logEvent("MIA POS callback unknown payment status received for order ID: $order_id, status: $result_status");
                http_response_code(400);
                exit('Unknown payment status');
        }

        logEvent("MIA POS callback successfully processed for order ID: $order_id, payment ID: $pay_id");
        http_response_code(200);
        exit('OK');
    } catch (Exception $e) {
        logEvent("MIA POS callback processing error, message: " . $e->getMessage(), 'error');
        http_response_code(500);
        exit('Internal server error');
    }
}


function processPaymentSuccess($order_id, $order_info, $payment, $source)
{
    $order_note = sprintf(
        "Source %s, Success mia_payment_info: %s",
        $source,
        json_encode($payment, JSON_PRETTY_PRINT)
    );

    logEvent($order_note);

    list($carts) = fn_get_carts(['user_id' => $order_info['user_id']]);
    $cart = reset($carts);
    if (!empty($cart)) {
        $cart['products'] = fn_get_cart_products($cart['user_id'], []);
        fn_extract_cart_content($cart, $order_info['user_id']);
        fn_clear_cart($cart);
        fn_save_cart_content($cart, $order_info['user_id']);
    }

    fn_change_order_status(
        $order_id,
        $order_info['payment_method']['processor_params']['completed_status_id'],
        $order_info['status'],
        fn_get_notification_rules(['notify_user' => true])
    );
}

function processPaymentFailure($order_id, $order_info, $payment, $source)
{
    $order_note = sprintf(
        "Source %s, Fail mia_payment_info: %s",
        $source,
        json_encode($payment, JSON_PRETTY_PRINT)
    );

    logEvent($order_note);

    fn_change_order_status(
        $order_id,
        $order_info['payment_method']['processor_params']['failed_status_id'],
        $order_info['status'],
        fn_get_notification_rules(['notify_user' => true])
    );
}

function processPaymentPending($order_id, $order_info, $payment, $source)
{
    $order_note = sprintf(
        "Source %s, Pending mia_payment_info: %s",
        $source,
        json_encode($payment, JSON_PRETTY_PRINT)
    );

    logEvent($order_note);

    fn_change_order_status(
        $order_id,
        $order_info['payment_method']['processor_params']['pending_status_id'],
        $order_info['status'],
        fn_get_notification_rules(['notify_user' => true])
    );
}


function updateOrderInfoByCreatedMiaPay($order_id, $pay_id, $salt)
{
    /** @var \Tygh\Database\Connection $db */
    $db = Tygh::$app['db'];

    // Save payment data, update when order_id is duplicated
    $db->query(
        'INSERT INTO ?:mia_pos_payments (order_id, payment_id, salt, created_at, updated_at)
     VALUES (?i, ?s, ?s, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
     ON DUPLICATE KEY UPDATE payment_id = VALUES(payment_id), salt = VALUES(salt), updated_at = CURRENT_TIMESTAMP',
        $order_id,
        $pay_id,
        $salt
    );

}

/**
 * Trims and formats a phone number to extract the last 8 digits if valid.
 *
 * @param string|null $phone The full phone number, including the country code.
 * @return string|null Returns the last 8 digits of the phone number if valid; otherwise, null.
 */
function getCleanPhoneNumber($phone)
{
    // Check for null or empty input
    if (is_null($phone) || empty($phone)) {
        return null;
    }

    // Remove all non-digit characters from the phone number
    $cleaned_phone = preg_replace('/\D/', '', $phone);

    // Check if the cleaned phone number has more than 8 digits
    if (!empty($cleaned_phone) && strlen($cleaned_phone) > 8) {
        // Return the last 8 digits of the phone number
        return substr($cleaned_phone, -8);
    }

    // Return null if the phone number is invalid
    return null;
}

function formSignStringByResult($result_data, $order_id)
{
    ksort($result_data);

    $result_str = implode(
        ';',
        array_map(function ($key, $value) {
            if ($key === 'amount') {
                return number_format($value, 2, '.', '');
            }
            return (string)$value;
        }, array_keys($result_data), $result_data)
    );

    logEvent("MIA POS sign str for order_id: $order_id, signature: $result_str");
    return $result_str;
}

function logEvent($data_message, $response = '')
{
    fn_log_event('requests', 'http', [
        'url' => '',
        'data' => $data_message,
        'response' => $response,
    ]);
}


