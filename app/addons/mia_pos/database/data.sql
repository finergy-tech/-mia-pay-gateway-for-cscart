DELETE FROM ?:payment_processors
WHERE processor_script = 'mia_pos.php';

INSERT INTO ?:payment_processors
    (processor, processor_script, processor_template, admin_template, callback, type, addon)
VALUES
    ('MIA POS', 'mia_pos.php', 'views/orders/components/payments/cc_outside.tpl', 'mia_pos.tpl', 'N', 'P', 'mia_pos');

DELETE FROM ?:language_values WHERE name LIKE '%mia_pos.%';

INSERT INTO ?:language_values (lang_code, name, value) VALUES
    ('en', 'mia_pos.addon_is_disabled', 'Addon is disabled'),
    ('ro', 'mia_pos.addon_is_disabled', 'Modulul nu este activ'),
    ('ru', 'mia_pos.addon_is_disabled', 'Модуль выключен'),

    ('en', 'mia_pos.configuration_merchants', 'MIA POS Configuration'),
    ('ro', 'mia_pos.configuration_merchants', 'Configurare MIA POS'),
    ('ru', 'mia_pos.configuration_merchants', 'Конфигурация MIA POS'),

    ('en', 'mia_pos.merchant_id', 'Merchant ID'),
    ('ro', 'mia_pos.merchant_id', 'ID Comerciant'),
    ('ru', 'mia_pos.merchant_id', 'ID Мерчанта'),

    ('en', 'mia_pos.merchant_id_description', 'Your unique Merchant ID provided by MIA POS.'),
    ('ro', 'mia_pos.merchant_id_description', 'ID-ul unic al comerciantului oferit de MIA POS.'),
    ('ru', 'mia_pos.merchant_id_description', 'Уникальный ID мерчанта, предоставленный MIA POS.'),

    ('en', 'mia_pos.secret_key', 'Secret Key'),
    ('ro', 'mia_pos.secret_key', 'Cheia Secretă'),
    ('ru', 'mia_pos.secret_key', 'Секретный ключ'),

    ('en', 'mia_pos.secret_key_description', 'The secret key for API authentication.'),
    ('ro', 'mia_pos.secret_key_description', 'Cheia secretă pentru autentificarea API.'),
    ('ru', 'mia_pos.secret_key_description', 'Секретный ключ для аутентификации API.'),

    ('en', 'mia_pos.terminal_id', 'Terminal ID'),
    ('ro', 'mia_pos.terminal_id', 'ID Terminal'),
    ('ru', 'mia_pos.terminal_id', 'ID Терминала'),

    ('en', 'mia_pos.terminal_id_description', 'The terminal ID provided by MIA POS.'),
    ('ro', 'mia_pos.terminal_id_description', 'ID-ul terminalului oferit de MIA POS.'),
    ('ru', 'mia_pos.terminal_id_description', 'ID терминала, предоставленный MIA POS.'),

    ('en', 'mia_pos.base_url', 'API Base URL'),
    ('ro', 'mia_pos.base_url', 'URL de bază API'),
    ('ru', 'mia_pos.base_url', 'Базовый URL API'),

    ('en', 'mia_pos.base_url_description', 'Enter the API base URL for MIA POS integration. Default: https://ecomm.mia-pos.md'),
    ('ro', 'mia_pos.base_url_description', 'Introduceți URL-ul de bază al API pentru integrarea MIA POS. Implicit: https://ecomm.mia-pos.md'),
    ('ru', 'mia_pos.base_url_description', 'Введите базовый URL API для интеграции MIA POS. По умолчанию: https://ecomm.mia-pos.md'),

    ('en', 'mia_pos.payment_type', 'Payment Type'),
    ('ro', 'mia_pos.payment_type', 'Tip de plată'),
    ('ru', 'mia_pos.payment_type', 'Тип оплаты'),

    ('en', 'mia_pos.payment_type_qr', 'QR Payment'),
    ('ro', 'mia_pos.payment_type_qr', 'Plată QR'),
    ('ru', 'mia_pos.payment_type_qr', 'QR Оплата'),

    ('en', 'mia_pos.payment_type_rtp', 'Request to Pay'),
    ('ro', 'mia_pos.payment_type_rtp', 'Solicitare de plată'),
    ('ru', 'mia_pos.payment_type_rtp', 'Запрос на оплату'),

    ('en', 'mia_pos.payment_type_description', 'Choose between QR Code payment or Request to Pay.'),
    ('ro', 'mia_pos.payment_type_description', 'Alegeți între plata prin cod QR sau Solicitați Plată.'),
    ('ru', 'mia_pos.payment_type_description', 'Выберите между оплатой QR-кодом или запросом на оплату.'),

    ('en', 'mia_pos.language', 'Language'),
    ('ro', 'mia_pos.language', 'Limbă'),
    ('ru', 'mia_pos.language', 'Язык'),

    ('en', 'mia_pos.language_ro', 'Romanian'),
    ('ro', 'mia_pos.language_ro', 'Română'),
    ('ru', 'mia_pos.language_ro', 'Румынский'),

    ('en', 'mia_pos.language_ru', 'Russian'),
    ('ro', 'mia_pos.language_ru', 'Rusă'),
    ('ru', 'mia_pos.language_ru', 'Русский'),

    ('en', 'mia_pos.language_en', 'English'),
    ('ro', 'mia_pos.language_en', 'Engleză'),
    ('ru', 'mia_pos.language_en', 'Английский'),

    ('en', 'mia_pos.language_description', 'Select the language to be used for the payment page.'),
    ('ro', 'mia_pos.language_description', 'Selectați limba care va fi utilizată pentru pagina de plată.'),
    ('ru', 'mia_pos.language_description', 'Выберите язык, который будет использоваться на странице оплаты.'),

    ('en', 'mia_pos.ok_url', 'Ok URL'),
    ('ro', 'mia_pos.ok_url', 'Ok URL'),
    ('ru', 'mia_pos.ok_url', 'Ok URL'),

    ('en', 'mia_pos.ok_url_description', 'Add this URL to the Ok URL field in the MIA POS settings.'),
    ('ro', 'mia_pos.ok_url_description', 'Adăugați acest URL în câmpul Ok URL din setările MIA POS.'),
    ('ru', 'mia_pos.ok_url_description', 'Добавьте этот URL в поле Ok URL в настройках MIA POS.'),

    ('en', 'mia_pos.fail_url', 'Fail URL'),
    ('ro', 'mia_pos.fail_url', 'Fail URL'),
    ('ru', 'mia_pos.fail_url', 'Fail URL'),

    ('en', 'mia_pos.fail_url_description', 'Add this URL to the Fail URL field in the MIA POS settings.'),
    ('ro', 'mia_pos.fail_url_description', 'Adăugați acest URL în câmpul Fail URL din setările MIA POS.'),
    ('ru', 'mia_pos.fail_url_description', 'Добавьте этот URL в поле Fail URL в настройках MIA POS.'),

    ('en', 'mia_pos.callback_url', 'Callback URL'),
    ('ro', 'mia_pos.callback_url', 'Callback URL'),
    ('ru', 'mia_pos.callback_url', 'Callback URL'),

    ('en', 'mia_pos.callback_url_description', 'Add this URL to the Callback URL field in the MIA POS settings.'),
    ('ro', 'mia_pos.callback_url_description', 'Adăugați acest URL în câmpul Callback URL din setările MIA POS.'),
    ('ru', 'mia_pos.callback_url_description', 'Добавьте этот URL в поле Callback URL в настройках MIA POS.'),

    ('en', 'mia_pos.payment_error', 'Payment failed! Please try again. [error]'),
    ('ro', 'mia_pos.payment_error', 'Plata a eșuat! Vă rugăm să încercați din nou. [error]'),
    ('ru', 'mia_pos.payment_error', 'Оплата не удалась! Пожалуйста, попробуйте снова. [error]'),

    ('en', 'mia_pos.configuration_order_status', 'Order Status Configuration'),
    ('ro', 'mia_pos.configuration_order_status', 'Configurare stare comandă'),
    ('ru', 'mia_pos.configuration_order_status', 'Настройка статуса заказа'),

    ('en', 'mia_pos.pending_status_id', 'Pending Payment'),
    ('ro', 'mia_pos.pending_status_id', 'Plată în așteptare'),
    ('ru', 'mia_pos.pending_status_id', 'Ожидание оплаты'),

    ('en', 'mia_pos.completed_status_id', 'Completed Payment'),
    ('ro', 'mia_pos.completed_status_id', 'Plată completată'),
    ('ru', 'mia_pos.completed_status_id', 'Оплата завершена'),

    ('en', 'mia_pos.failed_status_id', 'Failed Payment'),
    ('ro', 'mia_pos.failed_status_id', 'Plată eșuată'),
    ('ru', 'mia_pos.failed_status_id', 'Ошибка оплаты'),

    ('en', 'mia_pos.error_no_order', 'Order information is missing or invalid.'),
    ('ro', 'mia_pos.error_no_order', 'Informațiile despre comandă lipsesc sau sunt invalide.'),
    ('ru', 'mia_pos.error_no_order', 'Информация о заказе отсутствует или недействительна.'),

    ('en', 'mia_pos.error_configuration', 'MIA POS configuration is incomplete. Please check the settings.'),
    ('ro', 'mia_pos.error_configuration', 'Configurarea MIA POS este incompletă. Verificați setările.'),
    ('ru', 'mia_pos.error_configuration', 'Конфигурация MIA POS неполная. Проверьте настройки.'),

    ('en', 'mia_pos.error_currency_not_supported', 'Only MDL currency is supported by MIA POS.'),
    ('ro', 'mia_pos.error_currency_not_supported', 'Doar valuta MDL este acceptată de MIA POS.'),
    ('ru', 'mia_pos.error_currency_not_supported', 'Поддерживается только валюта MDL в MIA POS.'),

    ('en', 'mia_pos.text_order_description', 'Order #%s payment.'),
    ('ro', 'mia_pos.text_order_description', 'Plată pentru comanda #%s.'),
    ('ru', 'mia_pos.text_order_description', 'Оплата заказа №%s.'),

    ('en', 'mia_pos.error_invalid_response', 'Invalid response received from MIA POS. Please try again.'),
    ('ro', 'mia_pos.error_invalid_response', 'Răspuns invalid primit de la MIA POS. Vă rugăm să încercați din nou.'),
    ('ru', 'mia_pos.error_invalid_response', 'Получен некорректный ответ от MIA POS. Пожалуйста, попробуйте снова.'),

    ('en', 'mia_pos.payment_failed_note', 'Payment failed: [error]'),
    ('ro', 'mia_pos.payment_failed_note', 'Plata a eșuat: [error]'),
    ('ru', 'mia_pos.payment_failed_note', 'Оплата не удалась: [error]'),

    ('en', 'mia_pos.error', 'Error'),
    ('ro', 'mia_pos.error', 'Eroare'),
    ('ru', 'mia_pos.error', 'Ошибка'),

    ('en', 'mia_pos.error_invalid_request', 'Invalid request: Missing or incorrect data.'),
    ('ro', 'mia_pos.error_invalid_request', 'Cerere invalidă: Date lipsă sau incorecte.'),
    ('ru', 'mia_pos.error_invalid_request', 'Неверный запрос: отсутствуют или некорректные данные.'),

    ('en', 'mia_pos.error_invalid_session', 'Session expired or invalid. Please try again.'),
    ('ro', 'mia_pos.error_invalid_session', 'Sesiune expirată sau invalidă. Vă rugăm să încercați din nou.'),
    ('ru', 'mia_pos.error_invalid_session', 'Сессия истекла или недействительна. Пожалуйста, попробуйте снова.'),

    ('en', 'mia_pos.error_payment_id_not_found', 'Payment not found. Please try again or contact support.'),
    ('ro', 'mia_pos.error_payment_id_not_found', 'Plata nu a fost găsită. Vă rugăm să încercați din nou sau să contactați suportul.'),
    ('ru', 'mia_pos.error_payment_id_not_found', 'Платеж не найден. Пожалуйста, попробуйте снова или свяжитесь с поддержкой.'),

    ('en', 'mia_pos.payment_failed', 'Payment failed. Please try another method or contact support.'),
    ('ro', 'mia_pos.payment_failed', 'Plata a eșuat. Vă rugăm să încercați o altă metodă sau să contactați suportul.'),
    ('ru', 'mia_pos.payment_failed', 'Платеж не удался. Попробуйте другой метод или свяжитесь с поддержкой.'),

    ('en', 'mia_pos.error_payment_verification', 'Payment verification failed. Please contact support.'),
    ('ro', 'mia_pos.error_payment_verification', 'Verificarea plății a eșuat. Vă rugăm să contactați suportul.'),
    ('ru', 'mia_pos.error_payment_verification', 'Проверка платежа не удалась. Пожалуйста, свяжитесь с поддержкой.');


CREATE TABLE IF NOT EXISTS ?:mia_pos_payments (
        id INT AUTO_INCREMENT PRIMARY KEY,
        order_id INT NOT NULL,
        payment_id VARCHAR(255) NOT NULL,
        salt VARCHAR(255) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        UNIQUE KEY order_payment (order_id)
    );