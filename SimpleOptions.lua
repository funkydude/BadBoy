
-- GLOBALS: PlaySound, SlashCmdList, BADBOY_TOOLTIP, SLASH_BADBOY1, SLASH_BADBOY2

--[[ Main Panel ]]--
local badboy = CreateFrame("Frame", "BadBoyConfig", UIParent)
badboy:SetSize(475, 570)
badboy:SetPoint("CENTER")
badboy:Hide()
local bg = badboy:CreateTexture()
bg:SetAllPoints(badboy)
bg:SetColorTexture(0, 0, 0, 0.5)
local close = CreateFrame("Button", nil, badboy, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", badboy, "TOPRIGHT", -5, -5)

local title = badboy:CreateFontString(nil, nil, "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("BadBoy @project-version@") -- packager magic, replaced with tag version

--[[ Show spam checkbox ]]--
local btnShowSpam = CreateFrame("CheckButton", nil, badboy, "OptionsBaseCheckButtonTemplate")
btnShowSpam:SetPoint("TOPLEFT", title, "BOTTOMLEFT")
btnShowSpam:SetScript("OnClick", function(frame)
	local tick = frame:GetChecked()
	BADBOY_TOOLTIP = tick
	PlaySound(tick and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
end)
btnShowSpam:SetScript("OnShow", function(frame)
	frame:SetChecked(BADBOY_TOOLTIP)
end)

local btnShowSpamText = badboy:CreateFontString(nil, nil, "GameFontHighlight")
btnShowSpamText:SetPoint("LEFT", btnShowSpam, "RIGHT", 0, 1)
btnShowSpamText:SetText("Show spam in report button tooltip")
do
	local L = GetLocale()
	if L == "frFR" then
		--btnShowSpamText:SetText("Show spam in report button tooltip")
	elseif L == "deDE" then
		--btnShowSpamText:SetText("Show spam in report button tooltip")
	elseif L == "zhTW" then
		--btnShowSpamText:SetText("Show spam in report button tooltip")
	elseif L == "zhCN" then
		--btnShowSpamText:SetText("Show spam in report button tooltip")
	elseif L == "esES" then
		--btnShowSpamText:SetText("Show spam in report button tooltip")
	elseif L == "esMX" then
		--btnShowSpamText:SetText("Show spam in report button tooltip")
	elseif L == "ruRU" then
		--btnShowSpamText:SetText("Show spam in report button tooltip")
	elseif L == "koKR" then
		--btnShowSpamText:SetText("Show spam in report button tooltip")
	elseif L == "ptBR" then
		--btnShowSpamText:SetText("Show spam in report button tooltip")
	elseif L == "itIT" then
		--btnShowSpamText:SetText("Show spam in report button tooltip")
	end
end

--[[ BadBoy_Levels Title ]]--
local levelsTitle = badboy:CreateFontString("BadBoyLevelsConfigTitle", nil, "GameFontNormalLarge")
levelsTitle:SetPoint("TOPLEFT", btnShowSpam, "BOTTOMLEFT", 0, -3)
levelsTitle:SetText("BadBoy_Levels ["..ADDON_MISSING.."]")

--[[ BadBoy_Guilded Title ]]--
local guildedTitle = badboy:CreateFontString("BadBoyGuildedConfigTitle", nil, "GameFontNormalLarge")
guildedTitle:SetPoint("TOPLEFT", btnShowSpam, "BOTTOMLEFT", 0, -48)
guildedTitle:SetText("BadBoy_Guilded ["..ADDON_MISSING.."]")

--[[ BadBoy_CCleaner Title ]]--
local ccleanerTitle = badboy:CreateFontString("BadBoyCCleanerConfigTitle", nil, "GameFontNormalLarge")
ccleanerTitle:SetPoint("TOPLEFT", btnShowSpam, "BOTTOMLEFT", 0, -116)
ccleanerTitle:SetText("BadBoy_CCleaner ["..ADDON_MISSING.."]")

--[[ Slash Handler ]]--
SlashCmdList["BADBOY"] = function() badboy:Show() end
SLASH_BADBOY1 = "/badboy"
SLASH_BADBOY2 = "/bb"
