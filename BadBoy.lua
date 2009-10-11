local ipairs = _G.ipairs
local fnd = _G.string.find
local lower = _G.string.lower
local rep = _G.strreplace

local triggers = {
	--Phrases
	"%d+%.?%d*pounds?[/\92=]?p?e?r?%d%d%d+g",
	"%d+%.?%d*eur?o?s?[/\92=]?p?e?r?%d%d%d+",
	"%d+%.?%d*dollars?[/\92=]?p?e?r?%d%d%d+g",
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
	"%d%d%d+gonlyeur%d+%.?%d*",
	"%d%d%d+gjust[\194\165\194\163%$\226\130\172]%d+",
	"%d%d%d+gjust%d+%.?%d*[\194\165\194\163%$\226\130\172]",
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
	"blizzard.*mount.*free.*trial.*log", --mount phishing
	"free.*mount.*info.*log",
	"blizzard.*einf\195\188hrung.*reittiere.*kostenlose.*testversion.*melde", --mount phishing deDE
	"blizz.*kosten.*test.*info.*einlog", --deDE
	"freespectraltigerloot.*redeem",
	"gold.*%d%d%d+g[/\92=]pounds?%d+.*gold",
	"gold.*%d+k[/\92=]gbp%d%d+.*gold",
	"%d%d+eur?o?s?for%d%d%d%d+g",
	"gold.*cheap.*price.*fast.*delivery",
	"powerlevel%l?ing.*gold.*fast.*delivery",
	"%d+k[/\92=]%d+%.?%d*gbp.*%%.*gold",
	"gold.*%d+k[/\92=]%d+%.?%d*eu",
	"service.*price.*delivery.*gold",
	"\226\130\172%d+%.?%d*f\195\188r%d%d%d+gold", --deDE
	"gold.*%d+%.?%d*eur?o?for%d%d%d+g",
	"gold.*deliver?y.*service",
	"gold.*deliver?y.*safe",
	"gold.*stock.*deliver?y",
	"gold.*%d+%.?%d*kjustfor%d+%.?%d*gbp",
	"visit.*cheap.*gold",
	"gold.*%d%d%d+justfor%d+%.?%d*gbp",
	"%d+kgonly%d+%.?%d*eu.*gold",
	"powerle?ve?l.*gold.*gold",
	"low.*price.*gold.*discount",
	"cheap.*fast.*gold.*deliv",
	"%W+.*wow.*gold.*shop.*%W+",
	"%d%d%d+gjust%d%.?%d*eu",
	"gold.*low.*price.*%d+kg",
	"you.*become.*blizzard.*gift.*add?res",
	"check.*new.*warcraft.*chron.*movie.*at",
	"mount.*server.*guys.*go.*app.*available",
	"set.*gear.*instance.*honor.*sale.*whisp", --T9 full set,superior gears from instance,212K honor points,emblem of Heroism and conquest are on sale now,we can get them 4u,just whisper me plz!!!
	"visit.*site.*items.*mats.*sale", --If you WTB these items,please visit our siteXYZ,we have all the BOE ITEMS and MATS for sale.we also provide the account trading and powerleveling service!!
	"get.*%d%d%d+g.*free.*gold.*store",
	"blizz.*launch.*cata.*trial.*info.*log",
	"blizz.*launch.*card.*exp.*reg.*free", --Hello,Blizzard will launch a three-fold experience of card (which means three times the value of experience) registration,Now you can get it 3 days for free. Address: XYZ
	"free.*mount.*wow.*first.*code.*claim",
	"wts.*%[.*%].*we.*boe.*mats.*sale", --wts [Pendulum of Doom] [Krol Cleaver] we have all the Boe items,mats and t8/t8.5 for sale .XYZ!!
	"suspect.*trade.*gold.*login.*complain.*pos", --Becasuse you suspected of lllegal trade for gold, system will freeze your ID after one hour.If you have any questions, please login  [XYZ] to make a complaint .We will be processing as soon as possible.

	--Lvl 1 whisperers
	".*%d+.*lfggameteam.*", --actually we have 10kg in stock from Lfggame team ,do you want some?
	"gold.*stock.*%d+.*min.*delivery.*buy.*gold", --hey,sry to bother,we have gold in stock,10-30mins delivery time. u wanna buy some gold today ?:)
	"gold.*server.*%d+.*stock.*buy", --Excuse me, i have sold 10k gold on this server, 22k left in stock right now, do you wanna buy some today?, 20-30mins delivery:)
	"free.*powerleveling.*level.*%d+.*interested", --Hello there! I am offering free powerleveling from level 70-80! Perhaps you are intrested? :)v
	"friend.*price.*%d+k.*gold", --dear friend.. may i tell you the price for 10k wow gold ?^^
	"we.*%d+k.*stock.*realm", --hi, we got 25k+++ in stock on this realm. r u interested?:P
	"we.*%d+k.*stock.*gold", --Sorry to bother you , We have 26k gold in stock right now. Are you intrested in buying some gold today?
	"we.*%d+k.*gold.*buy", --Sorry to bother. We got around 27.4k gold on this server, wondering if you might buy some quick gold with face to face trading ingame?
	"so?rr?y.*interest.*cheap.*gold", --sorry to trouble you , just wondering whether you have  any interest in getting some cheap gold at this moment ,dear dude ? ^^
	"we.*%d+k.*stock.*interested", --hi,we have 40k in stock today,interested ?:)
	"we.*%d%d%d+g.*stock.*price", --hi,we have the last 23600g in stock now ,ill give you the bottom price.do u need any?:D
	"cheap.*price.*buy.*%d%d%d+.*gold", --Really sorry to bother you , Cheapest price, no more waiting! I just wonder if you want to buy some of our 36000 gold stock. :)
	"buy.*gold.*bonus.*deliver", --Sry to bother u ,may i know whether u need to buy gold ? if u want to buy  ,i can give u nice bonus and it just takes 5-15mins to deliver. :) if not ,really so sry ,have a nice day !XD
	"hi.*%d%d+k.*stock.*interest", --hi ,30k++in stock any interest?:)
	"wondering.*you.*need.*buy.*g.*so?r?ry", --I am sunny, just wondering if you might need to buy some G. If not, sry to bother.:)
	"buy.*wow.*curr?ency.*deliver", --Would u like to buy WOW CURRENCY on our site?:)We deliver in 5min:-)
	"interest.*%d+kg.*price.*delive", --:P any interested in the last 30kg with the bottom price.. delivery within 5 to 10 mins:)
	"sorr?y.*bother.*another.*wow.*account.*use", --Hi,mate,sorry to bother,may i ask if u have another wow account that u dont use?:)
	"hello.*%d%d+k.*stock.*buy.*now", --hello mate :) 40k stock now,wanna buy some now?^^
	"price.*%d%d+g.*sale.*gold", --Excuse me. Bottom price!.  New and fresh 30000 G is for sale. Are you intrested in buying some gold today?
	"so?rr?y.*you.*tellyou.*%d+k.*wow.*gold", --sorry to bother you,may i tell you how much for 5k wow gold
	"excuse.*do.*need.*buy.*wow.*gold", --Excuse me,do u need to buy some wowgold?
	"bother.*%d%d%d+g.*server.*quick.*gold", --Sry to bother you, We have 57890 gold on this server do you want to purchase some quick gold today?
	"hey.*interest.*some.*fast.*%d+kg.*left", --hey,interested in some g fast?got 27kg left atm:)
	"know.*need.*buy.*gold.*delivery", --hi,its kitty here. may i know if you need to buy some quick gold today. 20-50 mins delivery speed,
	"may.*know.*have.*account.*don.*use", -- Hi ,May i know if you have an useless account that you dont use now ? :)  
	"company.*le?ve?l.*char.*%d%d.*free", --our company  can lvl your char to lvl 80 for FREE.
	"so?r?ry.*need.*cheap.*gold.*%d+", --sorry to disurb you. do you need some cheap gold 20k just need 122eur(108GBP)
	"hi.*isthis.*mainchar.*thiserver", --Hi %name%, is this ur main character on this server? :)
	"stock.*gold.*wonder.*buy.*so?rr?y", --Full stock gold! Wondering you might wanna buy some today ? sorry for bothering you.

	--URL's
	"17mins%.c", --21 June 09 ##
	"29gameswow%.c", --11 July 09##
	"2joygame%.c", --18 May 08 ## (deDE)
	"4wowgold%.c", --6 April 09 ##
	"5uneed%.c", --6 June 08 ##
	"925fancy%.c", --20 May 08 ##
	"ak774%.com", --30 May 09 ##
	"brothergame%.com", --02 June 09 ## (deDE)
	"btwor%.com", --12 August (Malware) @@
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
	"eur%-gold%.c", --19 August 09 @@
	"fast70%.c", --27 April 08 ~~
	"fastgg%.c", --20 May 08 ##
	"fastgolds%.c", --11 December 08 ##
	"fesgt%.c", --22 December 08 ## (esES)
	"g4pitem.c", --19 June 09 ## Item Selling
	"g4ppowerleveling%.c", --25 July 09 ##
	"games%-level%.n+e+t", --9May 08 ~~
	"garden2game%.com", --17 Oct 08
	"get%-levels%.c", --29 April 08 ~~
	"gmw.rking%.eu", --07 December 08 ##
	"god%-moddot", --25 April 08 god-mod DOT com ~~
	"gold4guild", --9 May 08 .com ##
	"goldba%.c", --9 June 09 ##
	"goldku%.c", --22 August 09 @@ [typos]
	"goldruler%.c", --05 May 09 ~~
	"goldspeeder%.c", --20 September 08 ##
	"gome4gold%.c", --24 March 09 ##
	"goodgolds%.c", --13 December 08 ##
	"happygolds%.", --08 July 08 ## (com)
	"happyleveling%.c", --09 May 09 ##
	"helpgolds%.c", --14 July 08 ## (deDE)
	"holdwow%.c", -- 20 September 08 ##
	"hotgolds%.c", --19 July 09 ##
	"ibgibg.c", --30 December 08 ## (deDE)
	"ignmax%.c", --13 March 09 ##
	"k4gold%.c", --24 October 08 ##
	"kgsgold", --16 May 08 .com ##
	"kugold%.c", --19 July 09 ##
	"let4gold%.c", --12 August 09 ##
	"leveler4wow.c", --04 January 09 ~~
	"%.levelvip%.", --08 April 09 ## (OM
	"luckygolds%.c", --11 December 09 ##
	"lvinn%.c", --07 August 09 @@
	"marketgolds%.c", --29 June 09 ##
	"mmige%.c", --16 February 09 ##
	"mmobusiness%.c", --04 August 08 ##
	"mmoggg%.c", --25 July 09 ## (deDE)
	"mmowned%(dot%)c", --21 May 08 ##
	"nowgold%.?com", --16 July 09 ##
	"oofay%.c", --30 May 09 ##
	"pkpkg%.c", --17 June 08 ##
	"pvp365%.c", --21 May 08 ## (frFR)
	"rollhack%.c", --5 July 08 ##
	"safegolds%.c", --18 Jan 09 ##
	"selfgold%.c", --16 July 09 ## (deDE)
	"sevengold%.c", --24 May 08 ##
	"skygolds%.c", --09 May 09 ##
	"ssegames%.c", --20 July 08 ##
	"supplier2008%.c", --30 May 08 forward tradewowgold ##
	"tbgold%.c", --29 April 09 ##
	"tebuy%.net", --14 February 09 ##
	"tebuy%.ws", --05 February 09 ##
	"time2wow%.c", --19 June 09 ##
	"torchgame%.c", --16 June 08 ## (deDE)
	"tpsale", --2 June 08 .com ##
	"upgold%.net", --10 June 08 ##
	"vesgame%.c", --20 September 08 ## (deDE)
	"vovgold%.c", --22 May 08 ##
	"vsvgame%.c", --29 June 09 ##
	"warcraft%-advantage%.c", --25 July 09 ## Hacks/trojan
	"welcomegold%.com", --24 May 09 ## [Multi Line]
	"wlkwowgold%.net", --28 June 09 ##
	"wootwowgold[%@%.]", --31 May 09 ## Mail/url
	"woowmart%.c", --25 July 09 ##
	"worldofgolds%.com", --20 October 08
	"worldofwarcraf%l?hacks%.net", --28 June 08 ##
	"wow1gold%.c", --22 December 08 ## (deDE)
	"wow4s%.net", --27 October 08 ~~
	"wow7gold%.c", --29 May 08 ##
	"wow%-?hackers%.c", --5 May 08 forward god-mod | wow-hackers / wowhackers ~~
	"wow%-npc%.c", --15 June 09 ##
	"wowgamelife", --14 July 08 ##
	"wowgold%-de%.c", --16 August 08 ##
	"wowgoldtm%.c", --21 June 09 ##
	"wowhax%.c", --5 May 08 ~~
	"wowmygold%.c", --11 November 08 ##
	"wowplayer%.de", --11 May 08 ~~
	"wowqueen%.c", --14 September 09 @@
	"wowseller%.c", --25 May 08 ##
	"wowsogood%.c", --20 July 08 ##
	"wowyour%.c", --18 March 09 ##
	"yesdaq%.", --16 June 08 ##
	"zibank%.com", --20 February 09 ## WTF at this? Not gold selling, some kind of goods website
}

local orig, prevReportTime, prevLineId, result = _G.COMPLAINT_ADDED, 0, 0, nil
local function filter(_, event, msg, player, _, _, _, _, channelId, _, _, _, lineId)
	if lineId == prevLineId then return result else prevLineId = lineId end --Incase a message is sent more than once (registered to more than 1 chatframe)
	if event == "CHAT_MSG_CHANNEL" and channelId == 0 then result = nil return end --Only scan official custom channels (gen/trade)
	if not _G.CanComplainChat(lineId) then result = nil return end --Don't report ourself
	local raw = msg
	msg = lower(msg) --Lower all text, remove capitals
	msg = rep(msg, " ", "") --Remove spaces
	msg = rep(msg, ",", ".") --Convert commas to periods
	for k, v in ipairs(triggers) do --Scan database
		if fnd(msg, v) then --Found a match
			if _G.BADBOY_DEBUG then print("|cFF33FF99BadBoy|r: ", v, " - ", raw, player) end --Debug
			local time = GetTime()
			if (time - prevReportTime) > 20 then --Timer so we don't report people that think saying "no we won't visit goldsiteX" is smart
				prevReportTime = time
				_G.COMPLAINT_ADDED = "|cFF33FF99BadBoy|r: "..orig.." |Hplayer:"..player.."|h["..player.."]|h" --Add name to reported message
				if _G.BADBOY_POPUP then --Manual reporting via popup
					--Add original spam line to Blizzard popup message
					_G.StaticPopupDialogs["CONFIRM_REPORT_SPAM_CHAT"].text = _G.REPORT_SPAM_CONFIRMATION .."\n\n".. rep(raw, "%", "%%")
					local dialog = _G.StaticPopup_Show("CONFIRM_REPORT_SPAM_CHAT", player)
					dialog.data = lineId
				else
					_G.ComplainChat(lineId) --Automatically report
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

