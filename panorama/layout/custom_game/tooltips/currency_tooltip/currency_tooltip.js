const TOOLTIP_PANELS =
{
    TooltipHeaderLabel : $("#TooltipHeaderLabel"),
    TooltipDescriptionLabel : $("#TooltipDescriptionLabel"),
}

function UpdateTooltip()
{
    let parent = $.GetContextPanel().GetParent().GetParent();

    let header_text = $.GetContextPanel().GetAttributeString("header", "")
    let description_text = $.GetContextPanel().GetAttributeString("description", "")
    let description_text_2 = $.GetContextPanel().GetAttributeString("description_2", "")

    $("#CurrencyName").text = $.Localize("#"+header_text)
    $("#SpendType").text = $.Localize("#"+description_text)
    $("#IncomeType").text = $.Localize("#"+description_text_2)
}