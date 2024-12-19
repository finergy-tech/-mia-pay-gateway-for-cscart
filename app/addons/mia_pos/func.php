<?php

if (!defined('AREA')) {
    die('Access denied');
}

/**
 * Installs MIA POS payment processor
 *
 * @return void
 */
function fn_mia_pos_install()
{
    /** @var \Tygh\Database\Connection $db */
    $db = Tygh::$app['db'];

    if ($db->getField('SELECT processor_id FROM ?:payment_processors WHERE processor_script = ?s', 'mia_pos.php')) {
        return;
    }

    $db->query(
        'INSERT INTO ?:payment_processors ?e',
        [
            'processor'          => 'MIA POS',
            'processor_script'   => 'mia_pos.php',
            'processor_template' => 'views/orders/components/payments/cc_outside.tpl',
            'admin_template'     => 'mia_pos.tpl',
            'callback'           => 'N',
            'type'               => 'P',
            'addon'              => 'mia_pos',
        ]
    );
}

/**
 * Disables MIA POS payment methods when the module is removed
 *
 * @return void
 */
function fn_mia_pos_uninstall()
{
    /** @var \Tygh\Database\Connection $db */
    $db = Tygh::$app['db'];

    $processor_id = $db->getField(
        'SELECT processor_id FROM ?:payment_processors WHERE processor_script = ?s',
        'mia_pos.php'
    );

    if (!$processor_id) {
        return;
    }

    $db->query('DELETE FROM ?:payment_processors WHERE processor_id = ?i', $processor_id);

    $db->query(
        'UPDATE ?:payments SET ?u WHERE processor_id = ?i',
        [
            'processor_id'     => 0,
            'processor_params' => '',
            'status'           => 'D',
        ],
        $processor_id
    );

    $db->query("DELETE FROM ?:language_values WHERE name LIKE '%mia_pos.%'");

    $db->query('DROP TABLE IF EXISTS ?:mia_pos_payments');
}
