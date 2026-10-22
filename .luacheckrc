std = "lua51"
max_line_length = false
codes = true
ignore = {
	"111/SLASH_BADBOY1", -- slash handlers
	"112/SlashCmdList",
	"143", -- accessing undefined field split of global string
}
globals = {
	"Ambiguate",
	"BADBOY_OPTIONS",
	"BADBOY_BLACKLIST",
	"BadBoyLog",
	"C_BattleNet",
	"C_CVar",
	"C_FriendList",
	"C_InstanceEncounter",
	"C_Map",
	"C_PartyInfo",
	"C_ReportSystem",
	"C_Timer",
	"ChatFrame1",
	"ChatFrameUtil",
	"date",
	"geterrorhandler",
	"GetFramesRegisteredForEvent",
	"GetLocale",
	"GetTime",
	"IsAltKeyDown",
	"IsGuildMember",
	"issecretvalue",
	"PlayerLocation",

	-- Options
	"ADDON_MISSING",
	"CreateFrame",
	"GameTooltip",
	"GameTooltip_Hide",
	"PlaySound",
	"UIParent",
}
