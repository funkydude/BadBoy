local ipairs = _G.ipairs
local fnd = _G.string.find
local lower = _G.strlower
local gsub = _G.strreplace or _G.string.gsub
local info = COMPLAINT_ADDED

local AUTO_REPORT = true --false otherwise

local triggers = { --list partially taken from SpamSentry, <3
	--websites
	"1wowgold%.(%l+)", --24 April 08 forward scggold
	"2wowgold%.(%l+)", --24 April 08 forward gmworker
	"29gameswow%.(%l+)", --24 April 08
	"365ige%.(%l+)", --24 April 08 forward gold230
	"5uneed%.(%l+)", --24 April 08
	"51uoo%.(%l+)", --24 April 08
	"agamegold%.(%l+)", --24 April 08
	"bigmouthnest%.(%l+)", --24 April 08 forward yesdaq
	--"championshall%.(%l+)", --24 April 08 Expired
	"cheapsgold%.(%l+)", --24 April 08
	--"eusupplier%.(%l+)", --24 April 08 Expired
	"eugspa%.(%l+)", --24 April 08 forward mmospa
	"fastgg%.(%l+)", --24 April 08
	"free%-levels%.(%l+)", --24 April 08
	"gagora%.(%l+)", --24 April 08
	"gamegold123%.(%l+)", --24 April 08
	"gamenoble%.(%l+)", --24 April 08
	"gm365%.(%l+)", --24 April 08 ogm365/igm365
	"gm963%.(%l+)", --24 April 08
	"gmworker%.(%l+)", --24 April 08
	"gmworking%.(%l+)", --24 April 08
	"gold230%.(%l+)", --24 April 08
	"gold4guild%.(%l+)", --24 April 08
	--"goldwithyou", --24 April 08 Expired
	"goldwow%.(%l+)", --24 April 08 forward ige
	"gtgold%.(%l+)", --24 April 08 gtgold/heygt
	"happygolds%.(%l+)", --24 April 08
	"helpugame%.(%l+)", --24 April 08
	"heygt%.(%l+)", --24 April 08 heygt/gtgold
	"heypk%.(%l+)", --24 April 08
	"hpygame%.(%l+)", --24 April 08
	--"hugold", --24 April 08 Expired
	"igamebuy%.(%l+)", --24 April 08
	"ige%.(%l+)", --24 April 08
	"igfad%.(%l+)", --24 April 08
	"igs365%.(%l+)", --24 April 08 forward gmworker
	"itemrate%.(%l+)", --24 April 08
	"iuc365%.(%l+)", --24 April 08
	"kgsgold%.(%l+)", --24 April 08
	"luckwow%.(%l+)", --24 April 08
	"mmoinn%.(%l+)", --24 April 08
	"mmospa%.(%l+)", --24 April 08
	"ogchannel%.(%l+)", --24 April 08
	--"ogmarket", --24 April 08 Expired
	--"okstar2008", --24 April 08 Expired
	"ownyo%.(%l+)", --24 April 08
	"pkpkg%.(%l+)", --24 April 08
	"playdone%.(%l+)", --24 April 08
	--"player123", --24 April 08 Expired
	"scggame%.(%l+)", --24 April 08
	"scggold%.(%l+)", --24 April 08
	"ssegames%.(%l+)", --24 April 08
	"speedpanda%.(%l+)", --24 April 08
	"susanexpress%.(%l+)", --24 April 08
	"tbgold%.(%l+)", --24 April 08
	"tctwow%.(%l+)", --24 April 08
	"terrarpg%.(%l+)", --24 April 08 forward mmoinn
	"tgtimes%.(%l+)", --24 April 08
	"torchgame%.(%l+)", --24 April 08
	"tulongold%.(%l+)", --24 April 08
	--"tusongame", --24 April 08 Expired
	"ucgogo%.(%l+)", --24 April 08
	"ucatm%.(%l+)%.tw", --24 April 08 .com/.url
	"ukwowgold%.(%l+)", --24 April 08
	"whoyo%.(%l+)", --24 April 08
	"wow4s%.(%l+)", --24 April 08 forward agamegold
	"wow7gold%.(%l+)", --24 April 08
	"wowcoming%.(%l+)", --24 April 08
	"wow%-europe%.cn", --24 April 08 forward gmworker
	--"woweuropegold",  --24 April 08 Expired
	"wowfbi%.(%l+)", --24 April 08 forward gamegold123
	"wowforever%.(%l+)", --24 April 08
	--"wowfreebuy", --24 April 08 Expired
	"wowgoldbuy%.(%l+)", --24 April 08 forward gm963 (.net)
	--"wowgoldsky", --24 April 08 Expired
	--"wowgoldex%.(%l+)", --24 April 08 Expired
	"wowgshop%.(%l+)", --24 April 08
	"wowjx%.(%l+)", --24 April 08 forward wowforever
	"wowmine%.(%l+)", --24 April 08
	"wowpanning%.(%l+)", --24 April 08
	--"wowseller%.(%l+)", --24 April 08 Expired
	"wowspa%.(%l+)", --24 April 08
	"wowsupplier%.(%l+)", --24 April 08
	"wowwar%.(%l+)", --24 April 08 forward wowforever (.net)
	"yesdaq%.(%l+)", --24 April 08
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
