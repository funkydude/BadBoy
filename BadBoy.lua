local ipairs = _G.ipairs
local fnd = _G.string.find
local lower = _G.string.lower
local rep = _G.strreplace

local AUTO_REPORT = true --false otherwise

local triggers = {
	--Random/Art
	"%.o+%.", --[.ooooO Ooooo.]
	"%(only%d+%.?%d*eur?o?s?%)",
	"%+%=+%+",
	"gold%¦%=%¦power",
	"%+%=%@%-%=%@%-%+",
	"^www$",
	"^%.com$",

	--Phrases
	"%d+%.?%d*go?l?d?%/%d+%.?%d*eu",
	"%d+%.?%d*pounds?per%d+%.?%d*g",
	"%d+%.?%d*dollarsper%d+%.?%d*gold",
	"%d+%.?%d*eu%l+%d+%.?%d*g",
	"gold.*powerle?ve?ll?ing",
	"cheap.*fast.*gold",
	"%d+%.?%d*%l*forle?ve?l%d+%-%d+",
	"%$%d+%.?%d*%W%d+gold",
	"%d+g%W%d+%.?%d*eur",
	"%d+g%W%d+%.?%d*usd",
	"%d+g%W%d+%.?%d*%$",
	"%d+%.?%d*usd%W%d+g",
	"%d+%.?%d*gbp%W%d+g",
	"%d+%.%d+%W%d+g%.?%d+%.%d+%W%d+g",
	"%d+g%Weur%d+",

	--URL's
	--"%dwowgold%.c", --24 April 08 1wowgold forward scggold | 2wowgold forward gmworker
	"2wowgold%.%Som", --5 May 08 forward gmworker
	"29gameswow%.c", --24 April 08
	"365ige%.c", --24 April 08 forward gold230
	"5uneed%.c", --8 May 08
	"51uoo%.c", --24 April 08
	--"agamegold%.c", --24 April 08
	"baycoo%.c", --14 May 08
	--"belrion%(dot%)c", --13 May 08
	"bigmouthnest%.c", --24 April 08 forward yesdaq
	"brbgame%.c", --12 May 08
	"brothergame%.c", --29 April 08
	--"cheapsgold%.c", --8 May 08
	"dewowgold%.c", --26 April 08
	"df%-game%.c", --29 April 08
	"dgames%Sydotc", --29 April 08 dgame(sky/spy) DOT com
	"epicgamegold%.c", --5 May 08
	"eugspa%.c", --24 April 08 forward mmospa
	"fast70%.c", --27 April 08
	--"fastgg%.c", --8 May 08
	"fedwow%.c", --30 April 08
	"fkugold%.c", --5 May 08 forward yedaq
	"free%-levels", --25 April 08 DOT / . com
	"gagora%.c", --24 April 08
	"game1999%.c", --28 April 08
	--"gamegold123%.c", --24 April 08
	--"gamenoble%.c", --24 April 08
	"games%-level%.n+e+t", --9May 08
	"get%-levels%.c", --29 April 08
	"gm365%.c", --ogm365/igm365 8 May 08
	"gm963%.c", --24 April 08
	--"gmworker%.c", --24 April 08
	"gmworking%.c", --24 April 08
	"gmworking%.e+u+", --8 May 08 forward gmworking.com 
	"god%-moddot", --25 April 08 god-mod DOT com
	"gold230%.c", --24 April 08
	"gold4guild", --9 May 08 .com ##
	"gold660%.c", --6 May 08
	"goldclassmates%.c", --9 May 08  forward yesdaq
	"goldhi5%.c", --9 May 08 forward yesdaq
	"goldmyspace%.c", --5 May 08 forward yesdaq
	"goldpager%.c", --26 April 08 forward yesdaq
	"goldsaler%.c", --5 May 08
	"goldwow%.c", --24 April 08 forward ige
	"goldzombie%.c", --5 May 08
	--"gtgold%.c", --24 April 08 gtgold/heygt
	--"happygolds%.c", --24 April 08
	"helpugame%.c", --24 April 08
	"heygt%.c", --24 April 08 heygt/gtgold
	"heypk%.c", --24 April 08
	"hotpvp%.c", --9 May 08
	"hpygame%.c", --24 April 08
	"igamebuy%.c", --24 April 08
	"ige%.c", --24 April 08
	"igfad%.c", --24 April 08
	"ighey%.c", --27 April 08
	--"igs365%.c", --24 April 08 forward gmworker
	"item4sale%.c", --26 April 08
	"itemrate%.c", --24 April 08
	"iuc365%.c", --24 April 08
	"kgsgold", --16 May 08 .com ##
	"leetgold%.c", --27 April 08
	"luckwow%.c", --24 April 08
	--"m8gold%.c", --8 May 08
	--"mayapl%.", --5 May 08 mayapl.com
	--"mmoinn%.c", --24 April 08
	"mmospa%.c", --24 April 08
	"mmoxplore%.c", -- 9 May 08
	"ogchanneI.c", --29 April 08 actually ogchannel not ogchanneI
	"okpenos%.c", --5 May 08 forward yesaq
	"ownyo%.c", --29 April 08 ownyo.com
	"owny%S+%.com", --29 April 08 ownyo.com
	--"pkpkg%.c", --24 April 08
	"playdone%.c", --24 April 08
	"psmmo%.c", --26 April 08
	"pvpboydot", --9 May 08 dot com
	"qwowgold%.c", --5 May 08
	"scbgold%.c", --15 May 08
	"scggame%.c", --24 April 08
	"scggold%.c", --24 April 08
	"ssegames%.c", --24 April 08
	"speedpanda%.c", --24 April 08
	"supplier2008%.c", --27 April 08 forward tradewowgold
	--"%.susanexpress%.", --27 April 08 .com/.?om
	--"tbgold%.c", --8 May 08
	"tctwow%.c", --24 April 08
	"terrarpg%.c", --24 April 08 forward mmoinn
	"tgtimes%.c", --24 April 08
	"torchgame%.c", --24 April 08
	"tpsale%.c", --9 May 08
	"tulongold%.c", --24 April 08
	"ucgogo%.c", --24 April 08
	"ucatm%.%l+%.tw", --24 April 08 .com/.url
	--"ukwowgold%.c", --24 April 08
	"vesgame%.c", --27 April 08
	"vgsale%.c", --28 April 08
	"vicsaledotc", --13 May 08
	"vsguy%.c", --26 April 08
	"whoyo%.c", --24 April 08
	"wow%-europe%.cn", --8 May 08 forward gmworker
	"wow4s%.", --26 April 08 .com / .net forward agamegold
	"wow7gold%.c", --24 April 08
	"wowcnn%.c", --5 May 08 forward gamegold123
	"wowcoming%.c", --24 April 08
	"wowfbi%.c", --24 April 08 forward gamegold123
	"wowforever%.c", --24 April 08
	"wowgamelife", --9 May 08 
	"wowgoldbuy%.n+e+t+", --24 April 08 forward gm963
	"wowgoldduper%.c", --12 May 08
	"wowgoldget%.c", --9 May 08
	"wowgsg%.c", --10 May 08
	"wowgshop%.c", --24 April 08
	"wow%-?hackers%.c", --5 May 08 forward god-mod | wow-hackers / wowhackers
	"wowhax%.c", --5 May 08
	"wowjx%.c", --24 April 08 forward wowforever
	"wowmine%.c", --24 April 08
	"wowpannlng%.c", --24 April 08 actually wowpanning not wowpannlng
	"wowpl%.n+e+t+", --5 May 08
	"wowplayer%.d+e+", --11 May 08
	"wowseller%.c", --24 April 08
	"wowspa%.c", --24 April 08
	"wowsupplier%.c", --24 April 08
	"wowton%.c", --29 April 08
	"wowwar%.n+e+t+", --24 April 08 forward wowforever
	"yesdaq%.c", --24 April 08
}

local info, prev, savedID, result = COMPLAINT_ADDED, 0, 0, nil
local function filter(msg)
	if arg11 == savedID then return result else savedID = arg11 end --to work around a blizz bug
	if not CanComplainChat(savedID) then result = nil return end
	msg = lower(msg)
	msg = rep(msg, " ", "")
	msg = rep(msg, ",", ".")
	for k, v in ipairs(triggers) do
		if fnd(msg, v) then
			--ChatFrame1:AddMessage("|cFF33FF99BadBoy|r: "..v.." - "..msg) --Debug
			local time = GetTime()
			if k > 7 and (time - prev) > 20 then
				prev = time
				if AUTO_REPORT then
					COMPLAINT_ADDED = "|cFF33FF99BadBoy|r: " .. info .. " ("..arg2..")"
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
SetCVar("spamFilter", 1)
