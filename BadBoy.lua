local ipairs = _G.ipairs
local fnd = _G.string.find
local lower = _G.strlower
local gsub = _G.strreplace or _G.string.gsub
local info = COMPLAINT_ADDED

local AUTO_REPORT = true --false otherwise

local triggers = { --list partially taken from SpamSentry, <3
	--websites
	"1wowgold%.(c+o+m+)", --24 April 08 forward scggold
	"2wowgold%.(c+o+m+)", --24 April 08 forward gmworker
	"29gameswow%.(c+o+m+)", --24 April 08
	"365ige%.(c+o+m+)", --24 April 08 forward gold230
	"5uneed%.(c+o+m+)", --24 April 08
	"51uoo%.(c+o+m+)", --24 April 08
	"agamegold%.(c+o+m+)", --24 April 08
	"bigmouthnest%.(c+o+m+)", --24 April 08 forward yesdaq
	--"championshall%.(c+o+m+)", --24 April 08 Expired
	"cheapsgold%.(c+o+m+)", --24 April 08
	--"eusupplier%.(c+o+m+)", --24 April 08 Expired
	"eugspa%.(c+o+m+)", --24 April 08 forward mmospa
	"fastgg%.(c+o+m+)", --24 April 08
	"free%-levels%.(c+o+m+)", --24 April 08
	"gagora%.(c+o+m+)", --24 April 08
	"gamegold123%.(c+o+m+)", --24 April 08
	"gamenoble%.(c+o+m+)", --24 April 08
	"gm365%.(c+o+m+)", --24 April 08 ogm365/igm365
	"gm963%.(c+o+m+)", --24 April 08
	"gmworker%.(c+o+m+)", --24 April 08
	"gmworking%.(c+o+m+)", --24 April 08
	"gold230%.(c+o+m+)", --24 April 08
	"gold4guild%.(c+o+m+)", --24 April 08
	--"goldwithyou", --24 April 08 Expired
	"goldwow%.(c+o+m+)", --24 April 08 forward ige
	"gtgold%.(c+o+m+)", --24 April 08 gtgold/heygt
	"happygolds%.(c+o+m+)", --24 April 08
	"helpugame%.(c+o+m+)", --24 April 08
	"heygt%.(c+o+m+)", --24 April 08 heygt/gtgold
	"heypk%.(c+o+m+)", --24 April 08
	"hpygame%.(c+o+m+)", --24 April 08
	--"hugold", --24 April 08 Expired
	"igamebuy%.(c+o+m+)", --24 April 08
	"ige%.(c+o+m+)", --24 April 08
	"igfad%.(c+o+m+)", --24 April 08
	"igs365%.(c+o+m+)", --24 April 08 forward gmworker
	"itemrate%.(c+o+m+)", --24 April 08
	"iuc365%.(c+o+m+)", --24 April 08
	"kgsgold%.(c+o+m+)", --24 April 08
	"luckwow%.(c+o+m+)", --24 April 08
	"mmoinn%.(c+o+m+)", --24 April 08
	"mmospa%.(c+o+m+)", --24 April 08
	"ogchannel%.(c+o+m+)", --24 April 08
	--"ogmarket", --24 April 08 Expired
	--"okstar2008", --24 April 08 Expired
	"ownyo%.(c+o+m+)", --24 April 08
	"pkpkg%.(c+o+m+)", --24 April 08
	"playdone%.(c+o+m+)", --24 April 08
	--"player123", --24 April 08 Expired
	"scggame%.(c+o+m+)", --24 April 08
	"scggold%.(c+o+m+)", --24 April 08
	"ssegames%.(c+o+m+)", --24 April 08
	"speedpanda%.(c+o+m+)", --24 April 08
	"susanexpress%.(c+o+m+)", --24 April 08
	"tbgold%.(c+o+m+)", --24 April 08
	"tctwow%.(c+o+m+)", --24 April 08
	"terrarpg%.(c+o+m+)", --24 April 08 forward mmoinn
	"tgtimes%.(c+o+m+)", --24 April 08
	"torchgame%.(c+o+m+)", --24 April 08
	"tulongold%.(c+o+m+)", --24 April 08
	--"tusongame", --24 April 08 Expired
	"ucgogo%.(c+o+m+)", --24 April 08
	"ucatm%.(%l+)%.tw", --24 April 08 .com/.url
	"ukwowgold%.(c+o+m+)", --24 April 08
	"whoyo%.(c+o+m+)", --24 April 08
	"wow4s%.(c+o+m+)", --24 April 08 forward agamegold
	"wow7gold%.(c+o+m+)", --24 April 08
	"wowcoming%.(c+o+m+)", --24 April 08
	"wow%-europe%.cn", --24 April 08 forward gmworker
	--"woweuropegold",  --24 April 08 Expired
	"wowfbi%.(c+o+m+)", --24 April 08 forward gamegold123
	"wowforever%.(c+o+m+)", --24 April 08
	--"wowfreebuy", --24 April 08 Expired
	"wowgoldbuy%.(n+e+t+)", --24 April 08 forward gm963
	--"wowgoldsky", --24 April 08 Expired
	--"wowgoldex%.(c+o+m+)", --24 April 08 Expired
	"wowgshop%.(c+o+m+)", --24 April 08
	"wowjx%.(c+o+m+)", --24 April 08 forward wowforever
	"wowmine%.(c+o+m+)", --24 April 08
	"wowpanning%.(c+o+m+)", --24 April 08
	--"wowseller%.(c+o+m+)", --24 April 08 Expired
	"wowspa%.(c+o+m+)", --24 April 08
	"wowsupplier%.(c+o+m+)", --24 April 08
	"wowwar%.(n+e+t+)", --24 April 08 forward wowforever
	"yesdaq%.(c+o+m+)", --24 April 08
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
