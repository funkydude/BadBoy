local ipairs = _G.ipairs
local fnd = _G.strfind
local lower = _G.strlower
local gsub = _G.strreplace or _G.gsub
local info = COMPLAINT_ADDED

local AUTO_REPORT = true --false otherwise

local triggers = { --list partially taken from SpamSentry, <3
	--websites
	"1wowgold%.c%S+", --24 April 08 forward scggold
	"2wowgold%.c%S+", --24 April 08 forward gmworker
	"29gameswow%.c%S+", --24 April 08
	"365ige%.c%S+", --24 April 08 forward gold230
	"5uneed%.c%S+", --24 April 08
	"51uoo%.c%S+", --24 April 08
	"agamegold%.c%S+", --24 April 08
	"bigmouthnest%.c%S+", --24 April 08 forward yesdaq
	--"championshall%.c%S+", --24 April 08 Expired
	"cheapsgold%.c%S+", --24 April 08
	"dewowgold%.c%S+", --26 April 08
	--"eusupplier%.c%S+", --24 April 08 Expired
	"eugspa%.c%S+", --24 April 08 forward mmospa
	"fast70%.c%S+", --27 April 08
	"fastgg%.c%S+", --24 April 08
	"free%-levels", --25 April 08 DOT / . com
	"gagora%.c%S+", --24 April 08
	"gamegold123%.c%S+", --24 April 08
	"gamenoble%.c%S+", --24 April 08
	"gm365%.c%S+", --24 April 08 ogm365/igm365
	"gm963%.c%S+", --24 April 08
	"gmworker%.c%S+", --24 April 08
	"gmworking%.c%S+", --24 April 08
	"gmworking%.e+u+", --25 April 08 forward gmworking.com
	"god%-moddot", --25 April 08 god-mod DOT com
	"gold230%.c%S+", --24 April 08
	"gold4guild%.c%S+", --24 April 08
	--"goldwithyou", --24 April 08 Expired
	"goldpager%.c%S+", --26 April 08 forward yesdaq
	"goldwow%.c%S+", --24 April 08 forward ige
	"gtgold%.c%S+", --24 April 08 gtgold/heygt
	"happygolds%.c%S+", --24 April 08
	"helpugame%.c%S+", --24 April 08
	"heygt%.c%S+", --24 April 08 heygt/gtgold
	"heypk%.c%S+", --24 April 08
	"hpygame%.c%S+", --24 April 08
	--"hugold", --24 April 08 Expired
	"igamebuy%.c%S+", --24 April 08
	"ige%.c%S+", --24 April 08
	"igfad%.c%S+", --24 April 08
	"ighey%.c%S+", --27 April 08
	"igs365%.c%S+", --24 April 08 forward gmworker
	"item4sale%.c%S+", --26 April 08
	"itemrate%.c%S+", --24 April 08
	"iuc365%.c%S+", --24 April 08
	"kgsgold%.c%S+", --24 April 08
	"leetgold%.c%S+", --27 April 08
	"luckwow%.c%S+", --24 April 08
	"mmoinn%.c%S+", --24 April 08
	"mmospa%.c%S+", --24 April 08
	"ogchannel%.c%S+", --24 April 08
	--"ogmarket", --24 April 08 Expired
	--"okstar2008", --24 April 08 Expired
	"ownyo%.c%S+", --24 April 08
	"pkpkg%.c%S+", --24 April 08
	"playdone%.c%S+", --24 April 08
	"psmmo%.c%S+", --26 April 08
	--"player123", --24 April 08 Expired
	"scggame%.c%S+", --24 April 08
	"scggold%.c%S+", --24 April 08
	"ssegames%.c%S+", --24 April 08
	"speedpanda%.c%S+", --24 April 08
	"%.susanexpress%.%S+", --27 April 08 .com/.?om
	"tbgold%.c%S+", --24 April 08
	"tctwow%.c%S+", --24 April 08
	"terrarpg%.c%S+", --24 April 08 forward mmoinn
	"tgtimes%.c%S+", --24 April 08
	"torchgame%.c%S+", --24 April 08
	"tulongold%.c%S+", --24 April 08
	--"tusongame", --24 April 08 Expired
	"ucgogo%.c%S+", --24 April 08
	"ucatm%.%l+%.tw", --24 April 08 .com/.url
	"ukwowgold%.c%S+", --24 April 08
	"vsguy%.c%S+", --26 April 08
	"whoyo%.c%S+", --24 April 08
	"wow4s%.%S+", --26 April 08 .com / .net forward agamegold
	"wow7gold%.c%S+", --24 April 08
	"wowcoming%.c%S+", --24 April 08
	"wow%-europe%.cn", --24 April 08 forward gmworker
	--"woweuropegold",  --24 April 08 Expired
	"wowfbi%.c%S+", --24 April 08 forward gamegold123
	"wowforever%.c%S+", --24 April 08
	--"wowfreebuy", --24 April 08 Expired
	"wowgoldbuy%.n+e+t+", --24 April 08 forward gm963
	--"wowgoldsky", --24 April 08 Expired
	--"wowgoldex%.c%S+", --24 April 08 Expired
	"wowgshop%.c%S+", --24 April 08
	"wowjx%.c%S+", --24 April 08 forward wowforever
	"wowmine%.c%S+", --24 April 08
	"wowpanning%.c%S+", --24 April 08
	"wowseller%.c%S+", --24 April 08
	"wowspa%.c%S+", --24 April 08
	"wowsupplier%.c%S+", --24 April 08
	"wowwar%.n+e+t+", --24 April 08 forward wowforever
	"yesdaq%.c%S+", --24 April 08
	--phrases
	"%d+poundsper%d+gold", -- X pounds per X gold
	"%d+dollarsper%d+gold", -- X dollars per X gold
	"%d+eurosper%d+gold", -- X euros per X gold
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
			if (time - prev) > 20 then
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
