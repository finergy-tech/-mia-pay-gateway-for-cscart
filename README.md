# MIA POS Payment Gateway for CS-Cart

Integrate the **MIA POS** payment system into your CS-Cart store to accept online payments via QR codes and Request to Pay (RTP).

## Description

MIA POS, provided by Finergy Tech, allows secure payment processing using QR codes and direct payment requests. This module supports automatic order status updates and multilingual integration.

### Features
- Accept payments via QR codes.
- Support for Request to Pay (RTP) payments.
- Automatic order status updates.
- Secure signature-based payment processing.
- Multilingual support: RO, RU, EN.

## Requirements
- MIA POS account registration with Finergy Tech.
- CS-Cart version **4.7.2+**.
- PHP 7.2 or higher.
- Enabled PHP extensions: **curl**, **json**.
- Active SSL certificate for secure transactions.

## Installation
1. Download the MIA POS module archive.
2. In the CS-Cart admin panel, go to **Add-ons** > **Manage add-ons**.
3. Upload the MIA POS module using the **Upload & Install** button.
4. Once installed, go to **Administration** > **Payment methods** and click “+” to add a new payment method.
5. In the **Processor** dropdown menu, find and select **MIA POS**.
6. Configure the required settings in the **Configure** tab and save.

## Settings
1. **Merchant ID**: Your unique MIA POS merchant identifier.
2. **Terminal ID**: Provided by MIA POS during registration.
3. **Secret Key**: Secret key for API authentication.
4. **API Base URL**: Endpoint for communication with MIA POS API.
5. **Order Statuses**:
    - **Pending Payment**: Status when the payment is pending.
    - **Successful Payment**: Status when the payment is completed successfully.
    - **Failed Payment**: Status when the payment fails.
6. **Language**: Choose the preferred language for the payment page (RO, RU, EN).

## Testing
1. Use the MIA POS test environment and credentials provided by Finergy Tech.
2. Simulate payments using test QR codes and validate order status updates.
3. Verify callback notifications for successful and failed payments.

## Support
For any issues or questions, please contact:
- Website: [https://finergy.md/](https://finergy.md/)
- Email: [info@finergy.md](mailto:info@finergy.md)
