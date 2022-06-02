[{assign var="shop"      value=$oEmailView->getShop()}]
[{assign var="oView"     value=$oEmailView->getView()}]
[{assign var="oViewConf" value=$oEmailView->getViewConfig()}]
[{assign var="currency"  value=$oEmailView->getCurrency()}]
[{assign var="user"      value=$oEmailView->getUser()}]
[{assign var="basket"    value=$order->getBasket()}]
[{assign var="oDelSet"   value=$order->getDelSet()}]
[{assign var="payment"   value=$order->getPayment()}]

[{block name="email_plain_order_owner_orderemail"}]
[{if $payment->oxuserpayments__oxpaymentsid->value == "oxempty"}]
[{oxcontent ident="oxadminordernpplainemail"}]
[{else}]
[{oxcontent ident="oxadminorderplainemail"}]
[{/if}]
[{/block}]

[{oxmultilang ident="ORDER_NUMBER"}] [{$order->oxorder__oxordernr->value}]

[{block name="email_plain_order_owner_voucherdiscount_top"}]
[{if $oViewConf->getShowVouchers()}]
[{foreach from=$order->getVoucherList() item=voucher}]
[{assign var="voucherseries" value=$voucher->getSerie()}]
[{oxmultilang ident="USED_COUPONS_2"}] [{$voucher->oxvouchers__oxvouchernr->value}] - [{oxmultilang ident="DISCOUNT"}] [{$voucherseries->oxvoucherseries__oxdiscount->value}] [{if $voucherseries->oxvoucherseries__oxdiscounttype->value == "absolute"}][{$currency->sign}][{else}]%[{/if}]
[{/foreach}]
[{/if}]
[{/block}]

[{assign var="basketitemlist" value=$basket->getBasketArticles()}]
[{foreach key=basketindex from=$basket->getContents() item=basketitem}]
[{block name="email_plain_order_ownerbasketitem"}]
[{assign var="basketproduct" value=$basketitemlist.$basketindex}]
[{$basketproduct->oxarticles__oxtitle->getRawValue()|strip_tags}][{if $basketproduct->oxarticles__oxvarselect->value}], [{$basketproduct->oxarticles__oxvarselect->value}][{/if}]
[{if $basketitem->getChosenSelList()}]
    [{foreach from=$basketitem->getChosenSelList() item=oList}]
        [{$oList->name}] [{$oList->value}]
    [{/foreach}]
[{/if}]
[{if $basketitem->getPersParams()}]
    [{block name="email_plain_order_owner_persparams"}]
        [{foreach key=persParamKey from=$basketitem->getPersParams() item=persParamValue}]
            [{include file="page/persparams/persparam.tpl" count=$persParams|@count key=$persParamKey value=$persParamValue}]
        [{/foreach}]
    [{/block}]
[{/if}]
[{if $oViewConf->getShowGiftWrapping()}]
[{assign var="oWrapping" value=$basketitem->getWrapping()}]
[{oxmultilang ident="GIFT_WRAPPING" suffix="COLON"}] [{if !$basketitem->getWrappingId()}][{oxmultilang ident="NONE"}][{else}][{$oWrapping->oxwrapping__oxname->getRawValue()}][{/if}]
[{/if}]
[{if $basketproduct->oxarticles__oxorderinfo->value}][{$basketproduct->oxarticles__oxorderinfo->getRawValue()}][{/if}]

[{assign var=dRegUnitPrice value=$basketitem->getRegularUnitPrice()}]
[{assign var=dUnitPrice value=$basketitem->getUnitPrice()}]
[{oxmultilang ident="UNIT_PRICE"}] [{oxprice price=$basketitem->getUnitPrice() currency=$currency}] [{if !$basketitem->isBundle()}] [{if $dRegUnitPrice->getPrice() > $dUnitPrice->getPrice()}] ([{oxprice price=$basketitem->getRegularUnitPrice() currency=$currency}]) [{/if}][{/if}]
[{oxmultilang ident="QUANTITY"}] [{$basketitem->getAmount()}]
[{oxmultilang ident="VAT"}] [{$basketitem->getVatPercent()}]%
[{oxmultilang ident="TOTAL"}] [{oxprice price=$basketitem->getPrice() currency=$currency}]
[{/block}]
[{/foreach}]
------------------------------------------------------------------
[{if !$basket->getDiscounts()}]
[{block name="email_plain_order_ownernodiscounttotalnet"}]
[{* netto price *}]
[{oxmultilang ident="TOTAL_NET" suffix="COLON"}] [{$basket->getProductsNetPrice()}] [{$currency->name}]
[{/block}]
[{block name="email_plain_order_ownernodiscountproductvats"}]
[{* VATs *}]
[{foreach from=$basket->getProductVats() item=VATitem key=key}]
[{oxmultilang ident="VAT_PLUS_PERCENT_AMOUNT" suffix="COLON" args=$key}] [{$VATitem}] [{$currency->name}]
[{/foreach}]
[{/block}]
[{block name="email_plain_order_nodiscountownertotalgross"}]
[{* brutto price *}]
[{oxmultilang ident="TOTAL_GROSS" suffix="COLON"}] [{$basket->getFProductsPrice()}] [{$currency->name}]
[{/block}]
[{/if}]

[{* applied discounts *}]
[{if $basket->getDiscounts()}]
[{if $order->isNettoMode()}]
[{block name="email_plain_order_ownerdiscounttotalnet"}]
[{* netto price *}]
[{oxmultilang ident="TOTAL_NET" suffix="COLON"}] [{$basket->getProductsNetPrice()}] [{$currency->name}]
[{/block}]
[{else}]
[{block name="email_plain_order_discountownertotalgross"}]
[{* brutto price *}]
[{oxmultilang ident="TOTAL_GROSS" suffix="COLON"}] [{$basket->getFProductsPrice()}] [{$currency->name}]
[{/block}]
[{/if}]
[{block name="email_plain_order_ownerdiscounts"}]
  [{foreach from=$basket->getDiscounts() item=oDiscount}]
  [{if $oDiscount->dDiscount < 0}][{oxmultilang ident="SURCHARGE"}][{else}][{oxmultilang ident="DISCOUNT"}][{/if}] [{$oDiscount->sDiscount}] [{oxmultilang ident="COLON"}] [{if $oDiscount->dDiscount < 0}][{$oDiscount->fDiscount|replace:"-":""}][{else}]-[{$oDiscount->fDiscount}][{/if}] [{$currency->name}]
  [{/foreach}]
[{/block}]
[{if !$order->isNettoMode()}]
[{block name="email_plain_order_ownertotalnet"}]
  [{* netto price *}]
  [{oxmultilang ident="TOTAL_NET" suffix="COLON"}] [{$basket->getProductsNetPrice()}] [{$currency->name}]
[{/block}]
[{/if}]
[{block name="email_plain_order_ownerproductvats"}]
  [{* VATs *}]
  [{foreach from=$basket->getProductVats() item=VATitem key=key}]
    [{oxmultilang ident="VAT_PLUS_PERCENT_AMOUNT" suffix="COLON" args=$key}] [{$VATitem}] [{$currency->name}]
  [{/foreach}]
[{/block}]
[{/if}]
[{if $order->isNettoMode()}]
[{block name="email_plain_order_ownertotalgross"}]
[{* brutto price *}]
[{oxmultilang ident="TOTAL_GROSS" suffix="COLON"}] [{$basket->getFProductsPrice()}] [{$currency->name}]
[{/block}]
[{/if}]
[{block name="email_plain_order_owner_voucherdiscount"}]
[{* voucher discounts *}]
[{if $oViewConf->getShowVouchers() && $basket->getVoucherDiscValue()}]
[{oxmultilang ident="COUPON" suffix="COLON"}] [{if $basket->getFVoucherDiscountValue() > 0}]-[{/if}][{$basket->getFVoucherDiscountValue()|replace:"-":""}] [{$currency->name}]
[{/if}]
[{/block}]
[{block name="email_plain_order_ownerdelcosts"}]
[{* delivery costs *}]
[{if $basket->getDelCostNet()}]
    [{oxmultilang ident="SHIPPING_NET" suffix="COLON"}] [{$basket->getDelCostNet()}] [{$currency->sign}]
    [{if $basket->getDelCostVat()}] [{oxmultilang ident="BASKET_TOTAL_PLUS_PROPORTIONAL_VAT"}] [{else}] [{oxmultilang ident="VAT_PLUS_PERCENT_AMOUNT" suffix="COLON" args=$basket->getDelCostVatPercent()}][{/if}] [{$basket->getDelCostVat()}] [{$currency->sign}]
[{elseif $basket->getFDeliveryCosts()}]
    [{oxmultilang ident="SHIPPING_COST"}] [{$basket->getFDeliveryCosts()}] [{$currency->sign}]
[{/if}]
[{/block}]
[{block name="email_plain_order_ownerpaymentcosts"}]
[{* payment sum *}]
[{if $basket->getPayCostNet()}]
    [{if $basket->getPaymentCosts() >= 0}][{oxmultilang ident="SURCHARGE"}][{else}][{oxmultilang ident="DEDUCTION"}][{/if}] [{oxmultilang ident="PAYMENT_METHOD" suffix="COLON"}] [{$basket->getPayCostNet()}] [{$currency->sign}]
    [{if $basket->getPayCostVat()}]
        [{if $basket->isProportionalCalculationOn()}] [{oxmultilang ident="BASKET_TOTAL_PLUS_PROPORTIONAL_VAT"}][{else}] [{oxmultilang ident="VAT_PLUS_PERCENT_AMOUNT" suffix="COLON" args=$basket->getPayCostVatPercent()}][{/if}] [{$basket->getPayCostVat()}] [{$currency->sign}]
    [{/if}]
[{elseif $basket->getFPaymentCosts()}]
    [{oxmultilang ident="SURCHARGE"}] [{$basket->getFPaymentCosts()}] [{$currency->sign}]
[{/if}]
[{/block}]

[{block name="email_plain_order_giftwrapping"}]
[{* Gift wrapping *}]
[{if $oViewConf->getShowGiftWrapping()}]
    [{if $basket->getWrappCostNet()}]
        [{oxmultilang ident="BASKET_TOTAL_WRAPPING_COSTS_NET"}] [{$basket->getWrappCostNet()}] [{$currency->sign}]
        [{if $basket->getWrappCostVat()}]
            [{oxmultilang ident="PLUS_VAT"}] [{$basket->getWrappCostVat()}] [{$currency->sign}]
        [{/if}]
    [{elseif $basket->getFWrappingCosts()}]
        [{oxmultilang ident="GIFT_WRAPPING"}] [{$basket->getFWrappingCosts()}] [{$currency->sign}]
    [{/if}]
[{/if}]
[{/block}]

[{block name="email_plain_order_cust_greetingcard"}]
[{* Greeting card *}]
[{if $oViewConf->getShowGiftWrapping()}]
    [{if $basket->getGiftCardCostNet()}]
        [{oxmultilang ident="BASKET_TOTAL_GIFTCARD_COSTS_NET"}] [{$basket->getGiftCardCostNet()}] [{$currency->sign}]
        [{if $basket->getGiftCardCostVat()}]
            [{if $basket->isProportionalCalculationOn()}][{oxmultilang ident="BASKET_TOTAL_PLUS_PROPORTIONAL_VAT"}][{else}] [{oxmultilang ident="VAT_PLUS_PERCENT_AMOUNT" suffix="COLON" args=$basket->getGiftCardCostVatPercent()}][{/if}] [{$basket->getGiftCardCostVat()}] [{$currency->sign}]
        [{/if}]
    [{elseif $basket->getFGiftCardCosts()}]
        [{oxmultilang ident="GREETING_CARD"}] [{$basket->getFGiftCardCosts()}] [{$currency->sign}]
    [{/if}]
[{/if}]
[{/block}]

[{block name="email_plain_order_ownergrandtotal"}]
[{* grand total price *}]
[{oxmultilang ident="GRAND_TOTAL" suffix="COLON"}] [{$basket->getFPrice()}] [{$currency->name}]
[{if $basket->oCard}]
    [{oxmultilang ident="ATENTION_GREETING_CARD"  suffix='COLON'}]
    [{oxmultilang ident="WHAT_I_WANTED_TO_SAY"}]
    [{$basket->getCardMessage()}]
[{/if}]
[{/block}]

[{block name="email_plain_order_owneruserremark"}]
[{if $order->oxorder__oxremark->value}]
[{oxmultilang ident="MESSAGE" suffix="COLON"}] [{$order->oxorder__oxremark->getRawValue()}]
[{/if}]
[{/block}]

[{block name="email_plain_order_ownerpaymentinfo"}]
[{if $payment->oxuserpayments__oxpaymentsid->value != "oxempty"}][{oxmultilang ident="PAYMENT_INFORMATION" suffix="COLON"}]
[{oxmultilang ident="PAYMENT_METHOD" suffix="COLON"}][{$payment->oxpayments__oxdesc->getRawValue()}] [{if $basket->getPaymentCosts()}]([{$basket->getFPaymentCosts()}] [{$currency->sign}])[{/if}]
[{oxmultilang ident="PAYMENT_INFO_OFF"}]
[{*
[{foreach from=$payment->aDynValues item=value}]
[{assign var="ident" value='EMAIL_ORDER_OWNER_HTML_'|cat:$value->name}]
[{assign var="ident" value=$ident|oxupper}]
[{oxmultilang ident=$ident suffix="COLON"}] [{$value->value}]
[{/foreach}]
*}]
[{/if}]
[{/block}]

[{block name="email_plain_order_ownerusername"}]
[{oxmultilang ident="EMAIL_ADDRESS" suffix="COLON"}] [{$user->oxuser__oxusername->value}]
[{/block}]

[{block name="email_plain_order_owneraddress"}]
[{oxmultilang ident="BILLING_ADDRESS" suffix="COLON"}]
[{include file="email/plain/inc/billing_address.tpl"}]


[{if $order->oxorder__oxdellname->value}]
[{oxmultilang ident="SHIPPING_ADDRESS" suffix="COLON"}]
[{include file="email/plain/inc/shipping_address.tpl"}]
[{/if}]
[{/block}]

[{block name="email_plain_order_ownerdeliveryinfo"}]
[{if $payment->oxuserpayments__oxpaymentsid->value != "oxempty"}][{oxmultilang ident="SHIPPING_CARRIER" suffix="COLON"}] [{$order->oDelSet->oxdeliveryset__oxtitle->getRawValue()}]
[{/if}]
[{/block}]

[{oxcontent ident="oxemailfooterplain"}]
