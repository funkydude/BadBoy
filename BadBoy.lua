--[[	BLIZZARD IF YOU'RE READING THIS I'M BEGGING FOR YOUR HELP.
		PLEASE LET ME FETCH EITHER PLAYER LEVEL FROM THE GIVEN GUID (WILL ALSO HELP BADBOY_LEVELS)
		OR LET ME FETCH IF THE PLAYER IS IN A GUILD OR NOT FROM THE GIVEN GUID (SPAMMERS NEVER GUILDED)
		OR BOTH! IT WOULD MAKE THIS MUCH EASIER!
]]--

--DO NOT MODIFY DATABASE OR YOU MAY REPORT INNOCENT PEOPLE, HEURISTIC FUNCTION DEPENDS ON WORDS BEING ON CERTAIN LINES
local triggers = {
	--White
	"recruit", --1
	"dkp", --2
	"guild", --3 --looking?

	--English - Common
	"bonus", --4
	"buy", --5
	"cheap", --6
	"code", --7
	"coupon", --8
	"customer", --9
	"deliver", --10
	"discount", --11
	"gold", --12
	"lowest", --13
	"order", --14
	"payment", --15
	"powerle?ve?l", --16
	"price", --17
	"promoti[on][gn]", --18
	"reduced", --19
	"safe", --20
	"server", --21
	"service", --22
	"stock", --23
	"well?come", --24

	--French - Common
	"livraison", --delivery --25

	--German - Common
	"billigster", --cheapest --26
	"lieferung", --delivery --27
	"preis", --price --28
	"willkommen", --welcome --29

	--Spanish - Common
	"barato", --cheap --30
	"gratuito", --free --31
	"r[\195\161a]pido", --fast --32
	"seguro", --safe/secure --33
	"servicio", --service --34

	--Heavy
	"only[\226\130\172%$\194\163]+%d+[%.%-]?%d*[fp][oe]r%d+%.?%d*[kg]", --35 --Add separate line if they start approx prices
	"[\226\130\172%$\194\163]+%d+%.?%d+[/\98=]%d+%.?%d*[kg]", --36
	"only%d+%.?%d*eur?o?s?[fp][oe]r%d+%.?%d*[kg]", --37
	"%d+%.?%d*[\226\130\172%$\194\163]+[/\98=]%d+%.?%d*[kg]", --38
	"only[\226\130\172%$\194\163]+%d+[%.%-]?%d*{%S-}%d+%.?%d*[kg]", --39 --Add separate line if they start approx prices
	"%d+%.?%d*[kg][/\98=][\226\130\172%$\194\163]+%d+", --40
	"%d+%.?%d*[kg][/\98=]%d+%.?%d*[\226\130\172%$\194\163]+", --41
	"%d+%.?%d*[kg][/\98=]%d+%.?%d*eur", --42

	--Heavy Strict
	"www[%.,]", --43
	"[%.,]c[o0@]m", --44
	"[%.,]c{circle}m", --45
	"[%.,]c{rt2}m", --46
	"[%.,]cqm", --47
	"[%.,]net", --48

	--Phishing - English
	"account", --49
	"blizz", --50
	"claim", --51
	"congratulations", --52
	"free", --53
	"gift", --54
	"launch", --55
	"log[io]n", --56
	"luckyplayer", --57
	"mount", --58
	"pleasevisit", --59
	"receive", --60
	"surprise", --61
	"suspe[cn][td]ed", --62 --suspected/suspended
	"system", --63
	"warcraft", --64

	--Phishing - German
	"berechtigt", --entitled --65
	"erhalten", --get/receive --66
	"deaktiviert", --deactivated --67
	"konto", --acount --68
	"kostenlos", --free --69
	"qualifiziert", --qualified --70

	--X is recruiting, Y and Z tanks, A, B, C. Other classes also welcome. Raid times are 8-11 server. DayX dayY are 25's and other days are 10's. Pst an officer for more info or visit XYZ.com

	--Personal Whispers
	"server.*purchase.*gold.*deliv", --sorry to bother,currently we have 29200g on this server, wondering if you might purchase some gold today? 15mins delivery:)
	"%d+.*lfggameteam", --actually we have 10kg in stock from Lfggame team ,do you want some?
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
	"%d+%-%d+.*d[ou][ub]ble.*%d+%-%d+.*tripp?le", --10 minimum 400 max\roll\61-97 double, 98-100 triple, come roll,
	"casino.*%d+x2.*%d+x3", --{star} CASINO {star} roll 64-99x2 your wager roll 100x3 your wager min bet 50g max 10k will show gold 100% legit (no inbetween rolls plz){diamond} good luck {diamond}
	"casino.*%d+.*double.*%d+.*tripp?le", --The Golden Casino is offering 60+ Doubles, and 80+ Tripples!
	"casino.*whisper.*info", --<RollReno's Casino> <Whisper for more information!>
	"d[ou][ub]ble.*%d+%-%d+.*%d+%-%d+.*tripp?le", --come too the Free Roller  gaming house!  and have ur luck of winning gold! :) pst me for invite:)  double is  62-96 97-100 tripple we also play blackjack---- u win double if you beat the host in blackjack
	"d[ou][ub]ble.*%d+%-%d+.*tripp?le.*%d+%-%d+", --come to free roller gaming house! and have u luck of winning gold :) pst for invite :) double is 62-96 triple is 97-100. we also play blacjack---u win doubleif u beat host in blacjack

	--Advanced URL's/Misc --[[Re-evaluate after v4]]--
	"{.*}.*mm4ss.*{.*}", --{triangle}www.mm4ss.com{triangle} --multi
	"promotion.*serve.*%d+k", --Special promotion in this serve now, 21$ for 10k
	"pkpkg.*gear.*pet", --WWW.PkPkg.C{circle}M more gears,mount,pet and items on
	"euro.*gold.*safer.*trade", --Only 1.66 Euros per 1000 gold, More safer trade model.
	--WWW.PVPBank.C{circle}MCODE=itempvp(20% price off)
	"www[%.,]pvpbank[%.,]c.*%d+", --Wir haben mehr Ausr?stungen, Mounts und Items, die Sie mochten. Professionelles Team fuer 300 Personen sind 24 Stunde fuer Sie da.Wenn Sie Fragen haben,wenden Sie an uns bitteWWW.PVPBank.C{circle}M7 Tage 24 Uhr Service.
	"^%W+mm[0o]%[?yy[%.,]c[0o]m%W+$", --May 10
	"^%W+diymm[0o]game[%.,]c[0o]m%W+$", --June 10
	"sell.*safe.*fast.*site.*gold2wow", --()()Hot selling:safest and fastest trade,reliable site gold2wow()() --June 10
	"^%W+m+oggg[%.,][cd][oe]m?%W+$", --April 10
	"%W+mmo4store[%.,]c[0o]m%W+", --June 10
	"friend.*website.*gold4guild", --October 09
	"friend.*website.*gg4g", --January 09
	"friend.*website.*wowseller", --April 10
	"^%W+w*[%.,]?gold4guild[%.,]c[o0]m%W+$", --October 09
	"^%W+w*[%.,]?wowseller[%.,]c[o0]m%W+$", --April 10
	"^%W+gg4g[%.,][ce][ou]m?%W+$", --January 09
	"^www[%.,]ignmax[%.,]com$", --December 09
	"wts.*boeitems.*sale.*ignah", --wts [Lightning-Infused Leggings] [Carapace of Forgotten Kings] we have all the Boe items,mats and t10/t10.5 for sale .<www.ignah.com>!!
	"mmoarm2teeth.*wanna.*gear.*season.*wowgold", --hey,this is [3w.mmoarm2teeth.com](3w=www).do you wanna get heroic ICC gear,season8 gear and wow gold?
	"skillcopper.*wow.*mount.*gold", --skillcopper.eu Oldalunk ujabb termekekel bovult WoWTCG Loot Card-okal pl.:(Mount: Spectral Tiger, pet: Tuskarr Kite, Spectral Kitten Fun cuccok: Papa Hummel es meg sok mas) Gold, GC, CD kulcsok Akcio! Latogass el oldalunkra skillcopper.eu
}

-- GLOBALS: print, SetCVar, GetTime, strreplace, ipairs, tinsert, tremove, UnitInParty, UnitInRaid, ComplainChat, CanComplainChat
local orig, prevReportTime, prevLineId, fnd, result = COMPLAINT_ADDED, 0, 0, string.find, nil
local function filter(_, event, msg, player, _, _, _, flag, channelId, _, _, _, lineId)
	if lineId == prevLineId then
		return result --Incase a message is sent more than once (registered to more than 1 chatframe)
	else
		prevLineId = lineId
		if flag == "GM" then result = nil return end --I'm sure GM's didn't used to be reportable.... adding this here just in case it's changed, due to a user false positive report with a GM.
		if event == "CHAT_MSG_CHANNEL" and channelId == 0 then result = nil return end --Only scan official custom channels (gen/trade)
		if not CanComplainChat(lineId) then result = nil return end --Don't report ourself/friends
		if UnitInRaid(player) or UnitInParty(player) then result = nil return end --Don't try macro/filter raid/party members
	end
	local debug = msg --Save original message format
	msg = (msg):lower() --Lower all text, remove capitals
	msg = strreplace(msg, " ", "") --Remove spaces
	--START: 12 line text buffer, this checks the current line, and blocks it if it's the same as one of the previous 12
	--for i=1, #chatLines do
	--	if chatLines[i] == msg and chatPlayers[i] == player then --If message same as one in previous 12 and from the same person...
	--		result = true return true --...filter!
	--	end
	--	if i == 12 then tremove(chatLines, 1) tremove(chatPlayers, 1) end
	--end
	--tinsert(chatLines, msg) tinsert(chatPlayers, player)
	--END: Text buffer
	local points = 0
	local phishPoints = 0
	local strict = nil
	for k, v in ipairs(triggers) do --Scan database
		if fnd(msg, v) then --Found a match
			if k>70 then --!!!CHANGE ME ACCORDING TO DATABASE ENTRIES!!!
				points = points + 5 --Instant report
			elseif k>48 and k<71 then
				phishPoints = phishPoints + 1
			elseif k>42 and k<49 and not strict then
				points = points + 2 --Only 1 trigger can get points in the strict section
				phishPoints = phishPoints + 2
				strict = true
			elseif k>34 and k<43 then
				points = points + 2 --Heavy section gets 2 points
			elseif k>3 and k<35 then
				points = points + 1 --All else gets 1 point
			elseif k<4 then
				points = points - 2
				phishPoints = phishPoints - 2 --Remove points for safe words
			end
			if points > 3 or phishPoints > 3 then
				if BADBOY_DEBUG then print("|cFF33FF99BadBoy_REPORT|r:", debug) end --Debug
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
	--if channelId > 0 and not BADBOY_ALLOWART and not BADBOY_NOLATIN and not fnd(msg, "|cff") and fnd(msg, "%W%W%W%W%W%W%W") then
	--	if BADBOY_DEBUG then print("|cFF33FF99BadBoy_ART|r:", debug, player) end
	--	result = true return true
	--end
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
		BADBOY_ALLOWART = nil --XX remove
	end
end)

--Temporary, until Blizzard fix the floating spam bots, we need to fix the sleep spam
ChatFrame_AddMessageEventFilter("CHAT_MSG_TEXT_EMOTE", function(_, _, msg, player)
	--fixed in v4?
	if IsResting() and msg:find("zzz") then return true end
end)

