
local name = ...
do
	--[[ Slash Handler ]]--
	SlashCmdList["BADBOY"] = function() InterfaceOptionsFrame_OpenToCategory(name) end
	SLASH_BADBOY1 = "/badboy"

	--[[ Localization ]]--
	local locNoReportMsg = "Hide the 'spam blocked' message asking you to report"
	local locNoReportDesc = "Please DON'T use this. Reporting the spam is what gets the hacked accounts used by\nthe spammers closed down and realms cleaned up. Also, if many people report a spammer,\nthen that spammer looses the ability to chat meaning they can no longer spam, this benefits\neveryone, especially non-BadBoy users."
	local locManualReport = "Show a report player popup (showing the spam) instead of printing in chat"
	local L = GetLocale()
	if L == "frFR" then
		locNoReportMsg = "Cacher le message 'spam bloqué' vous demandant de signaler le spam"
		locNoReportDesc = "Veuillez ne PAS utiliser ceci. Le signalement du spam permet aux comptes piratés utilisés\npar les spammeurs d'être fermés et de nettoyer les royaumes. De plus, si beaucoup de\njoueurs signalent un spammeur, ce dernier perd la possibilité de discuter et donc de\nspammer, ce qui est bénéfique pour tous, en particulier pour ceux qui n'utilisent pas BadBoy."
		locManualReport = "Afficher un popup de signalement du joueur au lieu de l'indiquer dans la fenêtre de chat"
	elseif L == "deDE" then
		locNoReportMsg = "Verstecke die \"Spam geblockt\" Meldung die dich bittet den Spam zu melden"
		locNoReportDesc = "Bitte NICHT nutzen. Spam zu melden hilft die Anzahl der gehackten Accounts die\nSpammer nutzen zu reduzieren und säubert die Server. Wenn viele Leute einen Spammer\nmelden, verlieren diese ihre Möglichkeit den Chat zu nutzen. Davon profitieren alle,\nvor allem Leute die BadBoy nicht nutzen."
		locManualReport = "Zeige ein PopUp (zeigt den Spam) anstatt es im Chatfenster anzuzeigen"
	elseif L == "zhTW" then
		locNoReportMsg = "隱藏要你舉報的 '垃圾阻擋' 訊息"
		locNoReportDesc = "Please DON'T use this. Reporting the spam is what gets the hacked accounts used by\nthe spammers closed down and realms cleaned up. Also, if many people report a spammer,\nthen that spammer looses the ability to chat meaning they can no longer spam, this benefits\neveryone, especially non-BadBoy users."
		locManualReport = "顯示彈出的玩家舉報(顯示垃圾訊息)而不是發佈在聊天中"
	elseif L == "zhCN" then
		locNoReportMsg = "Hide the 'spam blocked' message asking you to report."
		locNoReportDesc = "Please DON'T use this. Reporting the spam is what gets the hacked accounts used by\nthe spammers closed down and realms cleaned up. Also, if many people report a spammer,\nthen that spammer looses the ability to chat meaning they can no longer spam, this benefits\neveryone, especially non-BadBoy users."
		locManualReport = "Show a report player popup (showing the spam) instead of printing in chat."
	elseif L == "esES" then
		locNoReportMsg = "Hide the 'spam blocked' message asking you to report."
		locNoReportDesc = "Please DON'T use this. Reporting the spam is what gets the hacked accounts used by\nthe spammers closed down and realms cleaned up. Also, if many people report a spammer,\nthen that spammer looses the ability to chat meaning they can no longer spam, this benefits\neveryone, especially non-BadBoy users."
		locManualReport = "Show a report player popup (showing the spam) instead of printing in chat."
	elseif L == "esMX" then
		locNoReportMsg = "Hide the 'spam blocked' message asking you to report."
		locNoReportDesc = "Please DON'T use this. Reporting the spam is what gets the hacked accounts used by\nthe spammers closed down and realms cleaned up. Also, if many people report a spammer,\nthen that spammer looses the ability to chat meaning they can no longer spam, this benefits\neveryone, especially non-BadBoy users."
		locManualReport = "Show a report player popup (showing the spam) instead of printing in chat."
	elseif L == "ruRU" then
		locNoReportMsg = "Hide the 'spam blocked' message asking you to report."
		locNoReportDesc = "Please DON'T use this. Reporting the spam is what gets the hacked accounts used by\nthe spammers closed down and realms cleaned up. Also, if many people report a spammer,\nthen that spammer looses the ability to chat meaning they can no longer spam, this benefits\neveryone, especially non-BadBoy users."
		locManualReport = "Show a report player popup (showing the spam) instead of printing in chat."
	elseif L == "koKR" then
		locNoReportMsg = "Hide the 'spam blocked' message asking you to report."
		locNoReportDesc = "Please DON'T use this. Reporting the spam is what gets the hacked accounts used by\nthe spammers closed down and realms cleaned up. Also, if many people report a spammer,\nthen that spammer looses the ability to chat meaning they can no longer spam, this benefits\neveryone, especially non-BadBoy users."
		locManualReport = "Show a report player popup (showing the spam) instead of printing in chat."
	elseif L == "ptBR" then
		locNoReportMsg = "Hide the 'spam blocked' message asking you to report."
		locNoReportDesc = "Please DON'T use this. Reporting the spam is what gets the hacked accounts used by\nthe spammers closed down and realms cleaned up. Also, if many people report a spammer,\nthen that spammer looses the ability to chat meaning they can no longer spam, this benefits\neveryone, especially non-BadBoy users."
		locManualReport = "Show a report player popup (showing the spam) instead of printing in chat."
	elseif L == "itIT" then
		locNoReportMsg = "Hide the 'spam blocked' message asking you to report."
		locNoReportDesc = "Please DON'T use this. Reporting the spam is what gets the hacked accounts used by\nthe spammers closed down and realms cleaned up. Also, if many people report a spammer,\nthen that spammer looses the ability to chat meaning they can no longer spam, this benefits\neveryone, especially non-BadBoy users."
		locManualReport = "Show a report player popup (showing the spam) instead of printing in chat."
	end

	--[[ Main Panel ]]--
	local badboy = CreateFrame("Frame", "BadBoyConfig", InterfaceOptionsFramePanelContainer)
	--badboy:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...) end)
	badboy:Hide()
	badboy.name = name
	badboy:SetScript("OnShow", function()
		BadBoyConfigSilenceButton:SetChecked(BADBOY_NOREPORT)
		BadBoyConfigPopupButton:SetChecked(BADBOY_POPUP)
	end)
	local title = badboy:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText("BadBoy @project-version@") --wowace magic, replaced with tag version
	InterfaceOptions_AddCategory(badboy)

	--[[ No Report Chat Message Checkbox ]]--
	local btnNoReportMsg = CreateFrame("CheckButton", "BadBoyConfigSilenceButton", badboy, "OptionsBaseCheckButtonTemplate")
	btnNoReportMsg:SetPoint("TOPLEFT", 16, -35)
	btnNoReportMsg:SetScript("OnClick", function(frame)
		if frame:GetChecked() then
			PlaySound("igMainMenuOptionCheckBoxOn")
			BADBOY_NOREPORT = true
		else
			PlaySound("igMainMenuOptionCheckBoxOff")
			BADBOY_NOREPORT = nil
		end
	end)
	local btnNoReportMsgText = btnNoReportMsg:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	btnNoReportMsgText:SetPoint("LEFT", btnNoReportMsg, "RIGHT", 0, 1)
	btnNoReportMsgText:SetText(locNoReportMsg)
	local btnNoReportMsgDesc = btnNoReportMsg:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	btnNoReportMsgDesc:SetPoint("TOPLEFT", btnNoReportMsgText, "BOTTOMLEFT", 0, -5)
	btnNoReportMsgDesc:SetJustifyH("LEFT")
	btnNoReportMsgDesc:SetWordWrap(true)
	btnNoReportMsgDesc:SetText(locNoReportDesc)

	--[[ No Automatic Report Checkbox ]]--
	local btnManualReport = CreateFrame("CheckButton", "BadBoyConfigPopupButton", badboy, "OptionsBaseCheckButtonTemplate")
	btnManualReport:SetPoint("TOPLEFT", 16, -112)
	btnManualReport:SetScript("OnClick", function(frame)
		if frame:GetChecked() then
			PlaySound("igMainMenuOptionCheckBoxOn")
			BADBOY_POPUP = true
		else
			PlaySound("igMainMenuOptionCheckBoxOff")
			BADBOY_POPUP = nil
		end
	end)
	local btnManualReportText = btnManualReport:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	btnManualReportText:SetPoint("LEFT", btnManualReport, "RIGHT", 0, 1)
	btnManualReportText:SetText(locManualReport)

	--[[ BadBoy_Levels Title ]]--
	local levelsTitle = badboy:CreateFontString("BadBoyLevelsConfigTitle", "ARTWORK", "GameFontNormalLarge")
	levelsTitle:SetPoint("TOPLEFT", btnManualReport, "BOTTOMLEFT", 0, -3)
	levelsTitle:SetText("BadBoy_Levels ["..ADDON_MISSING.."]")

	--[[ BadBoy_Guilded Title ]]--
	local guildedTitle = badboy:CreateFontString("BadBoyGuildedConfigTitle", "ARTWORK", "GameFontNormalLarge")
	guildedTitle:SetPoint("TOPLEFT", btnManualReport, "BOTTOMLEFT", 0, -48)
	guildedTitle:SetText("BadBoy_Guilded ["..ADDON_MISSING.."]")

	--[[ BadBoy_CCleaner Title ]]--
	local ccleanerTitle = badboy:CreateFontString("BadBoyCCleanerConfigTitle", "ARTWORK", "GameFontNormalLarge")
	ccleanerTitle:SetPoint("TOPLEFT", btnManualReport, "BOTTOMLEFT", 0, -116)
	ccleanerTitle:SetText("BadBoy_CCleaner ["..ADDON_MISSING.."]")
end

