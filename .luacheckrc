std = "lua51"
max_line_length = false
codes = true
exclude_files = {
	"**/Libs",
}
ignore = {
	"111/SLASH_BADBOY1", -- slash handlers
	"112/SlashCmdList",
}
globals = {
	"BADBOY_OPTIONS",
	"BADBOY_BLACKLIST",
	"C_Map",
	"date",
	"GetFramesRegisteredForEvent",
	"GetLocale",
	"SetCVar",

	-- Options
	"ADDON_MISSING",
	"CreateFrame",
	"GameTooltip",
	"GameTooltip_Hide",
	"PlaySound",
	"UIParent",
}
