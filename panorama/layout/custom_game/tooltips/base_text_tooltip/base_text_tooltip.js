const TOOLTIP_PANELS =
{
    TooltipHeaderLabel : $("#TooltipHeaderLabel"),
    TooltipDescriptionLabel : $("#TooltipDescriptionLabel"),
}

function UpdateTooltip()
{
    let header_text = $.GetContextPanel().GetAttributeString("header", "")
    let description_text = $.GetContextPanel().GetAttributeString("description", "")
    TOOLTIP_PANELS.TooltipHeaderLabel.text = $.Localize("#"+header_text)
    TOOLTIP_PANELS.TooltipDescriptionLabel.text = $.Localize("#"+description_text)
}