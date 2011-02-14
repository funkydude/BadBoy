--[[	BLIZZARD IF YOU'RE READING THIS I'M BEGGING FOR YOUR HELP.
		Please let me fetch either player level from the given guid (will also help BadBoy_Levels)
		or let me fetch if the player is in a guild or not from the given guid (spammers never guilded)
		or both!

		I can then, 1) Skip scanning all chat from non-guilded WoW players, 2) skip scanning all chat from
		players above level 10, this would near enough eliminate any chance of false positives.
]]--

--DO NOT MODIFY DATABASE OR YOU MAY REPORT INNOCENT PEOPLE, HEURISTIC FUNCTION DEPENDS ON WORDS BEING ON CERTAIN LINES
local myDebug = nil
local triggers = {
	--White
	"recruit", --1
	"dkp", --2
	"looking", --3 --guild
	"lf[gm]", --4
	"|cff", --5

	--English - Common
	"bonus", --6
	"buy", --7
	"cheap", --8
	"code", --9
	"coupon", --10
	"customer", --11
	"deliver", --12
	"discount", --13
	"express", --14
	"gold", --15
	"lowest", --16
	"order", --17
	"powerle?ve?l", --18
	"price", --19
	"promoti[on][gn]", --20
	"reduced", --21
	"rocket", --22
	"sa[fl]e", --23
	"server", --24
	"service", --25
	"stock", --26
	"well?come", --27

	--French - Common
	"livraison", --delivery --28

	--German - Common
	"billigster", --cheapest --29
	"lieferung", --delivery --30
	"preis", --price --31
	"willkommen", --welcome --32

	--Spanish - Common
	"barato", --cheap --33
	"gratuito", --free --34
	"r[\195\161a]pido", --fast --35
	"seguro", --safe/secure --36
	"servicio", --service --37

	--Heavy
	"only[\226\130\172%$\194\163]+%d+[%.%-]?%d*[fp][oe]r%d+%.?%d*[kg]", --38 --Add separate line if they start approx prices
	"[\226\130\172%$\194\163]+%d+%.?%d+[/\98=]%d+%.?%d*[kg]", --39
	"%d+%.?%d*eur?o?s?[fp][oe]r%d+%.?%d*[kg]", --40
	"%d+%.?%d*[\226\130\172%$\194\163]+[/\98=%-]%d+%.?%d*[kg]", --41
	"only[\226\130\172%$\194\163]+%d+[%.%-]?%d*{%S-}%d+%.?%d*[kg]", --42 --Add separate line if they start approx prices
	"%d+%.?%d*[kg][/\98=][\226\130\172%$\194\163]+%d+", --43
	"%d+%.?%d*[kg][/\98=]%d+%.?%d*[\226\130\172%$\194\163]+", --44
	"%d+%.?%d*[kg][/\98=]%d+[%.,]?%d*eu", --45
	"%d+%.?%d*eur?o?s?[/\98=]%d+%.?%d*[kg]", --46
	"%d+%.?%d*usd[/\98=]%d+%.?%d*[kg]", --47
	"%d+%.?%d*usd[fp][oe]r%d+%.?%d*[kg]", --48

	--Heavy Strict
	"www[%.,{]", --49
	"[%.,]c[o0@]m", --50
	"[%.,]c{circle}m", --51
	"[%.,]c{rt2}m", --52
	"[%.,]cqm", --53
	"[%.,]net", --54

	--Icons
	"{rt%d}", --55
	"{star}", --56
	"{circle}", --57
	"{diamond}", --58
	"{triangle}", --59
	"{moon}", --60
	"{square}", --61
	"{cross}", --62

	--Phishing - English
	"account", --63
	"blizz", --64
	"claim", --65
	"congratulations", --66
	"free", --67
	"gamemaster", --68
	"gift", --69
	"launch", --70
	"log[io]n", --71
	"luckyplayer", --72
	"mount", --73
	"pleasevisit", --74
	"receive", --75
	"surprise", --76
	"suspe[cn][td]ed", --77 --suspected/suspended
	"system", --78
	"validate", --79

	--hello![Game Master]GM: Your world of warcraft account has been temporarily suspended. go to  [http://www.*********.com/wow.html] for further informatio

	--Phishing - German
	"berechtigt", --entitled --80
	"erhalten", --get/receive --81
	"deaktiviert", --deactivated --82
	"konto", --acount --83
	"kostenlos", --free --84
	"qualifiziert", --qualified --85

	--Personal Whispers
	"so?rr?y.*%d+[kg].*stock.*buy", --sry to bother, we have 60k g in stock today. do u wanna buy some?:)
	"server.*purchase.*gold.*deliv", --sorry to bother,currently we have 29200g on this server, wondering if you might purchase some gold today? 15mins delivery:)
	"%d+.*lfggameteam", --actually we have 10kg in stock from Lfggame team ,do you want some?
	"free.*powerleveling.*level.*%d+.*interested", --Hello there! I am offering free powerleveling from level 70-80! Perhaps you are intrested? :)v
	"friend.*price.*%d+k.*gold", --dear friend.. may i tell you the price for 10k wow gold ?^^
	"we.*%d+k.*stock.*realm", --hi, we got 25k+++ in stock on this realm. r u interested?:P
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
	"%d+%-%d+.*d[ou][ub]ble.*%d+%-%d+.*trip", --10 minimum 400 max\roll\61-97 double, 98-100 triple, come roll,
	"casino.*%d+x2.*%d+x3", --{star} CASINO {star} roll 64-99x2 your wager roll 100x3 your wager min bet 50g max 10k will show gold 100% legit (no inbetween rolls plz){diamond} good luck {diamond}
	"casino.*%d+.*double.*%d+.*tripp?le", --The Golden Casino is offering 60+ Doubles, and 80+ Tripples!
	"casino.*whisper.*info", --<RollReno's Casino> <Whisper for more information!>
	"d[ou][ub]ble.*%d+%-%d+.*%d+%-%d+.*tripp?le", --come too the Free Roller  gaming house!  and have ur luck of winning gold! :) pst me for invite:)  double is  62-96 97-100 tripple we also play blackjack---- u win double if you beat the host in blackjack
	"d[ou][ub]ble.*%d+%-%d+.*tripp?le.*%d+%-%d+", --come to free roller gaming house! and have u luck of winning gold :) pst for invite :) double is 62-96 triple is 97-100. we also play blacjack---u win doubleif u beat host in blacjack
	"casino.*bet.*%d+%-%d+", --Casino time. You give me your bet, Than You roll from 1-11 unlimited times.Your rolls add up. If you go over 21 you lose.You can stop before 21.When you stop I do the same, and if your closer to 21 than me than you get back 2 times your bet
	"roll.*%d+.*roll.*%d+.*bet", --Roll 63+ x2 , Roll 100 x3, Roll 1 x4 NO MAX BETS

	--Advanced URL's/Misc
	--Золотко от 49 \ Все типы оплаты \ Онлайн чат / Быстрая доставка \ Webmoney | Visa | Mc | Qiwi | Yandex | BL 400 | ICQ 5595777 | Mywowgold .ru
	"visa.*icq.*mywowgold", --Gold from 49 \ Any kind of payments \ Online chat / Fast delivery \ Webmoney | Visa | Mc | Qiwi | Yandex | BL 400 | ICQ 5595777 | Mywowgold .ru
	--Продам по 50р. 50р-1к. Оперативная доставка, большие запасы, низкие цены. Сайт: [RPGdealer.ru] Чат на сайте, ICQ: 48 555 2474, Skype: [RPGdealer.ru] [220 BL WM] Аттестат продавца. Все виды оплат. Ищу поставщиков
	"%d+.*rpgdealer.*icq", --I'm sell by 50r. 50r-1k. Prompt (quick) delivery, big resourses, low prices. Site: [RPGdealer.ru] Chat on site, ICQ: 48 555 2474, Skype: [RPGdealer.ru] [220 BL WM] Attestat of Seller's. Any kind of payments. Looking for supplier's
	--Продам монеты 44-49вмр, яд, QIWI, visa - 1000 любые суммы! Прокачка/продажа чаров! Ищу поставщиков! Персональный аттестат, сайт! Ася 222-041! Скайп firelordwow!
	"монеты.*%d+.*qiwi.*visa", --Sell coins 44-49wmr, yam (yandex money), QIWI, visa - 1000 any sums! Level up / Sale characters! Looking for supplier's! Personal attestat, site! ICQ 222-041! Skype firelordwow!
	--KingPeon.СОМ [от 40р - 1k] Ася:238021. Скайп: Scorpufas. Аттестат Продавца[BL 110] WM/Яд, Qiwi, Visa, Билайн/МТС и др. Моментальная передача. Онлайн-Чат на сайте.
	"kingpeon[%.,]c.*Ася.*visa", --KingPeon.СОМ [from 40r - 1k] Icq:238021. Skype: Scorpufas. Attestat of Seller's[BL 110] WM/Yam, Qiwi, Visa, Beeline/MTS (both big Russian celluar country corporatrion) and etc. Instant transmission / transfer. Online-chat on site.
	--Продам [БОГАТСТВО]  50р  СКИДКИ. WM/яд/MC/Visa/QIWI IСQ 44-27-99 ,Skype [wow-g-Online] [BL 180] Надежно, просто, честно! Отвечаю в Асю, скайп! Ищу поставщиков.
	"%d+.*visa.*i[Сc]q.*wow%-g%-online", --I'm will sell [RICHNESS]  50r  SALES. WM/yam/MS/Visa/QIWI IСQ 44-27-99 , Skype [wow-g-Online] [BL 180] Надежно, simply, honestly! Replay in Icq, skype! Looking for suppliers.
	--Продам ГОЛД по 40 !!! Принимаю веб мани и яндекс деньги.
	"Продам.*ГОЛД.*яндекс.*деньги", --I'm will sell GOLD by 40 !!! I'm accept web money and yandex money.
	--Продам Г по 35! Сделка с мейна. БЛ 67!!! Ася 747661 Скайп y0b0b0
	--Продам Г по 35! Сделка с мейна.Гарантии!  БЛ 67!!! Ася 747661 Скайп y0b0b0 или  в ПМ!
	"Продам.*Сделка.*Ася", --I'm will sell G by 35! Deal from main's (character). BL 67!!! Icq 747661 Skype y0b0b0
	--Продаём голд 49р-55р за 1к. WoWMoney.гu. Visa/MC, WM, Я-Д, QIWI. BL 200+. Связь через iсq 38-48-29 или сайт.
	"wowmoney[%.,].*visa.*iсq", --We are sell gold 49r-55r for 1k. WoWMoney.гu. Visa/MS, WM, YA-M, QIWI. BL 200+. Connection through iсq 38-48-29 or site.
	--Nigmаz.соm - Зoлoтo всего по 53p за 1000. Получи до 11% в подарок! скидки постоянным клиентам. Быстро и удобно!
	"nigmаz[%.,]с.*%d+.*скидки", --Nigmаz.соm - Gold only by 53r for 1000. Receive to 11% to gift! Sales for permanent customer's. Quickly and comfortable!
	--Продам ЗОЛОТО недорого!!! От 35р за 1000!!! Оплата  Webmoney,ICQ 603388454.
	"ЗОЛОТО.*money.*i[Сc]q", --Selling GOLD inexpensively!!! From 35r by 1000!!! Payment  Webmoney,ICQ 603388454.
	--продам голд 1к-40вмр
	"продам.*голд.*%d+", --i'll sell gold 1k-40wmr
	--mm0money предлагает оплату на 1-10к 3-20к, 6-30000г  месяцев, за игровую валюту !!! Колличество оплат ограниченно !!! Успей урвать долю счастья !!!
	"mm0money.*%d+.*валюту", --mm0money offers payment for 1-10k 3-20k, 6-30000g months, for gaming currency !!! Number of payment's is limited!!! Things to snatch a share of happiness!!!
	--онлайн магазин "Trader" - продажа золота, ключей Classic, BC, WoTLC,Cataclysm,тайм карт(руб/голд). Скупаем золото - дорого! BL146
	"продажа.*золота.*[Ссc]купаем.*золото", --online shop "Trader" - sale of gold, keys Classic, BC, WoTLC,Cataclysm,time cards(rub/gold). We buy gold - it's expensive! BL146
	"happy.*%d+for%d+k.*gear.*mount", --{star}{star}{star}happy new year, $100=30K,$260 for 100K, and have the nice 359lvl gears about $39~99 best mount for ya as well{star}{star}{star}{star}
	"deliver.*gears.*g4p", --Fast delivery for Level 359/372 BoE gears!Vist <www.g4pitem.com> to get whatever you need! 
	"sale.*joygold.*store", --Great sale! triangletriangletriangle www.joygold.com.www.joygold.com diamonddiamonddiamond 10000G.only.13.99 EUR circle WWWE have 257k stores and you can receive within 5-10 minutes star 
	"pkpkg.*boe.*deliver", --[PKPKG.COM] sells all kinds of 346,359lvl BOE gears. fast delivery. your confidence is all garanteed
	"service.*pst.*info.*%d+k.*usd", --24 hrs on line servicer PST for more infor. Thanks ^_^  10k =32 u s d  -happy friday :)
	"deathwing.*fear.*terror.*official.*cata.*surprise.*ZYY", --Deathwing has come spreading fear and terror, it is now officially World of WarCraft Cataclysm. Make sure you are prepared and find surprises at ZYY. 
	"okgolds.*only.*%d+.*euro", --WWW.okgolds.COM,10000G+2000G.only.15.99EURO}/2
	"mmo4store.*%d+[kg].*good.*choice", --{square}MMO4STORE.C0M{square}14/10000G{square}Good Choice{square}
	"^%W+.*mmoggg", -->>> MMOGGG is recruiting now!
	"%d+.*items.*deliver.*k4gg", --10K=13.98For more items and for fast delivery,come toWWW.K4gg.C@M
	"customer.*promotion.*cost.*gold", --Dear customer: This is kyla from promotion site : mmowin ^_^Long time no see , how is going? Been miss ya :)As the cataclysm coming and the market cost line for gold and boe item has been down a lot recently , we will send present if ya get 30k or 50k
	--40$ for 10k gold or 45$ for  10k gold + 1 rocket  + one month  time card  .   25$ for  a  rocket .  we have  all boe items and 264 gears selled . if u r interested in .  plz whsiper me . :) ty
	--$45=10k + one X-53 Touring Rocket, $107=30K + X-53 Touring Rocket, the promotion will be done in 10 minutes, if you like it, plz whisper me :) ty 
	"%$.*rocket.*%$.*rocket.*ple?a?[sz]", --$45 for 10k with a rocket {star} and 110$ for 30k with a Rocket{moon},if you like,plz pst
	--WTS X-53 Touring Rocket.( the only 2 seat flying mount you can aslo get a free month game time) .. pst
	--WTS [X-53 Touring Rocket], the only 2seats flying mount, PST
	"wts.*touring.*rocket.*mount.*pst", --!!!!!! WTS*X-53 TOURING ROCKET Mount(2seats)for 10000G (RAF things), you also can get a free month game time,PST me !!!
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
	"wts.*boeitems.*sale.*ignah", --wts [Lightning-Infused Leggings] [Carapace of Forgotten Kings] we have all the Boe items,mats and t10/t10.5 for sale .<www.ignah.com>!!
	"mmoarm2teeth.*wanna.*gear.*season.*wowgold", --hey,this is [3w.mmoarm2teeth.com](3w=www).do you wanna get heroic ICC gear,season8 gear and wow gold?
	"skillcopper.*wow.*mount.*gold", --skillcopper.eu Oldalunk ujabb termekekel bovult WoWTCG Loot Card-okal pl.:(Mount: Spectral Tiger, pet: Tuskarr Kite, Spectral Kitten Fun cuccok: Papa Hummel es meg sok mas) Gold, GC, CD kulcsok Akcio! Latogass el oldalunkra skillcopper.eu
}

-- GLOBALS: print, SetCVar, GetTime, strreplace, ipairs, UnitInParty, UnitInRaid, UnitIsInMyGuild, ComplainChat, CanComplainChat, BNGetNumFriends, BNGetNumFriendToons, BNGetFriendToonInfo, GetRealmName
local orig, prevReportTime, prevLineId, fnd, result, prevMsg, prevPlayer = COMPLAINT_ADDED, 0, 0, string.find, nil, nil, nil
local function filter(_, event, msg, player, _, _, _, flag, channelId, _, _, _, lineId)
	if lineId == prevLineId then
		return result --Incase a message is sent more than once (registered to more than 1 chatframe)
	else
		prevLineId = lineId
		if event == "CHAT_MSG_CHANNEL" and channelId == 0 then result = nil return end --Only scan official custom channels (gen/trade)
		if not CanComplainChat(lineId) or UnitIsInMyGuild(player) or UnitInRaid(player) or UnitInParty(player) then result = nil return end --Don't scan ourself/friends/GMs/guildies or raid/party members
		if event == "CHAT_MSG_WHISPER" then --These scan prevention checks only apply to whispers, it would be too heavy to apply to all chat
			if flag == "GM" then result = nil return end --GM's can't get past the CanComplainChat call but "apparently" someone had a GM reported by the phishing filter which I don't believe, no harm in having this check I guess
			--RealID support, don't scan people that whisper us via their character instead of RealID
			--that aren't on our friends list, but are on our RealID list. CanComplainChat should really support this...
			for i=1, select(2, BNGetNumFriends()) do
				local toon = BNGetNumFriendToons(i)
				for j=1, toon do
					local _, rName, rGame = BNGetFriendToonInfo(i, j)
					--don't bother checking server anymore as bnet has been bugging up a log lately
					--returning "" as server/location (probably other things too) making the check useless
					if rName == player and rGame == "WoW" then
						result = nil return
					end
				end
			end
		end
	end
	local debug = msg --Save original message format
	msg = (msg):lower() --Lower all text, remove capitals
	msg = strreplace(msg, " ", "") --Remove spaces
	--Simple 'previous-line' anti-spam, check the previous line, filter if duplicate
	if msg == prevMsg and player == prevPlayer then result = true return true end
	prevMsg = msg prevPlayer = player
	--end check
	local points, phishPoints, strict, iconBlock = 0, 0, nil, nil
	for k, v in ipairs(triggers) do --Scan database
		if fnd(msg, v) then --Found a match
			if k>85 then --!!!CHANGE ME ACCORDING TO DATABASE ENTRIES!!!
				points = points + 9 --Instant report
			elseif k>62 and k<86 then
				phishPoints = phishPoints + 1
			elseif k>54 and k<63 and not iconBlock then
				points = points + 1 --Only 1 trigger can get points in the icons section
				iconBlock = true
			elseif k>48 and k<55 and not strict then
				points = points + 2 --Only 1 trigger can get points in the strict section
				phishPoints = phishPoints + 1
				strict = true
			elseif k>37 and k<49 then
				points = points + 2 --Heavy section gets 2 points
			elseif k>5 and k<38 then
				points = points + 1 --All else gets 1 point
			elseif k<6 then
				points = points - 2
				phishPoints = phishPoints - 2 --Remove points for safe words
			end
			if myDebug then
				print(v, points, phishPoints)
			end
			if points > 3 or phishPoints > 3 then
				if BadBoyLogger and not myDebug then BadBoyLogger("BadBoy", event, player, debug) end
				local time = GetTime()
				if (time - prevReportTime) > 0.5 then --Timer to prevent spamming reported messages on multi line spam
					prevReportTime = time
					COMPLAINT_ADDED = "|cFF33FF99BadBoy|r: "..orig.." |Hplayer:"..player.."|h["..player.."]|h" --Add name to reported message
					if myDebug then
						print("|cFF33FF99BadBoy_REPORT|r: ", debug, "-", event, "-", player)
					else
						if BADBOY_POPUP then --Manual reporting via popup
							--Add original spam line to Blizzard popup message
							StaticPopupDialogs["CONFIRM_REPORT_SPAM_CHAT"].text = REPORT_SPAM_CONFIRMATION .."\n\n".. strreplace(debug, "%", "%%")
							local dialog = StaticPopup_Show("CONFIRM_REPORT_SPAM_CHAT", player)
							dialog.data = lineId
						else
							ComplainChat(lineId) --Automatically report
						end
					end
				end
				result = true
				return true
			end
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

