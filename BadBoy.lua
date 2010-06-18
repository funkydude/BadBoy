
local triggers = {
	--English - Common
	["gold"] = 1,
	["buy"] = 1,
	["stock"] = 1,
	["discount"] = 1,
	["deliver"] = 1,
	["www"] = 1,
	["price"] = 1,
	["cheap"] = 1,
	["safe"] = 1,
	["service"] = 1,
	["customer"] = 1,
	["lowest"] = 1,
	["bonus"] = 1,
	["reduced"] = 1,
	["promotion"] = 1,
	["order"] = 1,
	["welcome"] = 1,
	["server"] = 1,
	["secure"] = 1,
	["powerlevel"] = 1,
	["%d%deuro?%W"] = 1,

	--French - Common
	["livraison"] = 1, --delivery

	--German - Common
	["lieferung"] = 1, --delivery
	["willkommen"] = 1, --welcome
	["preis"] = 1, --price

	--Phishing
	["blizz.*launch.*cata.*trial.*info.*log"] = 5,
	["blizz.*launch.*card.*exp.*reg.*free"] = 5, --Hello,Blizzard will launch a three-fold experience of card (which means three times the value of experience) registration,Now you can get it 3 days for free. Address: XYZ
	["free.*mount.*wow.*first.*code.*claim"] = 5,
	["suspect.*trade.*gold.*login.*complain.*pos"] = 5, --Becasuse you suspected of lllegal trade for gold, system will freeze your ID after one hour.If you have any questions, please login  [XYZ] to make a complaint .We will be processing as soon as possible.
	["become.*lucky.*player.*mysterious.*gift.*[lr][oe]g"] = 5, --Hi.You have become the lucky player, 2 days, you can get a mysterious gift, registered address:XYZ
	["player.*network.*blizz.*compensation.*good"] = 5, --Dear players, because the network of World of Warcraft had broken off, Blizzard decided to give each player certain compensation.Please log in: XYZ and receive compensation for goods.
	["player.*blizz.*system.*scan.*acount"] = 5, --Dear World of Warcraft players,Blizzard system scan to your account insecurity,please log the safety net , or else Blizzard will stop using your account's rights in one hour .Certification of Warcraft account information site " [XYZ]"
	["free.*spec.*mount.*code.*site"] = 5, --Giving away free Spectral Tiger Mount ! Just be first to Reedem code : XU2199UXAI2881HTYAXNNB910 , go add it on site :  [XYZ] im stoping with damt wow ! GL guys
	["free.*spectr.*tiger.*claim.*first"] = 5, --Giving away Free Spectral tiger, because i'm  stopping with wow forever, to get it, just go there  [XYZ] and claim it as first, code : LJA8-5PLH61-KAHFL-152HOA-UAKL
	["become.*lucky.*player.*free.*motor.*log"] = 5, --Hi. You have become the lucky players, will receive free a motorcycle. please log in:XYZ
	["become.*blizz.*customer.*gift.*reg"] = 5, --Hi! You have become a Blizz lucky Customer, 3 days later you'll get a Mystery Gift, registered address: XYZ
	["claim.*free.*time.*warcraft.*free"] = 5, --Hi,Claim Your Free Game Time!One or more of your World of Warcraft licenses are eligible for 70 free days of game time! please log in:XYZ
	["warcraft.*account.*temp.*suspend.*inf"] = 5, --Your world of warcraft account has been temporarily suspended. go to  [XYZ] for further information.......
	["blizz.*launch.*free.*now.*log"] = 5, --#Hey! Blizzard is to launch Free unicorn zebra, Get Now please log in : [XYZ] .^#
	["system.*pumping.*lucky.*player.*info"] = 5, --Hello, you have been system Pumping To the lucky player ,For more informationplease log in: [XYZ]
	["warcraft.*blizzard.*scan.*account.*safety"] = 5, --Dear World of Warcraft players,Blizzard system scan to your account insecurity,please log the safety net , or else Blizzard will stop using your account's rights in one hour .Certification of Warcraft account information site " [XYZ]
	["celebrate.*blizzard.*warcraft.*gift.*log"] = 5, --Hello, To celebrate the Blizzard anniversary, World of Warcraft released gifts players can receive free of charge, please log in; [XYZ]
	["enter.*offer.*free.*riding.*log"] = 5, --Hi, Bizzard Enterainment offers you one time free rare riding chance. Now take it , please login:[XYZ]
	["you.*obtain.*mount.*blizzard.*info"] = 5, --Hello, you have obtained a rare mount from Blizzard, but you haven't yet receive it. For more information, please visit [XYZ]
	["congrat.*present.*blizz.*gold.*please"] = 5, --Hi! congratulations on being presented by Blizzard of 3500 gold, please log in to recieve: XYZ
	["you.*account.*temp.*disabled.*info"] = 5, --Your account will be temporarily disabled.Please visit [XYZ] for more information
	["congratu.*cata.*beta.*invitation.*activate"] = 5, --Congratulations! You've got a WOW Cataclysm Beta Invitation. Please visit XYZ to activate your account.
	["congratu.*shirt.*world.*warcraft.*prize"] = 5, --Hello. Congratulations, you get a T shirt for World of Warcraft. Want to know prizes, please visit the Forum: XYZ
	["blizz.*account.*warcraft.*catac.*beta"] = 5, --hello,Blizzard Entertainment notifies you that your account has been chosen to participate in World of Warcraft Cataclysm beta test. For more information please visit  [XYZ]
	--enUS Congratulations you will become a happy player, you will get a free trial version of the new Blizzard 310% Invincible Ghost flying mount, 24 hours, please register now: XYZ
	["spieler.*testversion.*blizz.*invincible.*ghost"] = 5, --deDE Herzlichen Gluckwunsch Sie werden gluckliche Spieler, werden Sie eine kostenlose Testversion erhalten neuesten Blizzard 310% Invincible Ghost fliegende Reittiere, 24 Stunden, bitte jetzt anmelden: XYZ
	["blizz.*launch.*mount.*trial.*info"] = 5, --Hi, Blizzard is about to launch a new mounts, Free trial, For more information, please log in: XYZ
	["you.*drawn.*system.*gift.*steed"] = 5, --Hello,you are drawn in the system to receive your gift.Please visit: [XYZ] Celestial Steed will be yours.
	["blizz.*system.*account.*violation.*trading"] = 5, --Hello! Blizzard game system scan to your game account, a violation of rules of the game's virtual currency trading! Please visit our website [XYZ] review your account information, or we will suspend your account.
	["thank.*support.*warcraft.*blizz.*steed"] = 5, --Hello. To thank you for your support for World of Warcraft. Blizzard will be giving your horse a celestial steed.Receiving please visit: XYZ
	["hallo.*system.*gift.*steed.*erhalten"] = 5, --Hallo, sind Sie in das System gezogen, um Ihren Besuch gift.Please: XYZ Celestial Steed erhalten verkaufen werden
	["spieler.*netz.*warcraft.*blizz.*kompensation"] = 5, --Liebe Spieler, weil das Netz der World of Warcraft gebrochen hatte, entschied sich Blizzard zu geben, jeder Spieler gewisse Kompensation. Bitte besuchen Sie: XYZ und erhalten einen Ausgleich fur Waren.
	["master.*konto.*deaktiviert.*besuchen.*informationen"] = 5, --Hallo! Game Master(GM) whispers: Ihr Konto wird vorubergehend [deaktiviert.Bitte] besuchen [XYZ] fur weitere Informationen
	["obtain.*mount.*blizzard.*receive.*submit"] = 5, --Hello, you have obtained a rare mount from Blizzard, but you haven't yet receive it. please log in XYZ and submit your email.
	["player.*account.*complain.*info.*right"] = 5, --Dear players, your account is complaints by other players, please visit account information site validate your information,or else will stop using your account's rights in one hour. warcraft account information site: XYZ
	--enUS Support for world of warcraft. Blizzard will give you a Celestial Steed .To receive it, please visit: [XYZ]
	["warcraft.*blizzard.*himmlischen.*steed.*receiv"] = 5, --Unterstutzung fur World of Warcraft. Blizzard wird geben Ihrem Pferd einen Besuch bitte himmlischen [steed.Receiving]: [XYZ]
	["detected.*software.*account.*info.*action"] = 5, --We have detected third-party software associated with your account. Please log in to [XYZ] with your [Battle.Net] information before action is taken against your account
	["support.*warcraft.*website.*rare.*mount"] = 5, --Hello! Thank you for your support for World of Warcraft, now visit the official website will have the rare baby, and mounts, please visit: XYZ
	["drawn.*system.*gift.*tiger"] = 5, --Hello,you are drawn in the system to receive your gift.Pleast visit:   [XYZ]  Swift Spectral Tiger will be yours.
	["customer.*blizz.*lucky.*player.*gift"] = 5, --Dear Customer, you have become a blizzard lucky Players, can get a gift,registered address: XYZ
	["drawn.*system.*receive.*cataclysm.*beta"] = 5, --CONGRATULATiONS!YOU ARE DRAWN IN THE SYSTEM TO RECEiVE YOUR ACHiEVEMENTS REWARDS! IT'S A CATACLYSM  CLOSED BETA!PLEASE  ViSIT:[XYZ--BLiZZARD]
	["hallo.*schon.*system.*erhalten.*klicken"] = 5, --Hallo!Sie sind schon von diesem System auserwahlt worden und werden Pramie erhalten. Klicken Sie bitte: [XYZ]#!
	["blizz.*notif[iy].*account.*cataclysm.*info"] = 5, --Hello,Blizzard Entertainment notifies you that your WOW account has been chosen to participate in Cataclysm beta test. For more information please visit: XYZ
	["blizz.*account.*safety.*hacker.*opportunity"] = 5, --Blizzard latest activities, cell phone locked account hundred percent safety of your account, no interference by hackers who have the opportunity to get big disaster trial eligibility, please visit:XYZ
	["blizz.*warcraft.*account.*info.*disable"] = 5, --Hello! Blizzard World of Warcraft game found in violation of your game account, please visit our website [XYZ] enter your information, pending review, or we will permanently disable your game account. 

	--Personal Whispers
	["server.*purchase.*gold.*deliv"] = 5, --sorry to bother,currently we have 29200g on this server, wondering if you might purchase some gold today? 15mins delivery:)
	[".*%d+.*lfggameteam.*"] = 5, --actually we have 10kg in stock from Lfggame team ,do you want some?
	["free.*powerleveling.*level.*%d+.*interested"] = 5, --Hello there! I am offering free powerleveling from level 70-80! Perhaps you are intrested? :)v
	["friend.*price.*%d+k.*gold"] = 5, --dear friend.. may i tell you the price for 10k wow gold ?^^
	["we.*%d+k.*stock.*realm"] = 5, --hi, we got 25k+++ in stock on this realm. r u interested?:P
	["we.*%d+k.*stock.*gold"] = 5, --Sorry to bother you , We have 26k gold in stock right now. Are you intrested in buying some gold today?
	["we.*%d+k.*gold.*buy"] = 5, --Sorry to bother. We got around 27.4k gold on this server, wondering if you might buy some quick gold with face to face trading ingame?
	["so?rr?y.*interest.*cheap.*gold"] = 5, --sorry to trouble you , just wondering whether you have  any interest in getting some cheap gold at this moment ,dear dude ? ^^
	["we.*%d+k.*stock.*interest"] = 5, --hi,we have 40k in stock today,interested ?:)
	["we.*%d%d%d+g.*stock.*price"] = 5, --hi,we have the last 23600g in stock now ,ill give you the bottom price.do u need any?:D
	["hi.*%d%d+k.*stock.*interest"] = 5, --hi ,30k++in stock any interest?:)
	["wondering.*you.*need.*buy.*g.*so?r?ry"] = 5, --I am sunny, just wondering if you might need to buy some G. If not, sry to bother.:)
	["buy.*wow.*curr?ency.*deliver"] = 5, --Would u like to buy WOW CURRENCY on our site?:)We deliver in 5min:-)
	["interest.*%d+kg.*price.*delive"] = 5, --:P any interested in the last 30kg with the bottom price.. delivery within 5 to 10 mins:)
	["sorr?y.*bother.*another.*wow.*account.*use"] = 5, --Hi,mate,sorry to bother,may i ask if u have another wow account that u dont use?:)
	["hello.*%d%d+k.*stock.*buy.*now"] = 5, --hello mate :) 40k stock now,wanna buy some now?^^
	["price.*%d%d+g.*sale.*gold"] = 5, --Excuse me. Bottom price!.  New and fresh 30000 G is for sale. Are you intrested in buying some gold today?
	["so?rr?y.*you.*tellyou.*%d+k.*wow.*gold"] = 5, --sorry to bother you,may i tell you how much for 5k wow gold
	["excuse.*do.*need.*buy.*wow.*gold"] = 5, --Excuse me,do u need to buy some wowgold?
	["bother.*%d%d%d+g.*server.*quick.*gold"] = 5, --Sry to bother you, We have 57890 gold on this server do you want to purchase some quick gold today?
	["hey.*interest.*some.*fast.*%d+kg.*left"] = 5, --hey,interested in some g fast?got 27kg left atm:)
	["know.*need.*buy.*gold.*delivery"] = 5, --hi,its kitty here. may i know if you need to buy some quick gold today. 20-50 mins delivery speed,
	["may.*know.*have.*account.*don.*use"] = 5, -- Hi ,May i know if you have an useless account that you dont use now ? :)
	["company.*le?ve?l.*char.*%d%d.*free"] = 5, --our company  can lvl your char to lvl 80 for FREE.
	["so?r?ry.*need.*cheap.*gold.*%d+"] = 5, --sorry to disurb you. do you need some cheap gold 20k just need 122eur(108GBP)
	["stock.*gold.*wonder.*buy.*so?rr?y"] = 5, --Full stock gold! Wondering you might wanna buy some today ? sorry for bothering you.
	["hi.*you.*need.*gold.*we.*promotion"] = 5, --[hi.do] you need some gold atm?we now have a promotion for it ^^

	--Advanced URL's
	["^%W+neueaktion.*mmoggg.*%W+$"] = 5, -->>>Neue Aktion bei [MMOGGG.DE] <<< --June 10
	["^%W+.*buyeugold%..*only.*euro"] = 5, -->> WWW .Buyeugold.COM << Only 16 Euro for10 K+500G --June 10
	["well?come.*website.*wowgamegold%..*best"] = 5, --Wellcome to our website>>> www.wowgamegold,net<<<We are your best choice. --June 10
	["^%W+mm[0o]%[?yy%.c[0o]m%W+$"] = 5, --May 10
	["^%W+diymm[0o]game.c[0o]m%W+$"] = 5, --June 10
	["choice.*mmo4store%.c.*only"] = 5, --Good Choice ===> MMO4STORE.C0M ==> only (=19.9 per 10k --June 10
	["choice.*buyeugold%.c.*only"] = 5, --Good Choice==> BUYEUGOLD.COM==>Only E17 per 10K --June 10
	["^%W+m+oggg%.de%W+$"] = 5, --April 10
	["^%W+lastminuteangebotevonmmoggg%W+$"] = 5, --temp
	["^%W+wirschenkeneuch%d+%%mehrgold%W+$"] = 5, --temp
	["^%W+.*nehme.*zeit.*genie.*aktion.*mmoggg.*%W+$"] = 5, --temp
	["^%W+50%%kostenlosesgold.*preise.*optionen%W+$"] = 5, --temp
	["%W+mmo4store%.com%W+"] = 5, --June 10
	["friend.*website.*gold4guild"] = 5, --October 09
	["friend.*website.*gg4g%.[ce]"] = 5, --January 09
	["friend.*website.*wowseller%.c"] = 5, --April 10
	["^%W+w*%.?gold4guild%.c[o0]m%W+$"] = 5, --October 09
	["^%W+w*%.?wowseller%.c[o0]m%W+$"] = 5, --April 10
	["^%W+gg4g%.[ce][ou]m?%W+$"] = 5, --January 09
	["^www%.ignmax%.com$"] = 5, --December 09
	["gamesky2%..*deliver"] = 5, --January 10
	["%d%d+.*%Ww+%.k4gold%.com%W"] = 5, --need Free[Plans: Titanium Razorplate][crusader orb] etcwe have alot kinds of recips and mats as a reward if u need g.15000+free mats=$112 with discount code"stock",welcome to<www.k4gold.com> dot come for more details.
	["%W?w+%.k4gold%.com%W.*%d%d+"] = 5, --Special Sales for Patch3.3: <www.K4GOLD.com> offers free ore and recipes for orders bigger than 10k, other ore and recipes are also available for your special need. Catch the Chance!
	["skillcopper%.eu.*wow.*spectral"] = 5, --skillcopper.eu Oldalunk ujabb termekekel bovult WoWTCG Loot Card-okal pl.:(Mount: Spectral Tiger, pet: Tuskarr Kite, Spectral Kitten Fun cuccok: Papa Hummel es meg sok mas) Gold, GC, CD kulcsok Akcio! Latogass el oldalunkra skillcopper.eu
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
	for k, v in pairs(triggers) do --Scan database
		if fnd(msg, k) then --Found a match
			points = points + v
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

