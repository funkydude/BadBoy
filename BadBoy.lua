local ipairs = ipairs
local fnd = string.find
local lower = string.lower
local info = COMPLAINT_ADDED

local AUTO_REPORT = true --false otherwise

local triggers = { --list partially taken from SpamSentry, <3
	--websites
	"100g%.ca",
	"1225game",
	"29games",
	"2wowgold",
	"365ige",
	"5uneed",
	"agamegold",
	"agamegoid",
	"auctionwowhouse",
	"buywowgame",
	"buyw0wgame",
	"buyvvowgame",
	"championshall",
	"cheapsgold",
	"eusupplier",
	"eugspa",
	"fastgg",
	"free%-levels",
	"gagora%.com",
	"gamenoble",
	"gm963",
	"gmworker",
	"gmw0rker",
	"gmworking",
	"gmw0rking",
	"gold4guild",
	"goldwithyou",
	"goldwow",
	"gs365",
	"happygolds",
	"helpugame",
	"heygt",
	"h e y g t",
	"heypk",
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
	"mmoinn",
	"mmospa",
	"ogchannel",
	"ogmarket",
	"ogs365",
	"0gs365",
	"ogs4u",
	"okstar2008",
	"pkpkg",
	"player123",
	"scggame",
	"ssegames",
	"speedpanda",
	"susanexpress",
	"tbgold",
	"terrarpg",
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
	"wowdupe",
	"woweurope%.cn",
	"wow%-europe%.cn",
	"woweuropegold",
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
	--phrases
	"(%d+) (%S+) per (%d+) gold",
}

local prev = 0
local function filter()
	local msg = lower(arg1)
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
