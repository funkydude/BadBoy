local ipairs = _G.ipairs
local fnd = _G.string.find
local lower = _G.strlower
local gsub = _G.strreplace or _G.string.gsub
local info = COMPLAINT_ADDED

local AUTO_REPORT = true --false otherwise

local triggers = { --list partially taken from SpamSentry, <3
	--websites
	"1wowgold%.com", --24 April 08 forward scggold
	"2wowgold%.com", --24 April 08 forward gmworker
	"29gameswow", --24 April 08
	"365ige%.com", --24 April 08 forward gold230
	"5uneed%.com", --24 April 08
	"51uoo%.com", --24 April 08
	"agamegold%.com", --24 April 08
	"bigmouthnest%.com", --24 April 08 forward yesdaq
	--"championshall%.com", --24 April 08 Expired
	"cheapsgold%.com", --24 April 08
	--"eusupplier%.com", --24 April 08 Expired
	"eugspa%.com", --24 April 08 forward mmospa
	"fastgg%.com", --24 April 08
	"free%-levels%.com", --24 April 08
	"gagora%.com", --24 April 08
	"gamegold123%.com", --24 April 08
	"gamenoble%.com", --24 April 08
	"gm365%.com", --24 April 08 ogm365/igm365
	"gm963%.com", --24 April 08
	"gmworker%.com", --24 April 08
	"gmworking%.com", --24 April 08
	"gold230%.com", --24 April 08
	"gold4guild%.com", --24 April 08
	--"goldwithyou", --24 April 08 Expired
	"goldwow%.com", --24 April 08 forward ige
	"gtgold%.com", --24 April 08 gtgold/heygt
	"happygolds%.com", --24 April 08
	"helpugame%.com", --24 April 08
	"heygt%.com", --24 April 08 heygt/gtgold
	"heypk%.com", --24 April 08
	"hpygame%.com", --24 April 08
	--"hugold", --24 April 08 Expired
	"igamebuy%.com", --24 April 08
	"ige%.com", --24 April 08
	"igfad%.com", --24 April 08
	"igs365%.com", --24 April 08 forward gmworker
	"itemrate%.com", --24 April 08
	"iuc365%.com", --24 April 08
	"kgsgold%.com", --24 April 08
	"luckwow%.com", --24 April 08
	"mmoinn%.com", --24 April 08
	"mmospa%.com", --24 April 08
	"ogchannel%.com", --24 April 08
	--"ogmarket", --24 April 08 Expired
	--"okstar2008", --24 April 08 Expired
	"ownyo%.com", --24 April 08
	"pkpkg%.com", --24 April 08
	"playdone%.com", --24 April 08
	--"player123", --24 April 08 Expired
	"scggame%.com", --24 April 08
	"scggold%.com", --24 April 08
	"ssegames%.com", --24 April 08
	"speedpanda%.com", --24 April 08
	"susanexpress%.com", --24 April 08
	"tbgold%.com", --24 April 08
	"tctwow%.com", --24 April 08
	"terrarpg%.com", --24 April 08 forward mmoinn
	"tgtimes%.com", --24 April 08
	"torchgame%.com", --24 April 08
	"tulongold%.com", --24 April 08
	--"tusongame", --24 April 08 Expired
	"ucgogo%.com", --24 April 08
	"ucatm%.(%S+)%.tw", --24 April 08 .com/.url
	"ukwowgold%.com", --24 April 08
	"whoyo%.com", --24 April 08
	"wow4s%.com", --24 April 08 forward agamegold
	"wow7gold%.com", --24 April 08
	"wowcoming%.com", --24 April 08
	"wow%-europe%.cn", --24 April 08 forward gmworker
	--"woweuropegold",  --24 April 08 Expired
	"wowfbi%.com", --24 April 08 forward gamegold123
	"wowforever%.com", --24 April 08
	--"wowfreebuy", --24 April 08 Expired
	"wowgoldbuy%.net", --24 April 08 forward gm963
	--"wowgoldsky", --24 April 08 Expired
	--"wowgoldex%.com", --24 April 08 Expired
	"wowgshop%.com", --24 April 08
	"wowjx%.com", --24 April 08 forward wowforever
	"wowmine%.com", --24 April 08
	"wowpanning%.com", --24 April 08
	--"wowseller%.com", --24 April 08 Expired
	"wowspa%.com", --24 April 08
	"wowsupplier%.com", --24 April 08
	"wowwar%.net", --24 April 08 forward wowforever
	"yesdaq%.com", --24 April 08
	--phrases
	"(%d+)poundsper(%d+)gold", -- X pounds per X gold
	"(%d+)dollarsper(%d+)gold", -- X dollars per X gold
	"(%d+)eurosper(%d+)gold", -- X euros per X gold
}

local prev = 0
local function filter()
	if not CanComplainChat(arg11) then return end
	local msg = lower(arg1)
	msg = gsub(msg, " ", "")
	msg = gsub(msg, ",", ".")
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
