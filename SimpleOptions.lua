
-- GLOBALS: PlaySound, SlashCmdList, SLASH_BADBOY1, SLASH_BADBOY2

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

local title = badboy:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("BadBoy @project-version@") -- packager magic, replaced with tag version

--[[ No Report Chat Message Checkbox ]]--
local btnNoReportMsg = CreateFrame("CheckButton", "BadBoyConfigSilenceButton", badboy, "OptionsBaseCheckButtonTemplate")
btnNoReportMsg:SetPoint("TOPLEFT", 16, -35)
btnNoReportMsg:Disable()

--[[ No Automatic Report Checkbox ]]--
local btnManualReport = CreateFrame("CheckButton", "BadBoyConfigPopupButton", badboy, "OptionsBaseCheckButtonTemplate")
btnManualReport:SetPoint("TOPLEFT", 16, -112)
btnManualReport:Disable()

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

--[[ Slash Handler ]]--
SlashCmdList["BADBOY"] = function() badboy:Show() end
SLASH_BADBOY1 = "/badboy"
SLASH_BADBOY2 = "/bb"
