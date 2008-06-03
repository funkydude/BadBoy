local ipairs = _G.ipairs
local fnd = _G.string.find
local lower = _G.string.lower
local rep = _G.strreplace

local AUTO_REPORT = true --false otherwise

local triggers = {
	--Random/Art
	"^%.o+%.$", --[.ooooO Ooooo.]
	"%(only%d+%.?%d*eur?o?s?%)",
	"%+%=+%+",
	"gold%¦%=%¦power",
	"%+%=%@%-%=%@%-%+",
	"^www$",
	"^%.com$",
	"^%\%(only%d+%.?%d*pounds%)%/$",
	"^%\%_%)for%d+g%(%_%/$",
	"^$",

	--Phrases
	"%d+%.?%d*pounds?per%d+g",
	"%d+%.?%d*eur?o?s?per%d+g",
	"gold.*powerle?ve?l",
	"%d+%.?%d*%l*forle?ve?l%d+%-%d+",
	"%d+go?l?d?[/\=]%d+%.?%d*eu",
	"%d+g?o?l?d?[/\=]%d+%.?%d*usd",
	"%d+go?l?d?[/\=]%d+%.?%d*[¥£€%$]",
	"[¥£€%$]%d+%.?%d*[/\=]%d+g",
	"%d+%.?%d*usd[/\=]%d+g",
	"%d+%.%d+gbp[/\=]%d%d%d+",
	"%d+%.%d+eur[/\=]%d%d%d+",
	"%d+%.%d+[/\=]%d%d%d+g",
	"%d+g[/\=]eur%d+",
	"%d+go?l?d?only%d+%.?%d*[¥£€%$]",

	--URL's
	"2joygame%.c", --18 May 08 ## (deDE)
	"2wowgold%.%Som", --5 May 08 forward gmworker
	"5uneed%.c", --8 May 08
	"925fancy%.c", --20 May 08 ##
	"baycoo%.c", --14 May 08
	"brbgame%.c", --12 May 08
	"cfsgold%.c", --20 May 08 ## (deDE)
	"cheapleveling.c", --28 May 08 ##
	"dewowgold%.c", --26 April 08
	"df%-game%.c", --29 April 08
	"dgames%Sydotc", --29 April 08 dgame(sky/spy) DOT com
	--"epicgamegold%.c", --5 May 08
	"fast70%.c", --27 April 08
	"fastgg%.c", --20 May 08 ##
	"fedwow%.c", --30 April 08
	--"fkugold%.c", --5 May 08 forward yedaq
	"free%-levels", --25 April 08 DOT / . com
	"games%-level%.n+e+t", --9May 08
	"get%-levels%.c", --29 April 08
	"god%-moddot", --25 April 08 god-mod DOT com
	"gold4guild", --9 May 08 .com ##
	"gold660%.c", --6 May 08
	"goldsaler%.c", --5 May 08
	"goldzombie%.c", --5 May 08
	"happygolds%.c", --25 May 08 ##
	--"ighey%.c", --27 April 08
	"item4sale%.c", --26 April 08
	"iuc365%.c", --24 April 08
	"kgsgold", --16 May 08 .com ##
	--"leetgold%.c", --27 April 08
	"mmoxplore%.c", -- 9 May 08
	"mmowned%(dot%)c", --21 May 08 ##
	"ogchanneI.c", --29 April 08 actually ogchannel not ogchanneI
	--"okpenos%.c", --5 May 08 forward yesdaq
	"pvpboydot", --9 May 08 dot com
	"pvp365%.c", --21 May 08 ## (frFR)
	--"qwowgold%.c", --5 May 08
	"scbgold%.c", --15 May 08
	"sevengold%.c", --24 May 08 ##
	"supplier2008%.c", --30 May 08 forward tradewowgold ##
	"tpsale", --2 June 08 .com ##
	"vicsaledotc", --13 May 08
	"vovgold%.c", --22 May 08 ##
	"wow%-europe%.cn", --8 May 08 forward gmworker
	"wow7gold%.c", --29 May 08 ##
	--"wowcnn%.c", --5 May 08 forward gamegold123
	"wowgamelife", --9 May 08 
	"wowgoldduper%.c", --12 May 08
	"wowgoldget%.c", --9 May 08
	"wowgsg%.c", --10 May 08
	"wow%-?hackers%.c", --5 May 08 forward god-mod | wow-hackers / wowhackers
	"wowhax%.c", --5 May 08
	--"wowmine%.c", --24 April 08
	"wowpannlng%.c", --24 April 08 actually wowpanning not wowpannlng
	"wowpl%.n+e+t+", --5 May 08
	"wowplayer%.d+e+", --11 May 08
	"wowseller%.c", --25 May 08 ##
	"yesdaq%.c", --3 June 08 ##
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
			if k > 10 and (time - prev) > 20 then
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
