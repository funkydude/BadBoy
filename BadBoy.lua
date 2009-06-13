local ipairs = _G.ipairs
local fnd = _G.string.find
local lower = _G.string.lower
local rep = _G.strreplace

local triggers = {
	--Phrases
	"%d+%.?%d*pounds?[/\92=]?p?e?r?%d%d%d+g",
	"%d+%.?%d*eur?o?s?[/\92=]?p?e?r?%d%d%d+",
	"%d+%.?%d*dollars?[/\92=]?p?e?r?%d%d%d+g",
	"gold.*power%-?le?ve?l",
	"%d+%.?%d*%l*forle?ve?l%d+%-%d+",
	"%d+go?l?d?[/\92=]%d+[%-%.]?%d*eu",
	"%d+g?o?l?d?s?[/\92=]%d+%.?%d*usd",
	"%d+g?o?l?d?s?[/\92=]%d+%.?%d*gbp",
	"%d+go?l?d?[/\92=]%d+%.?%d*[\194\165\194\163%$\226\130\172]",
	"[\194\165\194\163%$\226\130\172]%d+%.?%d*[/\92=]%d+g",
	"%d+%.?%d*usd[/\92=]%d+g",
	"%d+%.%d+gbp[/\92=]%d%d%d+",
	"%d+%.%d+[/\92=]%d%d%d+g",
	"%d+go?l?d?[/\92=]eur?%d+",
	"%d+g%l*ab%d+%.?%d*eu", --deDE
	"%d+g%l*only%d+%.?%d*[\194\165\194\163%$\226\130\172]",
	"%d+g%l*for[\194\165\194\163%$\226\130\172]%d+",
	"%d+g%l*only%d+%.?%d*eu",
	"%d+g%l*only%d+%.?%d*usd",
	"%d%d%d+gjust[\194\165\194\163%$\226\130\172]%d+",
	"%d%d%d+go?l?d?[/\92=]usd%d+",
	"%d+go?l?d?[/\92=][\194\165\194\163%$\226\130\172]%d+",
	"gold.*%d+[/\92=]%d+%.?%d*eu",
	"gold.*%d+%.%d%dper%d+g",
	"%d+%.?%d*per%d%d%d+g.*gold",
	"only%d+[\194\165\194\163%$\226\130\172]for%d%d%d+g.*safe", --fast delivery, safe trade
	"gold.*[\194\165\194\163%$\226\130\172]%d+%.?%d*per%l*%d%d%d+g", --deliver
	"gold.*%d+%.?%d*[\194\165\194\163%$\226\130\172][/\92=]%d%d%d+g",
	"%d+%.?%d*[\194\165\194\163%$\226\130\172][/\92=]%d%d%d+g.*delivery",
	"gold.*cheap.*safe",
	"company.*%d+.*gold.*buysome",
	"%d+.*wow.*gold.*for.*[\194\165\194\163%$\226\130\172]%d+",
	".*%d+.*powerleveling%d%-%d+=%d+eur",
	"[\194\165\194\163%$\226\130\172]%d+%.?%d*for%d%d%d+g.*gold",
	"happygolds.*gold.*gold",
	"happygoldspointcom.*g",
	"wirhaben%d+kgoldaufdiesemserver", --deDE
	".*%d%d%d+gonlycosted[\194\165\194\163%$\226\130\172]%d+%.%d%d+usd",
	"power%-?le?ve?l.*%d%d%d+g.*%d%d%d+g",
	"sellyour.*gold.*%d+us.*%d%.?%d*g",
	"gold.*%d%d%d+g[/\92=]gbp%d+",
	"wowgold.*low.*[\194\165\194\163%$\226\130\172]%d+%.?%d*[/\92]%d%d%d+",

	--URL's
	"15freelevels%.c", --26 July 08 ##
	"2joygame%.c", --18 May 08 ## (deDE)
	"4wowgold%.c", --6 April 09 ##
	"5uneed%.c", --6 June 08 ##
	"925fancy%.c", --20 May 08 ##
	"ak774%.com", --30 May 09 ##
	"beatwow%.c", --14 June 08 ##
	"blizz%-mounts%.c", --05 June 09 ## Phishing url
	"blizzard%-worldofwarcraft%.c", --07 May 09 ## Phishing url
	"brothergame%.com", --02 June 09 ## (deDE)
	"buyeuwow%.net", --20 February 09 ##
	"buywowgolds%.c", --05 May 09 ##
	"cfsgold%.c", --20 May 08 ## (deDE)
	"cheapsgold%.c", --24 November 08 ## (deDE)
	"coolwlk%.c", --29 December 08 ## (deDE)
	"crazyraid%.c", --20 April 09 ##
	"cwowgold%.c", --13 June 08 ##
	"cheapleveling%.c", --28 May 08 ##
	"dewowgold%.c", --26 April 08 ~~
	"dgamesky%.c", --5 November 08 ##
	"fast70%.c", --27 April 08 ~~
	"fastgg%.c", --20 May 08 ##
	"fastgolds%.c", --11 December 08 ##
	"fesgt%.c", --22 December 08 ## (esES)
	"games%-level%.n+e+t", --9May 08 ~~
	"garden2game%.com", --17 Oct 08
	"get%-levels%.c", --29 April 08 ~~
	"gmw.rking%.eu", --07 December 08 ##
	"god%-moddot", --25 April 08 god-mod DOT com ~~
	"gold4guild", --9 May 08 .com ##
	"goldba%.c", --9 June 09 ##
	"goldruler%.c", --05 May 09 ~~
	"goldspeeder%.c", --20 September 08 ##
	"gome4gold%.c", --24 March 09 ##
	"goodgolds%.c", --13 December 08 ##
	"happygolds%.", --08 July 08 ## (com)
	"happyleveling%.c", --09 May 09 ##
	"helpgolds%.c", --14 July 08 ## (deDE)
	"holdwow%.c", -- 20 September 08 ##
	"ibgibg.c", --30 December 08 ## (deDE)
	"ignmax%.c", --13 March 09 ##
	"k4gold%.c", --24 October 08 ##
	"kgsgold", --16 May 08 .com ##
	"leveler4wow.c", --04 January 09 ~~
	"%.levelvip%.", --08 April 09 ## (OM
	"luckygolds%.c", --11 December 09 ##
	"mmige%.c", --16 February 09 ##
	"mmobusiness%.c", --04 August 08 ##
	"mmowned%(dot%)c", --21 May 08 ##
	"mounts%-wow%.c", --29 May 09 ##
	"oofay%.c", --30 May 09 ##
	"pkpkg%.c", --17 June 08 ##
	"pvp365%.c", --21 May 08 ## (frFR)
	"rollhack%.c", --5 July 08 ##
	"safegolds%.c", --18 Jan 09 ##
	"sevengold%.c", --24 May 08 ##
	"skygolds%.c", --09 May 09 ##
	"ssegames%.c", --20 July 08 ##
	"supplier2008%.c", --30 May 08 forward tradewowgold ##
	"tbgold%.c", --29 April 09 ##
	"tebuy%.net", --14 February 09 ##
	"tebuy%.ws", --05 February 09 ##
	"torchgame%.c", --16 June 08 ## (deDE)
	"tpsale", --2 June 08 .com ##
	"upgold%.net", --10 June 08 ##
	"vesgame%.c", --20 September 08 ## (deDE)
	"vovgold%.c", --22 May 08 ##
	"welcomegold%.com", --24 May 09 ## [Multi Line]
	"wootwowgold[%@%.]", --31 May 09 ## Mail/url
	"worldofwarcraf%l?hacks%.net", --28 June 08 ##
	"wow1gold%.c", --22 December 08 ## (deDE)
	"wow4s%.net", --27 October 08 ~~
	"wow7gold%.c", --29 May 08 ##
	"wow%-?hackers%.c", --5 May 08 forward god-mod | wow-hackers / wowhackers ~~
	"wowgamelife", --14 July 08 ##
	"wowgold%-de%.c", --16 August 08 ##
	"wowhax%.c", --5 May 08 ~~
	"wowmygold%.c", --11 November 08 ##
	"worldofgolds%.com", --20 October 08
	"wowplayer%.de", --11 May 08 ~~
	"wowseller%.c", --25 May 08 ##
	"wowsogood%.c", --20 July 08 ##
	"wowyour%.c", --18 March 09 ##
	"yesdaq%.", --16 June 08 ##
	"zibank%.com", --20 February 09 ## WTF at this? Not gold selling, some kind of goods website

	--Emails
	"ice3mana%@hotmail%.com", --22 December 08
	"kimmwarlock%@hotmail%.com", --22 December 08
	"wowmana01%@hotmail%.com", --04 January 09

	--Lvl 1 whisperers
	".*%d+.*lfggameteam.*", --actually we have 10kg in stock from Lfggame team ,do you want some?
}

local orig, prev, savedID, result = _G.COMPLAINT_ADDED, 0, 0, nil
local type, n, fail = _G.type, "number", nil --temp for a few weeks
local function filter(_, event, msg, name, _, _, _, _, chanid, _, _, _, id)
	--remove this check after a few weeks, gives addons time to update and fix.
	if type(id) ~= n then
		if not fail then
			fail = true
			print("|cFF33FF99BadBoy|r: Spam reporting error.")
			print("|cFF33FF99BadBoy|r: An unknown addon is breaking BadBoy.")
		end
		return
	end
	if id == savedID then return result else savedID = id end --Incase a message is sent more than once (registered to more than 1 chatframe)
	if event == "CHAT_MSG_CHANNEL" and chanid == 0 then result = nil return end --Only scan official custom channels (gen/trade)
	if not _G.CanComplainChat(id) then result = nil return end --Don't report ourself
	local raw = msg
	msg = lower(msg) --Lower all text, remove capitals
	msg = rep(msg, " ", "") --Remove spaces
	msg = rep(msg, ",", ".") --Convert commas to periods
	for k, v in ipairs(triggers) do --Scan database
		if fnd(msg, v) then --Found a match
			if _G.BADBOY_DEBUG then print("|cFF33FF99BadBoy|r: ", v, " - ", raw, name) end --Debug
			local time = GetTime()
			if (time - prev) > 20 then --Timer so we don't report people that think saying "no we won't visit goldsiteX" is smart
				prev = time
				_G.COMPLAINT_ADDED = "|cFF33FF99BadBoy|r: " .. orig .. " ("..name..")" --Add name to reported message
				if _G.BADBOY_POPUP then --Manual reporting via popup
					--Add original spam line to Blizzard popup message
					_G.StaticPopupDialogs["CONFIRM_REPORT_SPAM_CHAT"].text = _G.REPORT_SPAM_CONFIRMATION .."\n\n".. raw
					local dialog = _G.StaticPopup_Show("CONFIRM_REPORT_SPAM_CHAT", name)
					dialog.data = id
				else
					_G.ComplainChat(id) --Automatically report
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
ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", filter)

--Function for disabling BadBoy reports and misc required functions
ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", function(_, _, msg)
	if msg == orig then
		return --Manual spam report, back down
	elseif msg == _G.COMPLAINT_ADDED then
		_G.COMPLAINT_ADDED = orig --Reset reported message to default for manual reporting
		if _G.BADBOY_POPUP then
			--Reset popup message to default for manual reporting
			_G.StaticPopupDialogs["CONFIRM_REPORT_SPAM_CHAT"].text = _G.REPORT_SPAM_CONFIRMATION
		end
		if _G.BADBOY_SILENT then
			return true --Filter out the report if enabled
		end
	end
	--Ninja this in here to prevent creating a login function & frame
	--We force this on so we don't have spam that would have been filtered, reported on the forums
	SetCVar("spamFilter", 1)
end)

