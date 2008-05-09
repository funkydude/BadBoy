local ipairs = _G.ipairs
local fnd = _G.string.find
local lower = _G.string.lower
local gsub = _G.strreplace or _G.gsub
local info = COMPLAINT_ADDED

local AUTO_REPORT = true --false otherwise

local triggers = {
	--Random
	"%.o+%.", --[.ooooO Ooooo.]
	"%(only%d+%.?%d*eur?o?s?%)",

	--Phrases
	"%d+%.?%d*go?l?d?%/%d+%.?%d*eu",
	"%d+%.?%d*pounds?per%d+%.?%d*g",
	"%d+%.?%d*dollarsper%d+%.?%d*gold",
	"%d+%.?%d*eu%l+%d+%.?%d*g",
	"gold.*powerle?ve?ll?ing",
	"cheap.*fast.*gold",
	"%d+%.?%d*%l*forle?ve?l%d+%-%d+",

	--URL's
	"1wowgold%.c%S+", --24 April 08 forward scggold
	"2wowgold%.c%S+", --5 May 08 forward gmworker
	"2wowgold%.%Som", --5 May 08 forward gmworker
	"29gameswow%.c%S+", --24 April 08
	"365ige%.c%S+", --24 April 08 forward gold230
	"5uneed%.c%S+", --8 May 08
	"51uoo%.c%S+", --24 April 08
	"agamegold%.c%S+", --24 April 08
	"bigmouthnest%.c%S+", --24 April 08 forward yesdaq
	"brothergame%.c%S+", --29 April 08
	"cheapsgold%.c%S+", --8 May 08
	"dewowgold%.c%S+", --26 April 08
	"df%-game%.c%S+", --29 April 08
	"dgameskydotc%S+", --29 April 08 dgamesky DOT com
	"dgamespydotc%S+", --29 April 08 dgamespy DOT com
	"epicgamegold%.c%S+", --5 May 08
	"eugspa%.c%S+", --24 April 08 forward mmospa
	"fast70%.c%S+", --27 April 08
	"fastgg%.c%S+", --8 May 08
	"fedwow%.c%S+", --30 April 08
	"fkugold%.c%S+", --5 May 08 forward yedaq
	"free%-levels", --25 April 08 DOT / . com
	"gagora%.c%S+", --24 April 08
	"game1999%.c%S+", --28 April 08
	"gamegold123%.c%S+", --24 April 08
	"gamenoble%.c%S+", --24 April 08
	"games%-level%.n+e+t", --9May 08
	"get%-levels%.c%S+", --29 April 08
	"gm365%.c%S+", --ogm365/igm365 8 May 08
	"gm963%.c%S+", --24 April 08
	"gmworker%.c%S+", --24 April 08
	"gmworking%.c%S+", --24 April 08
	"gmworking%.e+u+", --8 May 08 forward gmworking.com 
	"god%-moddot", --25 April 08 god-mod DOT com
	"gold230%.c%S+", --24 April 08
	"gold4guild", --9 May 08
	"gold660%.c%S+", --6 May 08
	"goldclassmates%.c" --9 May 08  forward yesdaq
	"goldhi5%.c", --9 May 08 forward yesdaq
	"goldmyspace%.c%S+", --5 May 08 forward yesdaq
	"goldpager%.c%S+", --26 April 08 forward yesdaq
	"goldsaler%.c%S+", --5 May 08
	"goldwow%.c%S+", --24 April 08 forward ige
	"goldzombie%.c%S+", --5 May 08
	"gtgold%.c%S+", --24 April 08 gtgold/heygt
	"happygolds%.c%S+", --24 April 08
	"helpugame%.c%S+", --24 April 08
	"heygt%.c%S+", --24 April 08 heygt/gtgold
	"heypk%.c%S+", --24 April 08
	"hotpvp%.c", --9 May 08
	"hpygame%.c%S+", --24 April 08
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
	"m8gold%.c%S+", --8 May 08
	"mayapl%.%S+", --5 May 08 mayapl.com
	"mmoinn%.c%S+", --24 April 08
	"mmospa%.c%S+", --24 April 08
	"ogchanne%S%.c%S+", --29 April 08 ogchannel /ogchanneI
	"okpenos%.c%S+", --5 May 08 forward yesaq
	"ownyo%.c%S+", --29 April 08 ownyo.com
	"owny%S+%.com", --29 April 08 ownyo.com
	"pkpkg%.c%S+", --24 April 08
	"playdone%.c%S+", --24 April 08
	"psmmo%.c%S+", --26 April 08
	"pvpboydot", --9 May 08 dot com
	"qwowgold%.c%S+", --5 May 08
	"scggame%.c%S+", --24 April 08
	"scggold%.c%S+", --24 April 08
	"ssegames%.c%S+", --24 April 08
	"speedpanda%.c%S+", --24 April 08
	"supplier2008%.c%S+", --27 April 08 forward tradewowgold
	"%.susanexpress%.%S+", --27 April 08 .com/.?om
	"tbgold%.c%S+", --8 May 08
	"tctwow%.c%S+", --24 April 08
	"terrarpg%.c%S+", --24 April 08 forward mmoinn
	"tgtimes%.c%S+", --24 April 08
	"torchgame%.c%S+", --24 April 08
	"tulongold%.c%S+", --24 April 08
	"ucgogo%.c%S+", --24 April 08
	"ucatm%.%l+%.tw", --24 April 08 .com/.url
	"ukwowgold%.c%S+", --24 April 08
	"vesgame%.c%S+", --27 April 08
	"vgsale%.c%S+", --28 April 08
	"vsguy%.c%S+", --26 April 08
	"whoyo%.c%S+", --24 April 08
	"wow%-europe%.cn", --8 May 08 forward gmworker
	"wow4s%.%S+", --26 April 08 .com / .net forward agamegold
	"wow7gold%.c%S+", --24 April 08
	"wowcnn%.c%S+", --5 May 08 forward gamegold123
	"wowcoming%.c%S+", --24 April 08
	"wowfbi%.c%S+", --24 April 08 forward gamegold123
	"wowforever%.c%S+", --24 April 08
	"wowgamelife", --9 May 08 
	"wowgoldbuy%.n+e+t+", --24 April 08 forward gm963
	"wowgoldget%.c", --9 May 08
	"wowgshop%.c%S+", --24 April 08
	"wow%-?hackers%.c%S+", --5 May 08 forward god-mod | wow-hackers / wowhackers
	"wowhax%.c%S+", --5 May 08
	"wowjx%.c%S+", --24 April 08 forward wowforever
	"wowmine%.c%S+", --24 April 08
	"wowpann%Sng%.c%S+", --24 April 08 wowpanning / wowpannlng
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
	if not CanComplainChat(savedID) then result = nil return end
	msg = lower(msg)
	msg = gsub(msg, " ", "")
	msg = gsub(msg, ",", ".")
	for k, v in ipairs(triggers) do
		if fnd(msg, v) then
			local time = GetTime()
			if (time - prev) > 20 and k > 2 then
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
local frame = CreateFrame("Frame")
local function fixmsg() COMPLAINT_ADDED = info end
frame:SetScript("OnEvent", fixmsg)
frame:RegisterEvent("CHAT_MSG_SYSTEM")

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", filter)
