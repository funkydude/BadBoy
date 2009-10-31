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
	"%d+.*stock.*%d+%.?%d*eur%W+%d+%.?%d*k",
	"gold.*deliver?y.*service",
	"gold.*deliver?y.*safe",
	"gold.*stock.*deliver?y",
	"gold.*%d+%.?%d*kjustfor%d+%.?%d*gbp",
	"cheap.*gold.*%d+.*profes.*le?ve?l",
	"gold.*%d%d%d+justfor%d+%.?%d*gbp",
	"%d+kgonly%d+%.?%d*eu.*gold",
	"powerle?ve?l.*gold.*gold",
	"low.*price.*gold.*discount",
	"cheap.*fast.*gold.*deliv",
	"gold.*%d%d%d+g%W+%d+%.?%d*%$",
	"%W+.*wow.*gold.*shop.*%W+",
	"%d%d%d+gjust%d%.?%d*eu",
	"gold.*low.*price.*%d+kg",
	"discount.*buy.*gold.*coupon",
	"you.*become.*blizzard.*gift.*add?res",
	"check.*new.*warcraft.*chron.*movie.*at",
	"mount.*server.*guys.*go.*app.*available",
	"fast.*cheap.*gold.*well?come", --Need fast and cheapest gold? Welcome to gold2wow website,big surprise is waiting for u,thx :P
	"set.*gear.*instance.*honor.*sale.*whisp", --T9 full set,superior gears from instance,212K honor points,emblem of Heroism and conquest are on sale now,we can get them 4u,just whisper me plz!!!
	"visit.*site.*items.*mats.*sale", --If you WTB these items,please visit our siteXYZ,we have all the BOE ITEMS and MATS for sale.we also provide the account trading and powerleveling service!!
	"get.*%d%d%d+g.*free.*gold.*store",
	"blizz.*launch.*cata.*trial.*info.*log",
	"blizz.*launch.*card.*exp.*reg.*free", --Hello,Blizzard will launch a three-fold experience of card (which means three times the value of experience) registration,Now you can get it 3 days for free. Address: XYZ
	"free.*mount.*wow.*first.*code.*claim",
	"wts.*%[.*%].*we.*boe.*mats.*sale", --wts [Pendulum of Doom] [Krol Cleaver] we have all the Boe items,mats and t8/t8.5 for sale .XYZ!!
	"suspect.*trade.*gold.*login.*complain.*pos", --Becasuse you suspected of lllegal trade for gold, system will freeze your ID after one hour.If you have any questions, please login  [XYZ] to make a complaint .We will be processing as soon as possible.
	"hello.*master.*warcraft.*acc.*temp.*suspend.*info", --hello! [Game Master]GM: Your world of warcraft account has been temporarily suspended. please go to XYZ for further information 
	"battle.*account.*player.*penguin.*register", --Hi,Battle.net account Players will receive a brand-new penguin in-game pet, Registered address : XYZ

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
	"we.*%d+k.*stock.*interest", --hi,we have 40k in stock today,interested ?:)
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
	"sorry.*disturb.*gold.*cheap.*interest", --hi,m8.Sorry to disturb you ,this is jerry from wow70gold, our web is doing promotion,the price is really cheap ,could I interest you in some?
	"hi.*you.*need.*gold.*we.*promotion", --[hi.do] you need some gold atm?we now have a promotion for it ^^

	--Advanced URL's
	"wow.*provider.*igs%.c.*po?we?rle?ve?l", --31 October 09
	"happygolds.*gold.*gold", --31 October 09
	"happygoldspointcom.*g", --31 October 09
	"friend.*website.*gold4guild", --31 October 09
	"cheap.*wow.*gold.*brogame%.c", --31 October 09
	"^%W+w*%.?gold4guild%.c[o0]m%W+$", --31 October 09
	"{vvv%Wbzgold%Wco[nm]%(v=w;%W=%.;?n?=?m?%)}$", --31 October 09 --Free gold={vvv_bzgold_com(v=w;_=.)}  --{vvv/bzgold/con(v=w;/=.;n=m)}
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
			if (time - prevReportTime) > 0.5 then --Timer to prevent spamming reported messages on multi line spam
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

