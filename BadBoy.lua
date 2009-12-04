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
	"deliver.*buy.*gold.*fast",
	"%d%d+k[/\92=]%d%d+%.?%d*eu.*gold", --10K=73EUR 10mins deliver .welcome to mysite ...WW W.g o l d ku.c0 m....
	"d[ei]liver.*stock.*safe.*gold", --<<WWW.WowRuler.COM>> 60USD=10k+Bonus Delivery in 10 mins (we have full stock of this server) Welcome to WWW.WowRuler.COM! Opportunity seldom knocks twice! Purely Manual without bot or hacking, Absolutely Safe Gold!
	--"WGL"=<< wwwwowgamelifecom >> the crazy promotion for our 2-year Anniversary cellebration ( 5.5 Euro for 1000 g,  50 Euro for 10000g+5% Free gold ^^fastest delivery in 5-10 mins.welcome to our website^^
	"promotion.*gold.*d[ei]liver", --Crazy promotion on WGL<< wwwwowgamelifecom >>  now,1k just for 5 GBP,10K just for 50 GBP, if u buy more than 10k,anther 10% extra gold as gift for u again^^ come on, all friend~ fastest delivery(within 5-10 mins) cya^^
	"buy.*gold.*euro.*gold", --Hi, Would you like to buy some gold today? In our site, it is 6.99 euro for 1k(trade gold face to face in 5-15 mins). If not, just enjoy the game ^^. (i am candy from [www.tbowow.com)]
	"gold.*sale.*d[ei]liver", --hi, im sally from [www.tbowow.com,] we have a lot of gold for sale, 6.99euro/1k and deliver in 10 mins after pay :) this is the best service for u, do you want to buy some gold today mate? :)
	"gold.*bonus.*discount", --Triple promotions at <www.k4gold.com>: 10% bonus g for each order;extra bonus for big orders more than 10k;and promotional code "dragon" for vip discount. Also private gifts from live chat for introducing others
	"gold.*d[ei]liver.*power%-?le?ve?l", --<www.4wowgold.c@m>,Cheapest Gold,5% of Bonus Golds to You (1000g=9.49$ 10000=87.39$)!with the discount code : "STOCK" ,order<10 Mins Diliver. The Professional Power-leveling & Honor-leveling for You! Welcome to (www.4wowgold.c@m)^_^
	"gold.*package.*%d%d+k.*promotion", --Patch 3.3 is coming, <<www.K4gold.com>> offers new VIP package. Say 200 loyal points with 200 free G for 10k,1500 points with 1500 free G for 50k. Use "DRAGON" as promotional code. And introduce others for secret gifts from live chat.Action now plz!
	"safe.*fast.*cheap.*gold", --The safest and the fastest  powerleveling  Lv1-80=====EUR 42.28  Lv1-60=====EUR 26.25 |   cheapest 10000Gold  Only  EUR 40.83 WWW . bestpowerleveling . NET ( 97
	"cheap.*price.*fast.*d[ie]liver", --www{star}mm4ss{star}com >> The cheapest price ( 5.2 Euro for 1000  and, 49.91Euro for 10000G  ) and fastest delivery.welcome to our website.Thanks ^^ cya ^^
	--Amazing! 1000G only costs you $2. Sign up an account on [www.GameUSD.com] NOW with the GIFT CODE $2 to get this slashed price! Google "Gameusd" to check our reputation in our customers!
	--Promotion: A 1000G only costs you $2. Sign up an account on [www.GameUSD.com] NOW with the GIFT CODE  $2 to get this slashed price! 50 members available everyday! Our normal price is $6 per 1000G without promotion! Hurry!
	"%d%d%d+g%l*only%l*%$%d+.*gift.*code", --GameUSD Promotion: A 1000G only costs you $2. Sign up with the gift code"2usd" on [www.GameUsd.com] now! ONLY 20 members available everyday! 2% discount coupon code for first time visitor! Enjoy it!
	"promotion.*purchase.*%d+k.*well?come", --Big promotion:we have hot new deals that you never see anywhere else,purchase g will get you mats or recipes for bonus. 15K-25K get ore ,35K get recipes,50K will get you ore and recipes.Welcome to <www.k4gold.com>
	"fast.*gold.*server.*deliver", --Welcome.!>>>>>> www.FesGame.com<<<<< Fast-Easy-Safe Gold shop!we got 50k golds on this sever, 10K=Euro39.99.deliver golds in 60mins.!!!!
	"crazy.*price.*code.*%d+k.*%d+pound", ---  www.k4gold.com for coming Halloween, crazy cut down price to reward customer, code "sugar"per 1K send 10% extra just 6pounds ,com on! take action^^   -
	--enUS	[[ 49.79/10k ]] WoW EU Gold [[ www . brothergame . com ]]99% Delivery in 4Min, 24h Service Gold on all Servers. 100% Security
	"%d+.*gold.*lieferung.*gold", --deDE [[ 49.79/10k ]] WoW EU Gold [[ www . brothergame . com ]]99% Lieferung in 4 Min, 24h ServiceGold auf allen Servern, 100% Sicherheit!
	--enUS	low price!!! now 10000g = only 66 euro !!!!! Delivery is secure & fast~~ more informations under-------- www.vsvgame.com-----------------
	"%d%d%d+g%W%l*%d%d+eu.*lieferung", --deDE niedriger Preis!!! jetzt 10000g = nur 66 euro !!!!! Lieferung ist sicher & schnell~~ mehr Informationen unter-------- www.vsvgame.com-----------------
	--enUS	Welcome~! Cheap gold, fast delivery, 10k for only 66 euros~~~~www.goldku.com~~~~
	"gold.*%d+kostennur%d+%.?%d*eu", --deDE herzlich Willkommen~!  billiges Gold, schnelle Lieferung, 10k kosten nur 66 euro~~~~www.goldku.com~~~~
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
	"become.*lucky.*player.*mysterious.*gift.*register", --Hi.You have become the lucky player, 2 days, you can get a mysterious gift, registered address:XYZ
	"christmas.*blizz.*gift.*receive.*free.*log", --Hello, Christmas is approaching, Blizzard released Christmas gifts players can receive free of charge,please log in: XYZ
	"player.*network.*blizz.*compensation.*log", --Dear players, because the network of World of Warcraft had broken off, Blizzard decided to give each player certain compensation.Please log in: XYZ and receive compensation for goods.
	"player.*blizz.*system.*scan.*acount", --Dear World of Warcraft players,Blizzard system scan to your account insecurity,please log the safety net , or else Blizzard will stop using your account's rights in one hour .Certification of Warcraft account information site " [XYZ]"
	"free.*spec.*mount.*code.*site", --Giving away free Spectral Tiger Mount ! Just be first to Reedem code : XU2199UXAI2881HTYAXNNB910 , go add it on site :  [XYZ] im stoping with damt wow ! GL guys

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
	"hi.*isthis.*mainchar.*thisserver", --Hi %name%, is this ur main character on this server? :)
	"stock.*gold.*wonder.*buy.*so?rr?y", --Full stock gold! Wondering you might wanna buy some today ? sorry for bothering you.
	"sorry.*disturb.*gold.*cheap.*interest", --hi,m8.Sorry to disturb you ,this is jerry from wow70gold, our web is doing promotion,the price is really cheap ,could I interest you in some?
	"hi.*you.*need.*gold.*we.*promotion", --[hi.do] you need some gold atm?we now have a promotion for it ^^
	"buy.*cheap.*gold.*eur.*bother", --Hi, would you like to buy some cheap gold (6.99euro/1k) today :) if not, sorry to bother you, have fun!
	"buy.*gold.*low.*price.*disturb", --Hi, would you like to buy some gold at a low price today? 1000g costs 6.99 euro. If not, just ignore me. :P Sorry to disturb, thanks and have a nice day!
	"price.*gold.*fast.*d[ei]liver", --Sorry to bother you .Do you want to buy gold today ?We give the best price and safest gold and fastest delivery .Only takes 5-10mins? ^^

	--Advanced URL's
	"wow.*provider.*igs%.c.*po?we?rle?ve?l", --31 October 09
	"happygolds.*gold.*gold", --31 October 09
	"happygoldspointcom.*g", --31 October 09
	"friend.*website.*gold4guild", --31 October 09
	"cheap.*wow.*gold.*brogame%.c", --31 October 09
	"^%W+w*%.?gold4guild%.c[o0]m%W+$", --31 October 09
	"{vvv%Wbzgold%Wco[nm]%(v=w;%W=%.;?n?=?m?%)}$", --31 October 09 --Free gold={vvv_bzgold_com(v=w;_=.)}  --{vvv/bzgold/con(v=w;/=.;n=m)}
}

local orig, prevReportTime, prevLineId, prevPlayer, result, raw = _G.COMPLAINT_ADDED, 0, 0, "", nil, ""
local function filter(_, event, msg, player, _, _, _, _, channelId, _, _, _, lineId)
	if lineId == prevLineId then
		return result --Incase a message is sent more than once (registered to more than 1 chatframe)
	else
		prevLineId = lineId
		if event == "CHAT_MSG_CHANNEL" and channelId == 0 then result = nil return end --Only scan official custom channels (gen/trade)
		if not _G.CanComplainChat(lineId) then result = nil return end --Don't report ourself/friends
		--If the text is same as the last line but the lineId is different, someone is macro spamming, consolidate to 1 line
		if raw == msg and player == prevPlayer then result = true return true else raw = msg prevPlayer = player end
	end
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
	else
		--Ninja this in here to prevent creating a login function & frame
		--We force this on so we don't have spam that would have been filtered, reported on the forums
		SetCVar("spamFilter", 1)
	end
end)

