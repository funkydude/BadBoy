local ipairs = ipairs
local fnd = string.find
local lower = string.lower

local triggers = { --list taken from SpamSentry, <3
	"100g.ca",
	"1225game",
	"29games",
	"365ige",
	"5uneed",
	"agamegold",
	"agamegoid",
	"auctionwowhouse",
	"buywowgame",
	"buyw0wgame",
	"buyvvowgame",
	"championshall",
	"eusupplier",
	"eugspa",
	"fastgg",
	"gagora",
	"gamenoble",
	"gmauthorization",
	"gmworker",
	"gmw0rker",
	"gmworking",
	"gmw0rking",
	"gold4guild",
	"goldwithyou",
	"goldwow",
	"helpugame",
	"heygt",
	"hugold",
	"igdollar",
	"igamebuy",
	"igm365",
	"igs36five",
	"igs365",
	"gm963",
	"gs365",
	"itembay",
	"itemrate",
	"iuc365",
	"kgs",
	"mmoinn",
	"mmospa",
	"ogchannel",
	"ogmarket",
	"ogs365",
	"0gs365",
	"ogs4u",
	"okstar2008",
	"p4hire",
	"peons4hire",
	"peons4h1re",
	"peons4",
	"4hire",
	"p3ons",
	"hir3",
	"pkpkg",
	"player123",
	"scggame",
	"ssegames",
	"speedpanda",
	"terrarpg",
	"tulongold",
	"tusongame",
	"ucgogo",
	"ucatm",
	"ukwowgold",
	"whoyo",
	"wow4s",
	"wow7gold",
	"wowcoming",
	"wowdupe",
	"woweurope.cn",
	"woweuropegold",
	"wowforever",
	"wowfreebuy",
	"wowgoldsky",
	"wowgoldex",
	"wowgshop",
	"wowjx",
	"wowmine",
	"wowpanning",
	"wowpfs",
	"wowspa",
	"wowstar2008",
	"wowsupplier",
	"wowtoolbox",
	"zlywy",
}

local prev = 0
local function filter()
	local msg = lower(arg1)
	for _, v in ipairs(triggers) do
		if fnd(msg, v) then
			local time = GetTime()
			if (time - prev) > 5 then
				prev = time
				local dialog = StaticPopup_Show("CONFIRM_REPORT_SPAM_CHAT", arg2)
				if dialog then
					dialog.data = arg11
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
