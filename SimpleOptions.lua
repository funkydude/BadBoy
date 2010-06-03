
do
	--Slash handler
	_G["SlashCmdList"]["BADBOY_MAIN"] = function() InterfaceOptionsFrame_OpenToCategory("BadBoy") end
	_G["SLASH_BADBOY_MAIN1"] = "/badboy"

	--Locale
	local locNoReportMsg = "Hide '%s' message"
	local locManualReport = "Disable Automatic Spam Report (Show popup)"
	local locNoArtTitle = "Disable ASCII art filter"
	local locNoArtDesc = "This filter is designed to remove gold spam lines with repetitive symbols like '-' and '+' |cFF33FF99ONLY|r from public channels (gen/trade/LFG/etc) but can sometimes filter innocent players that use |cFF33FF99A LOT|r of '.' or '!' which most people consider spam anyway."
	local L = GetLocale()
	if L == "frFR" then
		locNoReportMsg = "Cacher le message '%s'"
		locManualReport = "Désactiver le signalement auto. du spam (affiche un popup)"
	elseif L == "deDE" then
		locNoReportMsg = "'%s' Meldung verbergen"
		locManualReport = "Automatische Spam-Meldungen deaktivieren (Pop-Up anzeigen)"
	elseif L == "zhTW" then
		locNoReportMsg = "隱藏 '%s' 信息"
		locManualReport = "禁用信息自動過濾系統(顯示彈出)"
		BADBOY_NOLATIN = true
	elseif L == "zhCN" then
		locNoReportMsg = "隐藏 '%s' 信息"
		locManualReport = "禁用信息自动过滤系统(显示弹出)"
		BADBOY_NOLATIN = true
	elseif L == "esES" or L == "esMX" then
		locNoReportMsg = "Ocultar el mensaje '%s'"
		locManualReport = "Desactivar Reporte Automático de Spam (Mostrar popup)"
	elseif L == "koKR" or L == "ruRU" then
		BADBOY_NOLATIN = true
	end

	--Begin GUI
	local badboy = CreateFrame("Frame", "BadBoyConfig", InterfaceOptionsFramePanelContainer)
	badboy:Hide()
	badboy.name = "BadBoy"
	InterfaceOptions_AddCategory(badboy)

	local title = badboy:CreateFontString("BadBoyConfigTitle", "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText("BadBoy")

	local btnNoReportMsg = CreateFrame("CheckButton", "BadBoyConfigButton1", badboy)
	btnNoReportMsg:SetWidth(26)
	btnNoReportMsg:SetHeight(26)
	btnNoReportMsg:SetPoint("TOPLEFT", 16, -52)
	btnNoReportMsg:SetScript("OnShow", function(frame)
		if BADBOY_SILENT then
			frame:SetChecked(true)
		else
			frame:SetChecked(false)
		end
	end)
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
	btnNoReportMsgText:SetText((locNoReportMsg):format(COMPLAINT_ADDED))

	local btnManualReport = CreateFrame("CheckButton", "BadBoyConfigButton2", badboy)
	btnManualReport:SetWidth(26)
	btnManualReport:SetHeight(26)
	btnManualReport:SetPoint("TOPLEFT", 16, -82)
	btnManualReport:SetScript("OnShow", function(frame)
		if BADBOY_POPUP then
			frame:SetChecked(true)
		else
			frame:SetChecked(false)
		end
	end)
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
	btnManualReportText:SetText(locManualReport)

	local btnNoArtFilter = CreateFrame("CheckButton", "BadBoyConfigButton3", badboy)
	btnNoArtFilter:SetWidth(26)
	btnNoArtFilter:SetHeight(26)
	btnNoArtFilter:SetPoint("TOPLEFT", 16, -112)
	btnNoArtFilter:SetScript("OnShow", function(frame)
		if BADBOY_ALLOWART then
			frame:SetChecked(true)
		else
			frame:SetChecked(false)
		end
	end)
	btnNoArtFilter:SetScript("OnClick", function(frame)
		local tick = frame:GetChecked()
		if tick then
			PlaySound("igMainMenuOptionCheckBoxOn")
			BADBOY_ALLOWART = true
		else
			PlaySound("igMainMenuOptionCheckBoxOff")
			BADBOY_ALLOWART = nil
		end
	end)

	btnNoArtFilter:SetHitRectInsets(0, -100, 0, 0)

	btnNoArtFilter:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
	btnNoArtFilter:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
	btnNoArtFilter:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
	btnNoArtFilter:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")

	local btnNoArtFilterText = btnNoArtFilter:CreateFontString("BadBoyConfigButton3Title", "ARTWORK", "GameFontHighlight")
	btnNoArtFilterText:SetPoint("LEFT", btnNoArtFilter, "RIGHT", 0, 1)
	local btnNoArtFilterTextTwo = btnNoArtFilter:CreateFontString("BadBoyConfigButton3Title", "ARTWORK", "GameFontHighlight")
	btnNoArtFilterTextTwo:SetPoint("TOPLEFT", btnNoArtFilter, "BOTTOMRIGHT")
	btnNoArtFilterTextTwo:SetWidth(350)
	btnNoArtFilterTextTwo:SetHeight(70)
	btnNoArtFilterTextTwo:SetJustifyH("LEFT")
	btnNoArtFilterText:SetText(locNoArtTitle)
	btnNoArtFilterTextTwo:SetText(locNoArtDesc)
end

