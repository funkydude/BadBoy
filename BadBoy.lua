local ipairs = _G.ipairs
local fnd = _G.strfind
local lower = _G.strlower
local gsub = _G.strreplace or _G.gsub
local info = COMPLAINT_ADDED

local AUTO_REPORT = true --false otherwise

local triggers = {
	--phrases
	"gold.*powerlevell?ing", --gold [optional random text] powerlevel(l)ing
	"%d+poundsper%d+gold", -- X pounds per X gold
	"%d+dollarsper%d+gold", -- X dollars per X gold
	"%d+eurosper%d+gold", -- X euros per X gold
	"%d+g%/%d+eu", --X G / X EU
	--websites, list partially taken from SpamSentry
	"1wowgold%.c%S+", --24 April 08 forward scggold
	"2wowgold%.c%S+", --5 May 08 forward gmworker
	"2wowgold%.%Som", --5 May 08 forward gmworker
	"29gameswow%.c%S+", --24 April 08
	"365ige%.c%S+", --24 April 08 forward gold230
	"5uneed%.c%S+", --24 April 08
	"51uoo%.c%S+", --24 April 08
	"agamegold%.c%S+", --24 April 08
	"bigmouthnest%.c%S+", --24 April 08 forward yesdaq
	"brothergame%.c%S+", --29 April 08
	--"championshall%.c%S+", --24 April 08 Expired
	"cheapsgold%.c%S+", --24 April 08
	"dewowgold%.c%S+", --26 April 08
	"df%-game%.c%S+", --29 April 08
	"dgameskydotc%S+", --29 April 08 dgamesky DOT com
	"dgamespydotc%S+", --29 April 08 dgamespy DOT com
	"epicgamegold%.c%S+", --5 May 08
	--"eusupplier%.c%S+", --24 April 08 Expired
	"eugspa%.c%S+", --24 April 08 forward mmospa
	"fast70%.c%S+", --27 April 08
	"fastgg%.c%S+", --24 April 08
	"fedwow%.c%S+", --30 April 08
	"fkugold%.c%S+", --5 May 08 forward yedaq
	"free%-levels", --25 April 08 DOT / . com
	"gagora%.c%S+", --24 April 08
	"game1999%.c%S+", --28 April 08
	"gamegold123%.c%S+", --24 April 08
	"gamenoble%.c%S+", --24 April 08
	"get%-levels%.c%S+", --29 April 08
	"gm365%.c%S+", --24 April 08 ogm365/igm365
	"gm963%.c%S+", --24 April 08
	"gmworker%.c%S+", --24 April 08
	"gmworking%.c%S+", --24 April 08
	"gmworking%.e+u+", --25 April 08 forward gmworking.com
	"god%-moddot", --25 April 08 god-mod DOT com
	"gold230%.c%S+", --24 April 08
	"gold4guild%.c%S+", --24 April 08
	"gold660%.c%S+", --6 May 08
	"goldmyspace%.c%S+", --5 May 08 forward yesdaq
	--"goldwithyou", --24 April 08 Expired
	"goldpager%.c%S+", --26 April 08 forward yesdaq
	"goldsaler%.c%S+", --5 May 08
	"goldwow%.c%S+", --24 April 08 forward ige
	"goldzombie%.c%S+", --5 May 08
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
	"mayapl%.%S+", --5 May 08 mayapl.com
	"mmoinn%.c%S+", --24 April 08
	"mmospa%.c%S+", --24 April 08
	"ogchanne%S%.c%S+", --29 April 08 ogchannel /ogchanneI
	--"ogmarket", --24 April 08 Expired
	"okpenos%.c%S+", --5 May 08 forward yesaq
	--"okstar2008", --24 April 08 Expired
	"ownyo%.c%S+", --29 April 08 ownyo.com
	"owny%S+%.com", --29 April 08 ownyo.com
	"pkpkg%.c%S+", --24 April 08
	"playdone%.c%S+", --24 April 08
	"psmmo%.c%S+", --26 April 08
	--"player123", --24 April 08 Expired
	"qwowgold%.c%S+", --5 May 08
	"scggame%.c%S+", --24 April 08
	"scggold%.c%S+", --24 April 08
	"ssegames%.c%S+", --24 April 08
	"speedpanda%.c%S+", --24 April 08
	"supplier2008%.c%S+", --27 April 08 forward tradewowgold
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
	"vesgame%.c%S+", --27 April 08
	"vgsale%.c%S+", --28 April 08
	"vsguy%.c%S+", --26 April 08
	"whoyo%.c%S+", --24 April 08
	"wow%-europe%.cn", --24 April 08 forward gmworker
	"wow4s%.%S+", --26 April 08 .com / .net forward agamegold
	"wow7gold%.c%S+", --24 April 08
	"wowcnn%.c%S+", --5 May 08 forward gamegold123
	"wowcoming%.c%S+", --24 April 08
	--"woweuropegold",  --24 April 08 Expired
	"wowfbi%.c%S+", --24 April 08 forward gamegold123
	"wowforever%.c%S+", --24 April 08
	--"wowfreebuy", --24 April 08 Expired
	"wowgoldbuy%.n+e+t+", --24 April 08 forward gm963
	--"wowgoldsky", --24 April 08 Expired
	--"wowgoldex%.c%S+", --24 April 08 Expired
	"wowgshop%.c%S+", --24 April 08
	"wow%-?hackers%.c%S+", --5 May 08 forward god-mod | wow-hackers / wowhackers
	"wowhax%.c%S+", --5 May 08
	"wowjx%.c%S+", --24 April 08 forward wowforever
	"wowmine%.c%S+", --24 April 08
	"wowpanning%.c%S+", --24 April 08
	"wowpl%.n+e+t+", --5 May 08
	"wowseller%.c%S+", --24 April 08
	"wowspa%.c%S+", --24 April 08
	"wowsupplier%.c%S+", --24 April 08
	"wowton%.c%S+", --29 April 08
	"wowwar%.n+e+t+", --24 April 08 forward wowforever
	"yesdaq%.c%S+", --24 April 08
}

local prev, savedID, result = 0, 0, nil
local function filter(msg)
	if arg11 == savedID then return result else savedID = arg11 end --to work around a blizz bug
	if not CanComplainChat(savedID) then return end
	msg = lower(msg)
	msg = gsub(msg, " ", "")
	msg = gsub(msg, ",", ".")
	for _, v in ipairs(triggers) do
		if fnd(msg, v) then
			local time = GetTime()
			if (time - prev) > 20 then
				prev = time
				if AUTO_REPORT then
					COMPLAINT_ADDED = info .. " ("..arg2..")"
					ComplainChat(savedID)
				else
					local dialog = StaticPopup_Show("CONFIRM_REPORT_SPAM_CHAT", arg2)
					if dialog then
						dialog.data = savedID
					end
				end
			end
			result = true
			return true
		end
	end
	result = nil
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", filter)
