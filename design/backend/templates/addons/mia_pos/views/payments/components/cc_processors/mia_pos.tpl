{if $addons.mia_pos.status == "ObjectStatuses::DISABLED"|enum}
    <div class="alert alert-block">
        <p>
            {__("mia_pos.addon_is_disabled")}
        </p>
    </div>
{else}
    {$order_statuses = $smarty.const.STATUSES_ORDER|fn_get_statuses}

    <h4>{__("mia_pos.configuration_merchants")}</h4>

    <div class="control-group">
        <label class="control-label" for="mia_pos_merchant_id">
            {__("mia_pos.merchant_id")}:
        </label>
        <div class="controls">
            <input name="payment_data[processor_params][merchant_id]" id="mia_pos_merchant_id" type="text" value="{if $processor_params.merchant_id}{$processor_params.merchant_id}{/if}">
            <p class="muted description">
                {__("mia_pos.merchant_id_description")}
            </p>
        </div>
    </div>

    <div class="control-group">
        <label class="control-label" for="mia_pos_secret_key">
            {__("mia_pos.secret_key")}:
        </label>
        <div class="controls">
            <input name="payment_data[processor_params][secret_key]" id="mia_pos_secret_key" type="text" value="{if $processor_params.secret_key}{$processor_params.secret_key}{/if}">
            <p class="muted description">
                {__("mia_pos.secret_key_description")}
            </p>
        </div>
    </div>

    <div class="control-group">
        <label class="control-label" for="mia_pos_terminal_id">
            {__("mia_pos.terminal_id")}:
        </label>
        <div class="controls">
            <input name="payment_data[processor_params][terminal_id]" id="mia_pos_terminal_id" type="text" value="{if $processor_params.terminal_id}{$processor_params.terminal_id}{/if}">
            <p class="muted description">
                {__("mia_pos.terminal_id_description")}
            </p>
        </div>
    </div>

    <div class="control-group">
        <label class="control-label" for="mia_pos_base_url">
            {__("mia_pos.base_url")}:
        </label>
        <div class="controls">
            <input name="payment_data[processor_params][base_url]" id="mia_pos_base_url" type="text" value="{if $processor_params.base_url}{$processor_params.base_url}{else}https://ecomm.mia-pos.md{/if}">
            <p class="muted description">
                {__("mia_pos.base_url_description")}
            </p>
        </div>
    </div>

    <div class="control-group">
        <label class="control-label" for="mia_pos_payment_type">
            {__("mia_pos.payment_type")}:
        </label>
        <div class="controls">
            <select name="payment_data[processor_params][payment_type]" id="mia_pos_payment_type">
                <option value="qr" {if $processor_params.payment_type == 'qr'}selected{/if}>
                    {__("mia_pos.payment_type_qr")}
                </option>
                <option value="rtp" {if $processor_params.payment_type == 'rtp'}selected{/if}>
                    {__("mia_pos.payment_type_rtp")}
                </option>
            </select>
            <p class="muted description">
                {__("mia_pos.payment_type_description")}
            </p>
        </div>
    </div>

    <div class="control-group">
        <label class="control-label" for="mia_pos_language">
            {__("mia_pos.language")}:
        </label>
        <div class="controls">
            <select name="payment_data[processor_params][language]" id="mia_pos_language">
                <option value="ro" {if $processor_params.language == 'ro'}selected{/if}>
                    {__("mia_pos.language_ro")}
                </option>
                <option value="ru" {if $processor_params.language == 'ru'}selected{/if}>
                    {__("mia_pos.language_ru")}
                </option>
                <option value="en" {if $processor_params.language == 'en'}selected{/if}>
                    {__("mia_pos.language_en")}
                </option>
            </select>
            <p class="muted description">
                {__("mia_pos.language_description")}
            </p>
        </div>
    </div>

    <div class="control-group">
        <label class="control-label" for="mia_pos_ok_url">
            {__("mia_pos.ok_url")}:
        </label>
        <div class="controls">
            <p>
                {fn_url('payment_notification.success?payment=mia_pos', 'C')}
            </p>
            <p class="muted description">
                {__("mia_pos.ok_url_description")}
            </p>
        </div>
    </div>

    <div class="control-group">
        <label class="control-label" for="mia_pos_fail_url">
            {__("mia_pos.fail_url")}:
        </label>
        <div class="controls">
            <p>
                {fn_url('payment_notification.fail?payment=mia_pos', 'C')}
            </p>
            <p class="muted description">
                {__("mia_pos.fail_url_description")}
            </p>
        </div>
    </div>

    <div class="control-group">
        <label class="control-label" for="mia_pos_callback_url">
            {__("mia_pos.callback_url")}:
        </label>
        <div class="controls">
            <p>
                {fn_url('payment_notification.return?payment=mia_pos', 'C')}
            </p>
            <p class="muted description">
                {__("mia_pos.callback_url_description")}
            </p>
        </div>
    </div>

    <h4>{__("mia_pos.configuration_order_status")}</h4>

    <div class="control-group">
        <label class="control-label" for="mia_pos_pending_status_id">
            {__("mia_pos.pending_status_id")}:
        </label>
        <div class="controls">
            <select name="payment_data[processor_params][pending_status_id]" id="mia_pos_pending_status_id">
                {foreach from=$order_statuses item="order_status" key="key"}
                    <option value="{$order_statuses[$key].status}" {if $processor_params.pending_status_id == $order_statuses[$key].status}selected{/if}>
                        {$order_statuses[$key].description}
                    </option>
                {/foreach}
            </select>
        </div>
    </div>

    <div class="control-group">
        <label class="control-label" for="mia_pos_completed_status_id">{__("mia_pos.completed_status_id")}:</label>
        <div class="controls">
            <select name="payment_data[processor_params][completed_status_id]" id="mia_pos_completed_status_id">
                {foreach from=$order_statuses item="order_status" key="key"}
                    <option value="{$order_statuses[$key].status}" {if $processor_params.completed_status_id == $order_statuses[$key].status}selected{/if}>
                        {$order_statuses[$key].description}
                    </option>
                {/foreach}
            </select>
        </div>
    </div>

    <div class="control-group">
        <label class="control-label" for="mia_pos_failed_status_id">{__("mia_pos.failed_status_id")}:</label>
        <div class="controls">
            <select name="payment_data[processor_params][failed_status_id]" id="mia_pos_failed_status_id">
                {foreach from=$order_statuses item="order_status" key="key"}
                    <option value="{$order_statuses[$key].status}" {if $processor_params.failed_status_id == $order_statuses[$key].status}selected{/if}>
                        {$order_statuses[$key].description}
                    </option>
                {/foreach}
            </select>
        </div>
    </div>
{/if}
