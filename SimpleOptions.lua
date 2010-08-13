
do
	--Slash handler
	_G["SlashCmdList"]["BADBOY_MAIN"] = function() InterfaceOptionsFrame_OpenToCategory("BadBoy") end
	_G["SLASH_BADBOY_MAIN1"] = "/badboy"

	--Locale
	local locNoReportMsg = "Hide '%s' message"
	local locManualReport = "Disable Automatic Spam Report (Show popup)"
	local locNoArtTitle = "Disable ASCII art filter"
	local locNoArtDesc = "This filter is designed to remove gold spam lines with repetitive symbols like '-' and '+' |cFF33FF99ONLY|r from public channels (gen/trade/LFG/etc) but can sometimes filter innocent players that use |cFF33FF99A LOT|r of '.' or '!' which most people consider spam anyway. They are |cFF33FF99NOT|r reported."
	local L = GetLocale()
	if L == "frFR" then
		locNoReportMsg = "Cacher le message '%s'"
		locManualReport = "Désactiver le signalement auto. du spam (affiche un popup)"
		locNoArtTitle = "Désactiver le filtre des 'dessins' ASCII"
		locNoArtDesc = "Ce filtre a été conçu pour enlever les lignes des vendeurs d'or utilisant des symboles répétés tels que '-' et '+', mais |cFF33FF99UNIQUEMENT|r ceux des canaux publics (général/commerce/RdG/etc.). Il peut arriver que certains joueurs innocents soient aussi filtrés car utilisant de |cFF33FF99NOMBREUX|r '.' ou '!', ce qui dérange la plupart des gens de toute façon."
	elseif L == "deDE" then
		locNoReportMsg = "'%s' Meldung verbergen"
		locManualReport = "Automatische Spam-Meldungen deaktivieren (Pop-Up anzeigen)"
		locNoArtTitle = "ASCII-Kunst-Filter deaktivieren"
		locNoArtDesc = "Dieser Filter entfernt Goldspam-Zeilen mit vielen Zeichen wie z.B. '-' und '+' |cFF33FF99NUR|r von öffentlichen Kanälen (Allgemein/Handel/LFG/etc), kann aber manchmal auch normale Spieler filtern, die |cFF33FF99VIELE|r '.' oder '!' benutzen, was die meisten Spieler aber sowieso als Spam ansehen. Diese Spieler werden |cFF33FF99NICHT|r gemeldet."
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
		locNoArtTitle = "Deshabilitar filtro de arte ASCII"
		locNoArtDesc = "Este filtro está diseñado para eliminar las líneas de spam de oro con símbolos repetitivos como '-' y '+' |cFF33FF99SÓLO|r de los canales públicos (gen/comercio/BdG/etc), aunque puede a veces filtrar jugadores inocentes que usan |cFF33FF99A MUCHOS|r '.' ó '!' que la mayoría de gente consederaría spam igualmente. Éstos |cFF33FF99NO|r son reportados."
	elseif L == "koKR" then
		BADBOY_NOLATIN = true
	elseif L == "ruRU" then
		locNoReportMsg = "Прятать сообщение '%s'"
		locManualReport = "Отключить автоматическую жалобу на спам (показывать подтверждение)"
		locNoArtTitle = "Отключить фильтр ASCII-картинок"
		BADBOY_NOLATIN = true
	end

	--Begin GUI
	local badboy = CreateFrame("Frame", "BadBoyConfig", InterfaceOptionsFramePanelContainer)
	badboy:Hide()
	badboy.name = "BadBoy"
	InterfaceOptions_AddCategory(badboy)

	local title = badboy:CreateFontString("BadBoyConfigTitle", "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText("BadBoy ".."@project-version@") --wowace magic, replaced with tag version

	local btnNoReportMsg = CreateFrame("CheckButton", "BadBoyConfigSilenceButton", badboy)
	btnNoReportMsg:SetWidth(26)
	btnNoReportMsg:SetHeight(26)
	btnNoReportMsg:SetPoint("TOPLEFT", 16, -35)
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

	btnNoReportMsg:SetHitRectInsets(0, -200, 0, 0)

	btnNoReportMsg:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
	btnNoReportMsg:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
	btnNoReportMsg:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
	btnNoReportMsg:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")

	local btnNoReportMsgText = btnNoReportMsg:CreateFontString("BadBoyConfigSilenceButtonTitle", "ARTWORK", "GameFontHighlight")
	btnNoReportMsgText:SetPoint("LEFT", btnNoReportMsg, "RIGHT", 0, 1)
	btnNoReportMsgText:SetText((locNoReportMsg):format(COMPLAINT_ADDED))

	local btnManualReport = CreateFrame("CheckButton", "BadBoyConfigPopupButton", badboy)
	btnManualReport:SetWidth(26)
	btnManualReport:SetHeight(26)
	btnManualReport:SetPoint("TOPLEFT", 16, -57)
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

	btnManualReport:SetHitRectInsets(0, -200, 0, 0)

	btnManualReport:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
	btnManualReport:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
	btnManualReport:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
	btnManualReport:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")

	local btnManualReportText = btnManualReport:CreateFontString("BadBoyConfigPopupButtonTitle", "ARTWORK", "GameFontHighlight")
	btnManualReportText:SetPoint("LEFT", btnManualReport, "RIGHT", 0, 1)
	btnManualReportText:SetText(locManualReport)


	local btnNoArtFilter = CreateFrame("CheckButton", "BadBoyConfigNoArtButton", badboy)
	btnNoArtFilter:SetWidth(26)
	btnNoArtFilter:SetHeight(26)
	btnNoArtFilter:SetPoint("TOPLEFT", 16, -79)
	btnNoArtFilter:SetScript("OnShow", function(frame)
		if BADBOY_NOLATIN then
			frame:Disable()
			BadBoyConfigNoArtButtonTitle:SetTextColor(0.5, 0.5, 0.5)
			return
		end
		if BADBOY_ALLOWART then
			frame:SetChecked(true)
		else
			frame:SetChecked(false)
		end
	end)
	btnNoArtFilter:SetScript("OnClick", function(frame)
		if BADBOY_NOLATIN then return end
		local tick = frame:GetChecked()
		if tick then
			PlaySound("igMainMenuOptionCheckBoxOn")
			BADBOY_ALLOWART = true
		else
			PlaySound("igMainMenuOptionCheckBoxOff")
			BADBOY_ALLOWART = nil
		end
	end)

	btnNoArtFilter:SetHitRectInsets(0, -200, 0, 0)

	btnNoArtFilter:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
	btnNoArtFilter:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
	btnNoArtFilter:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
	btnNoArtFilter:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")

	local btnNoArtFilterText = btnNoArtFilter:CreateFontString("BadBoyConfigNoArtButtonTitle", "ARTWORK", "GameFontHighlight")
	btnNoArtFilterText:SetPoint("LEFT", btnNoArtFilter, "RIGHT", 0, 1)
	btnNoArtFilterText:SetText(locNoArtTitle)

	btnNoArtFilter:SetScript("OnEnter", function(frame)
		GameTooltip:SetOwner(frame, "ANCHOR_TOP")
		GameTooltip:AddLine(locNoArtDesc, nil, nil, nil, true)
		GameTooltip:Show()
	end)
	btnNoArtFilter:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	local levelsTitle = badboy:CreateFontString("BadBoyLevelsConfigTitle", "ARTWORK", "GameFontNormalLarge")
	levelsTitle:SetPoint("TOPLEFT", btnNoArtFilter, "BOTTOMLEFT", 0, -3)
	levelsTitle:SetText("BadBoy_Levels ["..ADDON_MISSING.."]")

	local levelsBox = CreateFrame("EditBox", "BadBoyLevelsEditBox", badboy, "InputBoxTemplate")
	levelsBox:SetPoint("TOPLEFT", btnNoArtFilter, "BOTTOMLEFT", 10, -25)
	levelsBox:SetAutoFocus(false)
	levelsBox:EnableMouse(false)
	levelsBox:SetNumeric(true)
	levelsBox:SetWidth(30)
	levelsBox:SetHeight(20)
	levelsBox:SetMaxLetters(2)
	--XXX move functions to _Levels, temporary
	levelsBox:SetScript("OnShow", function(frame)
		if IsAddOnLoaded("BadBoy_Levels") then
			BadBoyLevelsConfigTitle:SetText("BadBoy_Levels ["..UNKNOWN.."]")
			if BADBOY_LEVEL and type(BADBOY_LEVEL) ~= "number" then BADBOY_LEVEL = nil end
			if BADBOY_LEVEL and (BADBOY_LEVEL<1 or BADBOY_LEVEL>79) then BADBOY_LEVEL = nil end
			frame:SetText(BADBOY_LEVEL or 1)
			frame:EnableMouse(true)
			frame:SetScript("OnHide", function(newFrame)
				local n = tonumber(newFrame:GetText())
				if not n or n == "" then newFrame:SetText(BADBOY_LEVEL or 1) print("|cFF33FF99BadBoy_Levels|r == "..(BADBOY_LEVEL or 1)) return end
				if n <1 or n>79 then
					newFrame:SetText(BADBOY_LEVEL or 1)
					print("|cFF33FF99BadBoy_Levels|r == "..(BADBOY_LEVEL or 1))
				else
					BADBOY_LEVEL = n
					print("|cFF33FF99BadBoy_Levels|r == "..n)
				end
			end)
		end
	end)
	levelsBox:Show()

	local ccleanerTitle = badboy:CreateFontString("BadBoyCCleanerConfigTitle", "ARTWORK", "GameFontNormalLarge")
	ccleanerTitle:SetPoint("TOPLEFT", levelsBox, "BOTTOMLEFT", -10, -3)
	ccleanerTitle:SetText("BadBoy_CCleaner ["..ADDON_MISSING.."]")
end

