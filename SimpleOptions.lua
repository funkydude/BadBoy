
do
	_G["SlashCmdList"]["BADBOY_MAIN"] = function() InterfaceOptionsFrame_OpenToCategory("BadBoy") end
	_G["SLASH_BADBOY_MAIN1"] = "/badboy"

	local frame = CreateFrame("Frame", "BadBoyConfig", InterfaceOptionsFramePanelContainer)
	frame.name = "BadBoy"
	InterfaceOptions_AddCategory(frame)

	local title = frame:CreateFontString("BadBoyConfigTitle", "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText("BadBoy")

	local btnNoReportMsg = CreateFrame("CheckButton", "BadBoyConfigButton1", frame)
	btnNoReportMsg:SetWidth(26)
	btnNoReportMsg:SetHeight(26)
	btnNoReportMsg:SetPoint("TOPLEFT", 16, -52)
	if BADBOY_SILENT then
		btnNoReportMsg:SetChecked()
	end
	btnNoReportMsg:SetScript("OnClick", function(frame)
		local tick = frame:GetChecked()
		if tick then
			PlaySound("igMainMenuOptionCheckBoxOn")
			BADBOY_SILENT = true
		else
			PlaySound("igMainMenuOptionCheckBoxOff")
			BADBOY_SILENT = nil
		end
	end)

	btnNoReportMsg:SetHitRectInsets(0, -100, 0, 0)
 
	btnNoReportMsg:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
	btnNoReportMsg:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
	btnNoReportMsg:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
	btnNoReportMsg:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")

	local btnNoReportMsgText = btnNoReportMsg:CreateFontString("BadBoyConfigButton1Title", "ARTWORK", "GameFontHighlight")
	btnNoReportMsgText:SetPoint("LEFT", btnNoReportMsg, "RIGHT", 0, 1)
	btnNoReportMsgText:SetText(("Hide '%s'"):format(COMPLAINT_ADDED))

	local btnManualReport = CreateFrame("CheckButton", "BadBoyConfigButton2", frame)
	btnManualReport:SetWidth(26)
	btnManualReport:SetHeight(26)
	btnManualReport:SetPoint("TOPLEFT", 16, -82)
	if BADBOY_POPUP then
		btnManualReport:SetChecked()
	end
	btnManualReport:SetScript("OnClick", function(frame)
		local tick = frame:GetChecked()
		if tick then
			PlaySound("igMainMenuOptionCheckBoxOn")
			BADBOY_POPUP = true
		else
			PlaySound("igMainMenuOptionCheckBoxOff")
			BADBOY_POPUP = nil
		end
	end)

	btnManualReport:SetHitRectInsets(0, -100, 0, 0)
 
	btnManualReport:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
	btnManualReport:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
	btnManualReport:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
	btnManualReport:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")

	local btnManualReportText = btnManualReport:CreateFontString("BadBoyConfigButton2Title", "ARTWORK", "GameFontHighlight")
	btnManualReportText:SetPoint("LEFT", btnManualReport, "RIGHT", 0, 1)
	btnManualReportText:SetText("Disable Automatic Spam Report (Show popup)")
end

