--DO NOT MODIFY DATABASE OR YOU MAY REPORT INNOCENT PEOPLE, HEURISTIC FUNCTION DEPENDS ON WORDS BEING ON CERTAIN LINES
local triggers = {
	--English - Common
	"bonus", --1
	"buy", --2
	"cheap", --3
	"coupon", --4
	"customer", --5
	"deliver", --6
	"discount", --7
	"extra", --8 //extra/sale
	"gold", --9
	"lowest", --10
	"order", --11
	"powerlevel", --12
	"price", --13
	"promoti[on][gn]", --14
	"reduced", --15
	"safe", --16
	"secure", --17
	"server", --18
	"service", --19
	"stock", --20
	"welcome", --21
	"www", --22
	"%d+%.?%d*eur", --23
	"%d+%.?%d*dollars", --24
	"[\226\130\172$\194\163]%d+", --25

	--French - Common
	"livraison", --delivery --26

	--German - Common
	"lieferung", --delivery --27
	"preis", --price --28
	"willkommen", --welcome --29

	--Spanish - Common
	"barato", --cheap --30
	"seguro", --safe/secure --31
	"r[\195\161a]pido", --fast --32
	"gratuito", --free --33

	--Phishing
	"blizz.*launch.*cata.*trial.*info.*log",
	"blizz.*launch.*card.*exp.*reg.*free", --Hello,Blizzard will launch a three-fold experience of card (which means three times the value of experience) registration,Now you can get it 3 days for free. Address: XYZ
	"free.*mount.*wow.*first.*code.*claim",
	"suspect.*trade.*gold.*login.*complain.*pos", --Becasuse you suspected of lllegal trade for gold, system will freeze your ID after one hour.If you have any questions, please login  [XYZ] to make a complaint .We will be processing as soon as possible.
	"become.*lucky.*player.*mysterious.*gift.*[lr][oe]g", --Hi.You have become the lucky player, 2 days, you can get a mysterious gift, registered address:XYZ
	"player.*network.*blizz.*compensation.*good", --Dear players, because the network of World of Warcraft had broken off, Blizzard decided to give each player certain compensation.Please log in: XYZ and receive compensation for goods.
	"player.*blizz.*system.*scan.*acount", --Dear World of Warcraft players,Blizzard system scan to your account insecurity,please log the safety net , or else Blizzard will stop using your account's rights in one hour .Certification of Warcraft account information site " [XYZ]"
	"free.*spec.*mount.*code.*site", --Giving away free Spectral Tiger Mount ! Just be first to Reedem code : XU2199UXAI2881HTYAXNNB910 , go add it on site :  [XYZ] im stoping with damt wow ! GL guys
	"free.*spectr.*tiger.*claim.*first", --Giving away Free Spectral tiger, because i'm  stopping with wow forever, to get it, just go there  [XYZ] and claim it as first, code : LJA8-5PLH61-KAHFL-152HOA-UAKL
	"become.*lucky.*player.*free.*motor.*log", --Hi. You have become the lucky players, will receive free a motorcycle. please log in:XYZ
	"become.*blizz.*customer.*gift.*reg", --Hi! You have become a Blizz lucky Customer, 3 days later you'll get a Mystery Gift, registered address: XYZ
	"claim.*free.*time.*warcraft.*free", --Hi,Claim Your Free Game Time!One or more of your World of Warcraft licenses are eligible for 70 free days of game time! please log in:XYZ
	"warcraft.*account.*temp.*suspend.*inf", --Your world of warcraft account has been temporarily suspended. go to  [XYZ] for further information.......
	"blizz.*launch.*free.*now.*log", --#Hey! Blizzard is to launch Free unicorn zebra, Get Now please log in : [XYZ] .^#
	"system.*pumping.*lucky.*player.*info", --Hello, you have been system Pumping To the lucky player ,For more informationplease log in: [XYZ]
	"warcraft.*blizzard.*scan.*account.*safety", --Dear World of Warcraft players,Blizzard system scan to your account insecurity,please log the safety net , or else Blizzard will stop using your account's rights in one hour .Certification of Warcraft account information site " [XYZ]
	"celebrate.*blizzard.*warcraft.*gift.*log", --Hello, To celebrate the Blizzard anniversary, World of Warcraft released gifts players can receive free of charge, please log in; [XYZ]
	"enter.*offer.*free.*riding.*log", --Hi, Bizzard Enterainment offers you one time free rare riding chance. Now take it , please login:[XYZ]
	"you.*obtain.*mount.*blizzard.*info", --Hello, you have obtained a rare mount from Blizzard, but you haven't yet receive it. For more information, please visit [XYZ]
	"congrat.*present.*blizz.*gold.*please", --Hi! congratulations on being presented by Blizzard of 3500 gold, please log in to recieve: XYZ
	"you.*account.*temp.*disabled.*info", --Your account will be temporarily disabled.Please visit [XYZ] for more information
	"congratu.*cata.*beta.*invitation.*activate", --Congratulations! You've got a WOW Cataclysm Beta Invitation. Please visit XYZ to activate your account.
	"congratu.*shirt.*world.*warcraft.*prize", --Hello. Congratulations, you get a T shirt for World of Warcraft. Want to know prizes, please visit the Forum: XYZ
	"blizz.*account.*warcraft.*catac.*beta", --hello,Blizzard Entertainment notifies you that your account has been chosen to participate in World of Warcraft Cataclysm beta test. For more information please visit  [XYZ]
	--enUS Congratulations you will become a happy player, you will get a free trial version of the new Blizzard 310% Invincible Ghost flying mount, 24 hours, please register now: XYZ
	"spieler.*testversion.*blizz.*invincible.*ghost", --deDE Herzlichen Gluckwunsch Sie werden gluckliche Spieler, werden Sie eine kostenlose Testversion erhalten neuesten Blizzard 310% Invincible Ghost fliegende Reittiere, 24 Stunden, bitte jetzt anmelden: XYZ
	"blizz.*launch.*mount.*trial.*info", --Hi, Blizzard is about to launch a new mounts, Free trial, For more information, please log in: XYZ
	"you.*drawn.*system.*gift.*steed", --Hello,you are drawn in the system to receive your gift.Please visit: [XYZ] Celestial Steed will be yours.
	"blizz.*system.*account.*violation.*trading", --Hello! Blizzard game system scan to your game account, a violation of rules of the game's virtual currency trading! Please visit our website [XYZ] review your account information, or we will suspend your account.
	"thank.*support.*warcraft.*blizz.*steed", --Hello. To thank you for your support for World of Warcraft. Blizzard will be giving your horse a celestial steed.Receiving please visit: XYZ
	"hallo.*system.*gift.*steed.*erhalten", --Hallo, sind Sie in das System gezogen, um Ihren Besuch gift.Please: XYZ Celestial Steed erhalten verkaufen werden
	"spieler.*netz.*warcraft.*blizz.*kompensation", --Liebe Spieler, weil das Netz der World of Warcraft gebrochen hatte, entschied sich Blizzard zu geben, jeder Spieler gewisse Kompensation. Bitte besuchen Sie: XYZ und erhalten einen Ausgleich fur Waren.
	"master.*konto.*deaktiviert.*besuchen.*informationen", --Hallo! Game Master(GM) whispers: Ihr Konto wird vorubergehend [deaktiviert.Bitte] besuchen [XYZ] fur weitere Informationen
	"obtain.*mount.*blizzard.*receive.*submit", --Hello, you have obtained a rare mount from Blizzard, but you haven't yet receive it. please log in XYZ and submit your email.
	"player.*account.*complain.*info.*right", --Dear players, your account is complaints by other players, please visit account information site validate your information,or else will stop using your account's rights in one hour. warcraft account information site: XYZ
	--enUS Support for world of warcraft. Blizzard will give you a Celestial Steed .To receive it, please visit: [XYZ]
	"warcraft.*blizzard.*himmlischen.*steed.*receiv", --Unterstutzung fur World of Warcraft. Blizzard wird geben Ihrem Pferd einen Besuch bitte himmlischen [steed.Receiving]: [XYZ]
	"detected.*software.*account.*info.*action", --We have detected third-party software associated with your account. Please log in to [XYZ] with your [Battle.Net] information before action is taken against your account
	"support.*warcraft.*website.*rare.*mount", --Hello! Thank you for your support for World of Warcraft, now visit the official website will have the rare baby, and mounts, please visit: XYZ
	"drawn.*system.*gift.*tiger", --Hello,you are drawn in the system to receive your gift.Pleast visit:   [XYZ]  Swift Spectral Tiger will be yours.
	"customer.*blizz.*lucky.*player.*gift", --Dear Customer, you have become a blizzard lucky Players, can get a gift,registered address: XYZ
	"drawn.*system.*receive.*cataclysm.*beta", --CONGRATULATiONS!YOU ARE DRAWN IN THE SYSTEM TO RECEiVE YOUR ACHiEVEMENTS REWARDS! IT'S A CATACLYSM  CLOSED BETA!PLEASE  ViSIT:[XYZ--BLiZZARD]
	"hallo.*schon.*system.*erhalten.*klicken", --Hallo!Sie sind schon von diesem System auserwahlt worden und werden Pramie erhalten. Klicken Sie bitte: [XYZ]#!
	"blizz.*notif[iy].*account.*cataclysm.*info", --Hello,Blizzard Entertainment notifies you that your WOW account has been chosen to participate in Cataclysm beta test. For more information please visit: XYZ
	"blizz.*account.*safety.*hacker.*opportunity", --Blizzard latest activities, cell phone locked account hundred percent safety of your account, no interference by hackers who have the opportunity to get big disaster trial eligibility, please visit:XYZ
	"blizz.*warcraft.*account.*info.*disable", --Hello! Blizzard World of Warcraft game found in violation of your game account, please visit our website [XYZ] enter your information, pending review, or we will permanently disable your game account. 
	"blizz.*monk.*store.*log.*submit.*free", --Hello, In celebration of BlizzCon 2010 you have receieved a Pandaren Monk Pet from the Blizzard Pet Store. please log in at [XYZ] Submit your email, and your free pet will be sent to all of your characters!
	"surprise.*summon.*worgen.*first.*conquer.*visit", --surprise!Summons from goblins and worgens, the first warrior to conquer Azeroth will be you!please visit:[XYZ]
	"congratulation.*limited.*warcraft.*mounts.*log", --Congratulations, you get limited edition World of Warcraft flying mounts.  please log in to receive:  XYZ
	"become.*blizz.*customer.*free.*log", --Hi! You have become a Blizz lucky Customer, 3 days later you'll get a Free unicorn zebra , please log in : XYZ
	"congratulation.*warcraft.*mount.*tiger.*log", --Congratulations! World of Warcraft virtual rare mounts you get the Ghost Tiger Mounts, please log in to receive: XYZ
	"warcraft.*cataclysm.*beta.*download.*visit", --Hello,World of Warcraft: 85 Cataclysm Test!beta client download!please visit: XYZ
	"blizz.*scan.*system.*account.*virtuel.*website", --Hallo Blizzard Scanning-System zu Ihrem Spiel-Account ein Versto gegen die Regeln des Spiels virtuelle Devisenhandel Bitte besuchen Sie unsere Website XYZ prufen Sie die Kontodaten oder wir werden Ihrem Konto auszusetzen.
	"master.*account.*info.*changed.*visit.*info", --hello! [Game Master]GM:Your account information is changed, please visit [XYZ] understanding of your information
	"blizz.*inform.*qualified.*cataclysm.*info", --Hello!Blizzard entertainment informs your that your are qualified toparticipate in cataclysm beta test.for more information please visit:XYZ
	"congratu.*celestial.*mount.*warcraft.*log.*receive", --Congratulations, you get Celestial Steed Flying mount in World of Warcraft, please log in to receive
	"obtained.*rare.*mount.*blizzard.*haven.*receive.*log", --Hi, you have obtained a rare mount from Blizzard, but you haven't yet receive it. please log in XYZ
	"cataclysm.*qualify.*mysterious.*gift.*blizzard", --Hi, the Cataclysm is coming soon, you are qualify to obtain the mysterious gift from Blizzard, please log in to get it XYZ
	"congrat.*invited.*warcraft.*cataclysm.*random.*visit", --Congratulations, you are invited to World of Warcraft Cataclysm Beta, Beta invites are completely random, Visit XYZ Cataclysm Beta more info!
	"warcraft.*katastrophe.*kostenlos.*reittiere.*besuchen", --Hallo,Vielen Dank fur Ihre Unterstutzung fur World of Warcraft,die bevorstehende Katastrophe,haben Zugang zu den seltenen Woche kostenlos spielen Zeit und Reittiere,besuchen Sie bitte:XYZ
	"gm.*account.*suspend.*temp.*please.*info", --hi:[GM] Your account will be suspended temporarily ,Please go to for further information XYZ

	--Personal Whispers
	"server.*purchase.*gold.*deliv", --sorry to bother,currently we have 29200g on this server, wondering if you might purchase some gold today? 15mins delivery:)
	".*%d+.*lfggameteam.*", --actually we have 10kg in stock from Lfggame team ,do you want some?
	"free.*powerleveling.*level.*%d+.*interested", --Hello there! I am offering free powerleveling from level 70-80! Perhaps you are intrested? :)v
	"friend.*price.*%d+k.*gold", --dear friend.. may i tell you the price for 10k wow gold ?^^
	"we.*%d+k.*stock.*realm", --hi, we got 25k+++ in stock on this realm. r u interested?:P
	"we.*%d+k.*stock.*gold", --Sorry to bother you , We have 26k gold in stock right now. Are you intrested in buying some gold today?
	"we.*%d+k.*gold.*buy", --Sorry to bother. We got around 27.4k gold on this server, wondering if you might buy some quick gold with face to face trading ingame?
	"so?rr?y.*interest.*cheap.*gold", --sorry to trouble you , just wondering whether you have  any interest in getting some cheap gold at this moment ,dear dude ? ^^
	"we.*%d+k.*stock.*interest", --hi,we have 40k in stock today,interested ?:)
	"we.*%d%d%d+g.*stock.*price", --hi,we have the last 23600g in stock now ,ill give you the bottom price.do u need any?:D
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
	"stock.*gold.*wonder.*buy.*so?rr?y", --Full stock gold! Wondering you might wanna buy some today ? sorry for bothering you.
	"hi.*you.*need.*gold.*we.*promotion", --[hi.do] you need some gold atm?we now have a promotion for it ^^
	"brbgame.*need.*gold.*only.*fast.*deliver", --sry to bother i am maria from brbgame, may i pease enquire as to whether u r in need of wow gold ?:P only 3$ per k with fast delivery !\
	"so?r?ry.*bother.*still.*%d+k.*left.*buy.*gold", --sry to bother you ,we still have around 52k left atm, you wanna buy some gold quickly today ?
	"may.*ask.*whether.*interest.*ing.*boe.*stuff.*rocket", --hmm, may i ask whether u r interested in g or boe stuffs such as X-53 Touring Rocket:P

	--Casino
	--HATERZZ CASINO! 1-64 You lose.. 65-94 You get double, 95-100 TRIPLE! Starting at 10g, max is 400g!
	--Tindrens Casino Is Now Open!!!1-63 I Win, 64-95 Double, 96-100 Triple!!!Min Bet 100 Max Bet 500!!!PST ME TO PLAY!
	--CASINO 1-59 (lose)60-94(double) 95-100 (TRIPLE) min is 500 max is 2k PST
	--warrior casino 1-64 you lose 65-94 you get dubble your bet and 95-100 is triple bets start at 5g and max at 500g pst!
	--Little Horde House High Roller's Hide Out!!! 1-61 house, 62-92 DOUBLE, 93-100 TRIPLE!!  Min bet 500g, max 2k, bigger bets with better odds! For the High Rollers!
	--Little Horde House Of Luck!! 1-62 i win, 63-95 DOUBLE YOUR BET, 96-100 TRIPLE YOUR BET!!! Only 10g to play! Max 1kg. Have some fun, and buy that new item you wanted!!
	--1-63 lose 64-94 DOUBLE 95+ Triple! MIN IS 200G AND 7K IS MAX PST
	--Euphoric rolls make you happy!  1-60 i win   61-91 you double your bet  92-99 you triple 100+ quad Min Bet 350g
	"%d+%-%d+.*d[ou][bu]ble.*%d+%-%d+.*tripp?le", --10 minimum 400 max\roll\61-97 double, 98-100 triple, come roll,

	--Advanced URL's/Misc
	"^%W+.*service.*website.*wowgoldcat.*%W+$", ----Good Service Website:[www.wowgoldcat.com]-- July 10
	--{triangle}M4S{triangle} {diamond}{diamond}WOWGOLDCAT.COM{diamond}{diamond}{triangle} E15.8/10k{triangle}Power Lvl 1-80{triangle}
	--{triangle}M4S{triangle}{diamond}{diamond}WOWGOLDCA T.COM{diamond}{diamond}{triangle} E15.8/10000G{triangle}Power Lvl 70-80/E25.99 {triangle}
	"wowgoldcat%.com.*%d+%W%d+[kg].*powerlvl.*%d+", --More Choice ===> [wowgoldcat.com]==> E15.8 /10k+Power Lvl 1-80 --July 10
	--WTS [item] // Wir verkaufen [item]
	--We provide equipment,mount,and stuff what you wanted.We have 300 professional players make it for you.
	--If you have any question,please check our site{star}WWW.PVPBank.c{circle}m{star}24/7 twenty-four seven.
	--We present 100 discount{square}core=itempvp{square}with 20% money discount.Sorry for disturb, Enjoy your game.
	"www%.pvpbank%.c.*24", --Wir haben mehr Ausr?stungen, Mounts und Items, die Sie mochten. Professionelles Team fuer 300 Personen sind 24 Stunde fuer Sie da.Wenn Sie Fragen haben,wenden Sie an uns bitteWWW.PVPBank.C{circle}M7 Tage 24 Uhr Service.
	--{square}luckygolds,com{square}{diamond}only 14 euro per 10K{diamond}{triangle}10 min delivery{triangle}
	--{square}lucktgilds,com{square}{diamond} only 14 euro per 10K{diamond}{triangle}10 min delivery{triangle}
	"g[oi]lds.*%d+eur.*%d+k.*%d+mindeliver", --luckygolds ==>>luckygolds,com==>>only 19 euro per 10K==>>10 min deliver
	"^%W+safer.*loyal.*customers%W+$", -----Safer, We've many loyal customers----- July 10
	"^%W+.*buyeugold%..*only.*euro", -->> WWW .Buyeugold.COM << Only 16 Euro for10 K+500G --June 10
	"well?come.*website.*wowgamegold.*best", --Wellcome to our website>>> www.wowgamegold,net<<<We are your best choice. --June 10
	"^%W+mm[0o]%[?yy%.c[0o]m%W+$", --May 10
	"^%W+diymm[0o]game.c[0o]m%W+$", --June 10
	--Good Choice ===> MMO4STORE.C0M ==> only (=19.9 per 10k --June 10
	--Good Choice==> BUYEUGOLD.COM==>Only E17 per 10K --June 10
	--Good Choice ===> MMO4STORE.CC ==> only E16.36 per 10k --June 10
	--Good==>{star}WOWGAMELIFE{star}.C@M==>Only E15 per 10K
	"^goodc?h?o?i?c?e?%W+.*%.c[co0@]m?%W+only.*%d+.*%d+k$", --Good Choice==>29 [GOLD.COM]==>Only E18 per 10K
	--Choice "M4M"==>WOWGAMELIFE.C@M==>Only E17 per 10K
	--"M4M"==>WOWGAMELIFE.C@M==>Only E15 per 10K
	--{star}M 4 M{star}==>> BUYEUGOLD.COM ==>>Only 15 EU for 10k
	--{star}M 4 M{star}==> BUYEUGOLD.C@M ==>Only E15{star}10K
	--{star}M 4 M{star}===> BUYEUGOLD.COM ===>Only E15 per 10K+500g
	"m4m.*%W+.*%.c[co0@]m?%W+only.*%d+.*%d+[kg]$", --Choice"M4M"=>>BUYEUGOLD.COM=>>Only E13.7 per 10K
	"sell.*safe.*fast.*site.*gold2wow", --()()Hot selling:safest and fastest trade,reliable site gold2wow()() --June 10
	"^%W+m+oggg%.[cd][oe]m?%W+$", --April 10
	"^%W+mmoggg%d+.*aktion%W+$", -->>> MMOGGG 25% Rabatt-Aktion <<< --July 10
	"^%W+%d+.*bargeld.*rabatt.*gold%W+$", -->>> 25% Bargeld-Rabatt auf Gold<<< --July 10
	"%W+mmo4store%.c[0o]m%W+", --June 10
	"only.*euro.*per.*gold.*weare.*bestchoice", --part of gg4g spam. When report doesn't block player fast enough due to lag.
	"friend.*website.*gold4guild", --October 09
	"friend.*website.*gg4g%.[ce]", --January 09
	"friend.*website.*wowseller%.c", --April 10
	"^%W+w*%.?gold4guild%.c[o0]m%W+$", --October 09
	"^%W+w*%.?wowseller%.c[o0]m%W+$", --April 10
	"^%W+gg4g%.[ce][ou]m?%W+$", --January 09
	"^www%.ignmax%.com$", --December 09
	"gamesky2%..*deliver", --January 10
	--fullgamegold,com-T10 equipment,honor,skill and powerleveling 1-80 Only 170 EUR 10 days.
	"fullgamegold%.com.*only%d+%.?%d*eur.*%d+", --***** fullgamegold,com ***** Only 1.8 EUR per 1000 gold.
	"mmoarm2teeth.*wanna.*gear.*season.*wowgold", --hey,this is [3w.mmoarm2teeth.com](3w=www).do you wanna get heroic ICC gear,season8 gear and wow gold?
	"^%W+goldforonly.*gbp%W+$", -->>>GOLD for only 0.0016GBP<<< --temp
	"^%W+ilvl.*weapons.*freemountsonsite%W+$", -->>>ilvl 251/264 weapons even free mounts Onsite <<< --temp
	"www.*cheap.*safe.*info.*cost", --<< www.ignaccount.com >> Cheap,Safe & Transferal level 80 accounts with all the registered information on << www.ignaccount.com >> cost only $180 --June 10
	"%[.*%].*wehave.*boeitems.*mats.*sale.*www", --wts [Battered Hilt] [Wodin's Lucky Necklace] we have all the Boe items,mats and t10/t10.5 for sale .<www.ignah.com>!! --June 10
	"skillcopper%.eu.*wow.*spectral", --skillcopper.eu Oldalunk ujabb termekekel bovult WoWTCG Loot Card-okal pl.:(Mount: Spectral Tiger, pet: Tuskarr Kite, Spectral Kitten Fun cuccok: Papa Hummel es meg sok mas) Gold, GC, CD kulcsok Akcio! Latogass el oldalunkra skillcopper.eu
}

-- GLOBALS: print, SetCVar, GetTime, strreplace, ipairs, table, UnitInParty, UnitInRaid, ComplainChat, CanComplainChat
local orig, prevReportTime, prevLineId, chatLines, chatPlayers, fnd, result = COMPLAINT_ADDED, 0, 0, {}, {}, string.find, nil
local function filter(_, event, msg, player, _, _, _, _, channelId, _, _, _, lineId)
	if lineId == prevLineId then
		return result --Incase a message is sent more than once (registered to more than 1 chatframe)
	else
		prevLineId = lineId
		if event == "CHAT_MSG_CHANNEL" and channelId == 0 then result = nil return end --Only scan official custom channels (gen/trade)
		if not CanComplainChat(lineId) then result = nil return end --Don't report ourself/friends
		if UnitInRaid(player) or UnitInParty(player) then result = nil return end --Don't try macro/filter raid/party members
	end
	local debug = msg
	msg = (msg):lower() --Lower all text, remove capitals
	msg = strreplace(msg, " ", "") --Remove spaces
	msg = strreplace(msg, ",", ".") --Convert commas to periods
	--START: 6 line text buffer, this checks the current line, and blocks it if it's the same as one of the previous 6
	for k,v in ipairs(chatLines) do
		if v == msg then --If message same as one in previous 6...
			for l,w in ipairs(chatPlayers) do
				if l == k and w == player then --...and from the same person...
					result = true return true --...filter!
				end
			end
		end
		if k == 6 then table.remove(chatLines, 1) table.remove(chatPlayers, 1) end
	end
	table.insert(chatLines, msg)
	table.insert(chatPlayers, player)
	--END: Text buffer
	local points = 0
	for k, v in ipairs(triggers) do --Scan database
		if fnd(msg, v) then --Found a match
			if k > 33 then --!!!CHANGE ME ACCORDING TO DATABASE ENTRIES!!!
				points = points + 5
			else
				points = points + 1 --We only want certain words getting 1 point
			end
			if points > 3 then
				if BADBOY_DEBUG then print("|cFF33FF99BadBoy|r: ", debug, " - ", player) end --Debug
				local time = GetTime()
				if (time - prevReportTime) > 0.5 then --Timer to prevent spamming reported messages on multi line spam
					prevReportTime = time
					COMPLAINT_ADDED = "|cFF33FF99BadBoy|r: "..orig.." |Hplayer:"..player.."|h["..player.."]|h" --Add name to reported message
					if BADBOY_POPUP then --Manual reporting via popup
						--Add original spam line to Blizzard popup message
						StaticPopupDialogs["CONFIRM_REPORT_SPAM_CHAT"].text = REPORT_SPAM_CONFIRMATION .."\n\n".. strreplace(debug, "%", "%%")
						local dialog = StaticPopup_Show("CONFIRM_REPORT_SPAM_CHAT", player)
						dialog.data = lineId
					else
						ComplainChat(lineId) --Automatically report
					end
				end
				result = true
				return true
			end
		end
	end
	--START: Art remover after blacklist check to prevent hiding and not reporting
	--Only applies for gen/trade/LFG/etc and for latin based languages, as %W only supports that... :(
	--Exclude lines with item links "|cff", I think this whole thing is reasonably ugly, but the gold spammers like to draw sometimes...
	if channelId > 0 and not BADBOY_ALLOWART and not BADBOY_NOLATIN and not fnd(msg, "|cff") and fnd(msg, "%W%W%W%W%W%W%W") then
		if BADBOY_DEBUG then print("|cFF33FF99BadBoy_ART|r: ", debug, " - ", player) end
		result = true return true
	end
	--END: Art remover
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
	elseif msg == COMPLAINT_ADDED then
		COMPLAINT_ADDED = orig --Reset reported message to default for manual reporting
		if BADBOY_POPUP then
			--Reset popup message to default for manual reporting
			StaticPopupDialogs["CONFIRM_REPORT_SPAM_CHAT"].text = REPORT_SPAM_CONFIRMATION
		end
		if BADBOY_SILENT then
			return true --Filter out the report if enabled
		end
	else
		--Ninja this in here to prevent creating a login function & frame
		--We force this on so we don't have spam that would have been filtered, reported on the forums
		SetCVar("spamFilter", 1)
	end
end)

--Temporary, until Blizzard fix the floating spam bots, we need to fix the sleep spam
ChatFrame_AddMessageEventFilter("CHAT_MSG_TEXT_EMOTE", function(_, _, msg, player)
	if not CanComplainChat(player) then return end --Don't filter ourself/friends
	if msg:find("zzz") then return true end
end)

