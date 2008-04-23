local ipairs = _G.ipairs
local fnd = _G.string.find
local lower = _G.string.lower
local gsub = _G.string.gsub
local info = COMPLAINT_ADDED

local AUTO_REPORT = true --false otherwise

local triggers = { --list partially taken from SpamSentry, <3
	--websites
	"1wowgold",
	"2wowgold",
	"29gameswow",
	"365ige",
	"5uneed",
	"51uoo",
	"agamegold",
	"bigmouthnest",
	"championshall",
	"cheapsgold",
	"eusupplier",
	"eugspa",
	"fastgg",
	"free%-levels",
	"gagora%.com",
	"gamegold123",
	"gamenoble",
	"gm963",
	"gmworker",
	"gmw0rker",
	"gmworking",
	"gmw0rking",
	"gold230",
	"gold4guild",
	"goldwithyou",
	"goldwow",
	"gs365",
	"happygolds",
	"helpugame",
	"heygt",
	"heypk",
	"hpygame",
	"hugold",
	"igdollar",
	"igamebuy",
	"igfad",
	"igm365",
	"igs36five",
	"igs365",
	"itembay",
	"itemrate",
	"iuc365",
	"kgsgold",
	"luckwow%.com",
	"mmoinn",
	"mmospa",
	"ogchannel",
	"ogmarket",
	"ogs365",
	"0gs365",
	"ogs4u",
	"okstar2008",
	"ownyo%.com",
	"pkpkg",
	"playdone",
	"player123",
	"scggame",
	"scggold",
	"ssegames",
	"speedpanda",
	"susanexpress",
	"tbgold",
	"terrarpg",
	"tgtimes%.com",
	"torchgame",
	"tulongold",
	"tusongame",
	"ucgogo",
	"ucatm",
	"ukwowgold",
	"whoyo",
	"wow4s",
	"wow7gold",
	"wowcoming",
	"wow%-europe%.cn",
	"woweuropegold",
	"wowfbi",
	"wowforever",
	"wowfreebuy",
	"wowgoldbuy",
	"wowgoldsky",
	"wowgoldex",
	"wowgshop",
	"wowjx",
	"wowmine",
	"wowpanning",
	"wowseller",
	"wowspa",
	"wowsupplier",
	"yesdaq",
}

local prev = 0
local function filter()
	if not CanComplainChat(arg11) then return end
	local msg = lower(arg1)
	msg = gsub(msg, " ", "")
	for _, v in ipairs(triggers) do
		if fnd(msg, v) then
			local time = GetTime()
			if (time - prev) > 7 then
				prev = time
				if AUTO_REPORT then
					COMPLAINT_ADDED = info .. " ("..arg2..")"
					ComplainChat(arg11)
				else
					local dialog = StaticPopup_Show("CONFIRM_REPORT_SPAM_CHAT", arg2)
					if dialog then
						dialog.data = arg11
					end
				end
			end
			return true
		end
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", filter)
