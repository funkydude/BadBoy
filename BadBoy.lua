
-- GLOBALS: print, tinsert, tremove, strsplit, SetCVar, GetTime, pairs, tonumber, UnitInParty, UnitInRaid, UnitIsInMyGuild, ReportPlayer, ComplainChat, CanComplainChat, BNGetNumFriends, BNGetNumFriendToons, BNGetFriendToonInfo, ChatFrame_OnHyperlinkShow
local myDebug = nil

local reportMsg = "BadBoy: >>> |cfffe2ec8|Hbadboy:%d:%s|h[Spam blocked, click to report!]|h|r <<<"
do
	local L = GetLocale()
	if L == "frFR" then
		reportMsg = "BadBoy: >>> |cfffe2ec8|Hbadboy:%d:%s|h[Spam bloqué, cliquez pour signaler !]|h|r <<<"
	elseif L == "deDE" then
		reportMsg = "BadBoy: >>> |cfffe2ec8|Hbadboy:%d:%s|h[Spam geblockt, zum melden klicken!]|h|r <<<"
	elseif L == "zhTW" then
		reportMsg = "BadBoy: >>> |cfffe2ec8|Hbadboy:%d:%s|h[發出的垃圾訊息已被阻擋, 點擊以舉報 !]|h|r <<<"
	elseif L == "zhCN" then
		reportMsg = "BadBoy: >>> |cfffe2ec8|Hbadboy:%d:%s|h[Spam blocked, click to report!]|h|r <<<"
	elseif L == "esES" then
		reportMsg = "BadBoy: >>> |cfffe2ec8|Hbadboy:%d:%s|h[Spam blocked, click to report!]|h|r <<<"
	elseif L == "esMX" then
		reportMsg = "BadBoy: >>> |cfffe2ec8|Hbadboy:%d:%s|h[Spam blocked, click to report!]|h|r <<<"
	elseif L == "ruRU" then
		reportMsg = "BadBoy: >>> |cfffe2ec8|Hbadboy:%d:%s|h[Spam blocked, click to report!]|h|r <<<"
	elseif L == "koKR" then
		reportMsg = "BadBoy: >>> |cfffe2ec8|Hbadboy:%d:%s|h[Spam blocked, click to report!]|h|r <<<"
	elseif L == "ptBR" then
		reportMsg = "BadBoy: >>> |cfffe2ec8|Hbadboy:%d:%s|h[Spam blocked, click to report!]|h|r <<<"
	elseif L == "itIT" then
		reportMsg = "BadBoy: >>> |cfffe2ec8|Hbadboy:%d:%s|h[Spam bloccata, clic qui per riportare!]|h|r <<<"
	end
end

--These entries add +1 point
local commonList = {
	--English
	"bonus",
	"buy",
	"cheap",
	"code",
	"coupon",
	"customer",
	"deliver",
	"discount",
	"express",
	"g[0o]ld",
	"lowest",
	"order",
	"powerle?ve?l",
	"price",
	"promoti[on][gn]",
	"reduced",
	"rocket",
	"sa[fl]e",
	"server",
	"service",
	"stock",
	"well?come",

	--French
	"livraison", --delivery
	"moinscher", --least expensive
	"prix", --price
	"commande", --order

	--German
	"billigster", --cheapest
	"lieferung", --delivery
	"preis", --price
	"willkommen", --welcome

	--Spanish
	"barato", --cheap
	"gratuito", --free
	"rapid[oe]", --fast [[ esES:rapido / frFR:rapide ]]
	"seguro", --safe/secure
	"servicio", --service

	--Chinese
	"金币", --gold currency
	"大家好", --hello everyone

	--Russian
	"з[o0]л[o0]т[ao0]", --gold
	"гoлд", --gold
	"дocтaвкa", --delivery
	"cкидкa", --discount [russian]
	"oплaт", --payment [russian]
	"прoдaжa", --sale [serbian]
	"нaличии", --stock/presence
	"цeнe", --price [serbian]
	"пoкупкe", --buy/buying/purchase [russian]
	"купи", --buy [serbian]
	"быcтрo", --fast/quickly
	"ищemпocтaвщикoв", --ищем поставщиков --looking for suppliers
	"[%.,]ru", --really can't risk any more TLDs for 2 points (Heavy Strict) until Blizz implements my requests to reduce FPs, which will probably be never
}

--These entries add +2 points
local heavyList = {
	"ourgamecenter[<c][o0@]m", --March 12
	"cicigamec[o0@]m", --April 12
	"[\226\130\172%$\194\163]+%d+.?%d*[fp][oe]r%d+[%.,]?%d*[kg]", --Add separate line if they start approx prices
	"[\226\130\172%$\194\163]+%d+[%.,]?%d*[/\\=]%d+[%.,]?%d*[kg]",
	"%d+[%.,]?%d*eur?o?s?[fp][oe]r%d+[%.,]?%d*[kg]",
	"%d+[%.,]?%d*[\226\130\172%$\194\163]+[/\\=>]+%d+[%.,]?%d*[kg]",
	"%d+[%.,]?%d*[kg][/\\=][\226\130\172%$\194\163]+%d+",
	"%d+[%.,]?%d*[kg][/\\=]%d+[%.,]?%d*[\226\130\172%$\194\163]+",
	"%d+[%.,]?%d*[kg][/\\=]%d+[%.,]?%d*e[uv]",
	"%d+[%.,]?%d*[kg][%.,]?only%d+[%.,]?%d*eu",
	"%d+o?[kg][/\\=]%$?%d+[%.,]%d+", --1OK=9.59
	"%d+[%.,]?[%do]*[/\\=]%d+[%.,]?%d*[kge]",
	"%d+[%.,]?%d*eur?[o0]?s?[/\\=<>]+%d+[%.,]?[%do]*[kg]",
	"%d+[%.,]?%d*eur?[o0]?s?[/\\=<>]+l[0o]+[kg]",
	"%d+[%.,]?%d*usd[/\\=]%d+[%.,]?%d*[kg]",
	"%d+[%.,]?%d*usd[fp][oe]r%d+[%.,]?%d*[kg]",
	"%d+[%.,]?[o%d]*[kg]%d+bonus[/\\=]%d+[%.,]?[o%d]+",
	"%d+[%.,]?%d*[кр]+зa%d+[%.,]?%d*[рк]+", --14к за 21р / 17р за 1к
}

--These entries add +2 points, but only 1 entry will count
local heavyRestrictedList = {
	"www[%.,●]+",
	"[%.,●]+c[%.,]*[o0@][%.,]*m",
	"[%.,●]+net",
	"dotc[o0@]m",
}

--These entries add +1 point, but only 1 entry will count
local restrictedIcons = {
	"{%l%l%d}",
	"{цр%d}",
	"{star}",
	"{circle}",
	"{diamond}",
	"{triangle}",
	"{moon}",
	"{square}",
	"{cross}",
	"{x}",
	"{skull}",
	"{diamant}",
}

--These entries add +1 point to the phishing count
local phishingList = {
	--English
	"account",
	"blizz",
	"claim",
	"congratulations",
	"free",
	"gamemaster",
	"gift",
	"investigat", --investigate/investigation
	"launch",
	"log[io]n",
	"luckyplayer",
	"mount",
	"pleasevisit",
	"receive",
	"service",
	"surprise",
	"suspe[cn][td]", --suspect/suspend
	"system",
	"validate",

	--German
	"berechtigt", --entitled
	"erhalten", --get/receive
	"deaktiviert", --deactivated
	"konto", --acount
	"kostenlos", --free
	"qualifiziert", --qualified
}

--These entries remove -2 points
local whiteList = {
	"recrui?t",
	"dkp",
	"lookin?g", --guild
	"lf[gm]",
	"|cff",
	"raid",
	"roleplay",
	"apply",
	"enjin",
	"guildlaunch",
	"wowstead",
	"social",
	"fortunecard",
	"house",
	"progres",
	"arena",
	"boost",
	"player",
	"[235]v[235]",
	"sucht", --de
	"gilde", --de
	"rekryt", --se
	"soker", --se
	"kilta", --fi
	"etsii", --fi
	"sosyal", --tr
}

--Any entry here will instantly report/block
local instantReportList = {
	--[[  Personal Whispers  ]]--
	"so?rr?y.*%d+[kg].*stock.*buy", --sry to bother, we have 60k g in stock today. do u wanna buy some?:)
	"server.*purchase.*gold.*deliv", --sorry to bother,currently we have 29200g on this server, wondering if you might purchase some gold today? 15mins delivery:)
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

	--[[  Casino  ]]--
	"%d+.*d[ou][ub]ble.*%d+.*trip", --10 minimum 400 max\roll\61-97 double, 98-100 triple, come roll,
	"casino.*%d+x2.*%d+x3", --{star} CASINO {star} roll 64-99x2 your wager roll 100x3 your wager min bet 50g max 10k will show gold 100% legit (no inbetween rolls plz){diamond} good luck {diamond}
	"casino.*%d+.*double.*%d+.*tripp?le", --The Golden Casino is offering 60+ Doubles, and 80+ Tripples!
	"casino.*whisper.*info", --<RollReno's Casino> <Whisper for more information!>
	"d[ou][ub]ble.*%d+.*tripp?le", --come too the Free Roller  gaming house!  and have ur luck of winning gold! :) pst me for invite:)  double is  62-96 97-100 tripple we also play blackjack---- u win double if you beat the host in blackjack
	"casino.*bet.*%d+", --Casino time. You give me your bet, Than You roll from 1-11 unlimited times.Your rolls add up. If you go over 21 you lose.You can stop before 21.When you stop I do the same, and if your closer to 21 than me than you get back 2 times your bet
	"roll.*%d+.*roll.*%d+.*bet", --Roll 63+ x2 , Roll 100 x3, Roll 1 x4 NO MAX BETS
	"casino.*roll.*double", --CASINO IS BACK IN TOWN COME PAY ME ROLL +65 AND GET DOUBLE

	--[[  Runescape Trading  ]]--
	--WTB RS gold paying WoW GOLD
	"wt[bs]rsgold.*wowgold", --WTB rs gold trading wow gold PST
	"wt[bs]wowgold.*rsgold", --WTS Wow gold for rs gold
	"wt[bs]wowgold.*rscoint?s", --WTS Wow gold for rs coints
	--WTS RUNESCAPE GOLD !~!~!~ PST
	--WTB RUNESCAPE GOLD WITH WOW GOLD PST
	"wt[bs]runescapegold", --WTB Runescape Gold, Trading WOW Gold, PST -- I will trade first.
	"exchangingrsgold", --Exchanging RS gold for WoW gold. I have 400m PST
	--WTS level 25 guild with 80k gold for runescape gold
	"goldforrunescapegold", --Exchanging WoW gold for Runescape gold pst me better price for higher amount.
	"buying?runescapeg", --buyin runescape g
	"wt[bs]runescapeaccount", --WTB runescape accounts ( pure only ) or money! i pay with wow gold. GOT 170k gold atm.
	"wt[bs]runescapepure", --WTB runescape pure ( STR PURE IS A $$ PAYING EXTRA FOR STR PURE )!
	--WTB big amount of runescape money. 2mil = 1k gold. ONLY LEGIT PEOPLE.
	"wt[bs].*runescapemoney.*%d+k", --WTB runescape money. 3mil = 1k in wow! easy money making.
	"^wt[bs]rsaccount", --wts rs acount 10k .... lvl 95 with items for over 15 mil with 6 year old holiday

	--[[  League of Legends  ]]--
	"^wt[bs]lolacco?u?n?t?$", --WTB LoL acc

	--[[  Account Buy/Sell  ]]--
	"wtsnonemergeacc.*lvl?%d+char", --!WTS none-merge acc(can get a lv80 char)./W me for more info!
	"wtslvl?%d+charallclass", --^{Square} WTS lvl 80 char all class ! /w me for more info{square}^
	"%d+lvloldaccounts?tosell", --80lvl old account to sell

	--[[  Illegal Items ]]--
	"%[.*%].*%[.*%].*facebook.com/buyboe", --Win Free[Volcano][Spire of Scarlet Pain][Obsidium Cleaver]from a simple contest, go www.facebook.com/buyboe now!
	--WTS 6PETS [Cenarion Hatchling],Lil'Rag,XT,KT,Moonkin,Panda 8K each;Prepaid gametimecard 10K;Flying Mounts[Winged Guardian],[Celestial Steed]20K each.
	"wts.*gamet?i?m?e?card.*mount", --WTS 90 Day Pre-Paid Game Card 35K Also selling mount from BLZ STORE,25k for golden dragon/lion
	--if you want buy pets/ mounts/gametimecard/ Spectral Tiger/whisper me!^^
	"pets.*mount.*gametimecard", --wts 6pets .mounts .rocket. gametimecard .Change camp. variable race. turn area. change a name. ^_^!
	"wts.*gametime.*mount.*pet", --WTS Prepaid gametime code 8k per month. the mount [Winged Guardian]'[Celestial Steed] 15K each and the pets 6k each, if u are interested,PST
	"wts.*monthgametime.*%d+k", --WTS 1 Month Gametime 10k. 3 Month Gameitme 25k. 6 Month Gametime 40k
	"wts.*gamet?i?m?e?card.*gold", --wts 60days gamecard for gold /w for more info.
	--[Winged Guardian] 25k  [Heart of the Aspects]25k  [Celestial Steed]20k and prepaid gametimecard
	"%[.*%].*%[.*%].*gamet?i?m?e?card", --wts [Heart of the Aspects]25k [Winged Guardian]25k and prepaid gametimecard
	--WTS [Heart of the Aspects]25K [Winged Guardian]25K [Celestial Steed]20K AND prepaid gametimecard
	--WTS [Celestial Steed]  [Winged Guardian]  [Heart of the Aspects] and prepaid gametimecard / 60k for half year
	"wts.*steed.*gamet?i?m?e?card", --{skull} WTS Winged Guardian 15K.Heart of the Aspects 15K Celestial Steed 15K 90 Day Pre-Paid Game Card 35K {skull}
	--VK [Phiole der Sande][Theresas Leselampe][Maldos Shwertstock],25 Minuten Lieferung auf <buyboe(dot)de>
	"%[.*%].*buyboe.*dot.*[fcd][ro0e]", --WTS [Theresa's Booklight] [Vial of the Sands] [Heaving Plates of Protection] 15mins delivery on<buyboe dot com>
	"code.*hatchling.*gamet?i?m?e?card", --WTS Codes redeem:6PETS [Cenarion Hatchling],Lil Rag,KT,XT,Moonkin,Pandaren 5k each;Prepaid gametimecard 6K;Flying mount[Celestial Steed] 15K.PST
	"gamet?i?m?e?card.*deliver", --{rt6}{rt1} 19=10k,90=51K+gamecard+rocket? deliver10mins
	--40$ for 10k gold or 45$ for  10k gold + 1 rocket  + one month  time card  .   25$ for  a  rocket .  we have  all boe items and 264 gears selled . if u r interested in .  plz whsiper me . :) ty
	--$45=10k + one X-53 Touring Rocket, $107=30K + X-53 Touring Rocket, the promotion will be done in 10 minutes, if you like it, plz whisper me :) ty
	"%$.*rocket.*%$.*rocket.*ple?a?[sz]", --$45 for 10k with a rocket {star} and 110$ for 30k with a Rocket{moon},if you like,plz pst
	--WTS X-53 Touring Rocket.( the only 2 seat flying mount you can aslo get a free month game time) .. pst
	--WTS [X-53 Touring Rocket], the only 2seats flying mount, PST
	"wts.*touringrocket.*mount", --!!!!!! WTS*X-53 TOURING ROCKET Mount(2seats)for 10000G (RAF things), you also can get a free month game time,PST me !!!
	"^wts.*x53touringrocket", --WTS[Celestial Steed],[X-53 Touring Rocket],Race,Xfer 15K,TimeCard 6K,[Cenarion Hatchling]*Rag*KT*XT*Moonk*Panda 5K
	"wts.*g[o0][1l]d.*tcgmounts.*tabard", --WTS gO1d and TCG mounts and Tabard of the Lightbringer and maig rooster egg^^/w me:)
	"sell.*rocket.*pet.*gametimecard", --sell  [X-53 Touring Rocket] &2mounts,6pets,gametimecard,CATA/WLK CD-key
	--WTS[Bladeshatter Treads][Splinterfoot Sandals][Rooftop Griptoes]&all 397 epic boot on <g2500 dot com>.
	"wts.*%[.*%].*g2500.*com", --WTS[Foundations of Courage][Leggings of Nature's Champion]Search for more wow items on <g2500 dot com>. With discount code G2500OKYO5097 to order now.
	"wts.*%[.*%].*good4game", --WTS[Blazing Hippogryph][Amani Dragonhawk][Big Battle Bear]buy TCG Mounts on good4game.c{circle}m
	"wts.*%[.*%].*%[.*%].*wealso.*cheapestg", --WTS [Reins of the Crimson Deathcharger] [Mechano-Hog] [Big Battle Bear]and we also have the cheapest G
	"wts.*%[.*%].*%d+usd.*%d+k", --WTS [Reins of the Crimson Deathcharger] [Vial of the Sands] [Reins of Poseidus],170usd=100k+a rocket for free
	"boe.*sale.*upitems", --wts [Krol Decapitator] we have all the Boe items,mats and 378 items for sale .<www.upitems.com>!!
	"wts.*%[.*%].*$%d+.*%[.*%].*$%d+", --wts[Blauvelt's Family Crest]$34.00[Gilnean Ring of Ruination]$34.99[Signet of High Arcanist Savor]$34.90pst
	"pet.*panda.*gametimecard", --Vends 6PETS [Bébé hippogriffe cénarien],Mini'Rag,XT,KT,Sélénien,Panda 12K each;payé d'avance gametimecard 15K;Bâtis volants[Gardien ailé],[Palefroi célest
	"wts.*deliver.*cheap.*price", --WTS [Reins of Poseidus],deliver fast,cheaper price ,pst,plz
	"wts.*%[.*%].*%[.*%].*cheap.*stock", --wts [Reins of the Swift Spectral Tiger] [Reins of the Spectral Tiger] [Vial of the Sands],cheapst ,in stock ,pst
	"wts.*%[.*%].*%[.*%].*cheap.*safe", --WTS [Reins of the Swift Spectral Tiger] [Tabard of the Lightbringer] [Magic Rooster Egg]Cheapest & Safest Online Trad
	"^wts.*spectraltiger.*alsootheritems$", --WTS [Magic Rooster Egg] [Reins of the Spectral Tiger] [Reins of the Swift Spectral Tiger] Also other items
	--WTS Blizzard Store Mounts (25k) and Blizzard Store Pets (10k)
	"wts.*mount.*pet.*%d+k", --WTS {star}flying mounts:[Celestial Steed] and [Winged Guardian]30k each {star}PETS:Lil'Ragnaros/Lil'XT/Lil'K.T./Moonkin/Pandaren/Cenarion Hatchling 12k each,{star}prepaid timecards 15k each.{star}
	"wts.*%[.*%].*powerle?ve?l.*chea", --wts [Reins of the Swift Spectral Tiger] [Reins of the Spectral Tiger] [Wooly White Rhino],and g ,powerlvling ,chea
	"selling%d+.*prepaidtimecard", --selling 60 day prepaid time card /w me for the price
	"need.*gametime.*rocket.*info", --Does someone need WoW Gametime & X53 Rocket's Mount  /w me for more info
	"^wts%d+days?gamecard", --wts 60 days game card /w me
	"wts.*steed.*prepaidgame", --WTS [Winged Guardian]25K [Heart of the Aspects]25K [Celestial Steed]20K prepaid game
	"gamecard.*gold.*money.*info", -- I am offer Game Card for gold or money, for more info /w me

	--[[  Russian  ]]--
	--[skull]Ovoschevik.rf[skull] continues to harm the enemy, to please you with fresh [circle]vegetables! BC 450. Operators of girls waiting for you!
	"oвoщeвик%.рф.*cвeжиmи", --[skull]Овощевик.рф[skull] продолжает, на зло врагaм, радовaть вас свежими [circle]oвoщaми! Бл 450. oператoры девyшки ждyт вaс!
	-- [[MMOSHOP.RU]] [circle] ot23r] real price [WM BL:270] [ICQ:192625006 Skype:MMOSHOP.RU, chat on the site] [Webmoney,Yandex,other]
	"mmoshop%.ru.*цeнa.*skype", -- [ [MMOSHOP.RU]] [circle] от23р] реальная цена [WM BL:270] [ICQ:192625006 Skype:MMOSHOP.RU, Чат на сайте] [Вебмани,Яндекс,другие]
	--[square] [RPGdealer.ru] [square] gives you quick access to wealth. Always on top!
	"rpgdealer%.ru.*бoгaтcтву", --[square] [RPGdealer.ru] [square] предоставит Вам быстрый доступ к богатству. Всегда на высоте!
	--GOLD WOW + SATELLITE PRESENT EACH! Lotteries 2 times a month of valuable prizes [circle] Site : [RPGdealer.ru] [circle] ICQ: 485552474. BL 360 Info on the site.
	"з[o0]л[o0]т[ao0].*rpgdealer%.ru", --ЗОЛОТО WOW + СПУТНИК В ПОДАРОК КАЖДОМУ! Розыгрыши 2 раза в мес ценных призов [circle] Сайт: [RPGdealer.ru] [circle] ICQ: 485552474. BL 360 Инфа на сайте.
	--Buy MERRY COINS on the funny-money.rf Funny price:)
	--Купи ВЕСЕЛЫЕ МОНЕТКИ на фани-мани.рф Смешные цены:)
	--Buy GOLD at [circle]funny-money.rf[circle] Price Calculator on the site.
	"купи.*фaни-maни%.рф", --Купи ЗОЛОТО на [circle]фани-мани.рф[circle] Калькулятор цен на сайте.
	--[COINS] of 23 per 1OOO | website | INGMONEY. RU | | SALE + Super Award - Spectral Tiger! ICQ 77-21-87 | | Skype INGMONEY. RU
	"ingmoney%.ru.*skype", --[МОНЕТЫ]  от 23 за 1OOO | сайт | INGMONEY. RU ||АКЦИЯ + Супер Приз - Спектральный Тигр! ICQ 77-21-87 || Skype INGMONEY. RU
	--Sell 55kg of potatoes at a low price quickly! Skype v_techno_delo [circle] 8 = 1kg
	"прoдam.*кaртoшки.*cрoчнo.*cкaйп", --Продам 55кг картошки по дешевке  срочно! скайп v_techno_delo  [circle] 8 = 1кг
	--Gold Exchange Invitation to participate suppliers and shops. With our more than 800 suppliers and 100 stores. GexDex.ru
	"з[o0]л[o0]т[ao0].*gexdex%.ru", --[skull][skull][skull] Биржа золота приглaшaет к учaстию постaвщиков и магазины. С нами болee 800 постaвщиков и 100 магaзинов. GеxDеx.ru
	--Cheapest price only here! Price 1000 gold-20R, from 40k-18r on, from-60k to 17p! Website [playwowtime.vipshop.ru]! ICQ 196-353-353, skype nickname playwowtime2011!
	"vipshop%.ru.*skype", --Самые дешевые цены только у нас! Цены 1000 золотых- 20р , от 40к -по 18р , от 60к-по 17р ! Сайт [playwowtime.vipshop.ru] ! ICQ 196-353-353 , skype ник playwowtime2011!

	--[[  Chinese  ]]--
	--嗨 大家好  团购金币送代练 炼金龙 还有各职业账号 详情请咨询 谢谢$18=10k;$90=50k+1000G free;$180=100k+2000g+月卡，也可用G 换月卡
	--{rt3}{rt1} 春花秋月何时了，买金知多少.小楼昨夜又东风，金价不堪回首月明中. 雕栏玉砌金犹在，只是价格改.问君能有几多愁，恰似我家金价在跳楼.QQ:1069665249
	--大家好，金币现价：19$=10k,90$=50k另外出售火箭月卡，还有70,80,85账号，全手工代练，技能代练，荣誉等，华人价格从优！！买金币还是老牌子可靠，sky牌金币，您最好的选择！
	"only%d+.*for%d+k.*rocket.*card", --only 20d for 10k,90d for 50k,X-53 rocket,recuit month card ,pst for more info{rt1}另外出售火箭月卡，买金送火箭月卡，账号，代练等，华人价格从优！！
	"金币.*%d+k.*惊喜大奖", --卖坐骑啦炽热角鹰兽白色毛犀牛大小幽灵虎红色DK马等拉风坐骑热销中，金币价格170$/105k,更有惊喜大奖等你拿=D
	--17=10k 160=100K 359BOE LVL85 Account For SaIe 疯狂甩卖 P0werleveling 1-85 only need 7days 还有大小幽灵虎
	"%d+=%d+k.*boe.*p[0o]we?rle?ve?ling.*虎", --17=10k 160=100K 359BOE疯狂甩卖 P0werleveling 1-85还有大小幽灵虎等你来拿PST
	"%d+=%d+k.*r0cket.*p[0o]we?rle?ve?ling", --$50=30k $80=50K+X-53T0uring R0cket+1 M0nth G@me Time , 378B0Es For SaIe 疯狂甩卖 P0werleveling 1-85 only 7 days, Help Do Bloodbathed Frostbrood Vanquisher Achivement!代打ICC成就龙,华人优惠哦
	"金.*%d+=%d+k.*boe.*虎", --暑假WOW大促销啦@，金币超低价 <200=100k+10kextra> , 国服/美服1-85效率代练5天完成，378BOE各种装备甩卖，各职业帐号，大小幽灵虎等稀有坐骑现货，金币换火箭，月卡牛
	"only.*%d+k.*deliver.*售", --only 17d for 10k,160d for 100k,deliver in 5mins, pst for more info另出售装备，账号，坐骑，85代练，华人价格从优！！!
	"专业代练.*安全快速发货", --17美元=10k  大量金币薄利多销，货比三家，专业代练1-85，练技能，账号，火箭月卡，还有各种378BOE装备，各种新材料，大小幽灵虎，专业团队代打ICC成就龙，刷荣誉等，安全快速发货
	"cheap.*sale.*囤货", --WTS [Blazing Hippogryph] [Amani Dragonhawk]cheapest for sale,pst,plz 龙鹰和角鹰兽囤货，需要速密，谢谢
	"金币.*卖.*买金币", --感恩大回馈金币大甩卖 ,买金币送坐骑，送代练，需要的请M,另外有378装备，代练，帐号，月卡出售。大、小幽灵虎，犀牛，角鹰兽， 魔法公鸡，赤红DK战马,战斗熊等
	"wts.*%[.*%].*gear.*%d+k.*gift", --WTS大卖 [Dragonbelly Bracers] [Boots of Fungoid Growth] lvl384 or 397 pattern gear Gem 150$=100k+a free gift,17$=10k, pst withi more offer
	"wts.*%[.*%].*cheap.*囤货甩卖", --WTS [Savage Raptor] [Blazing Hippogryph] [X-51 Nether-Rocket X-TREME] cheap pst,囤货甩卖，需要的
	"wts.*%[.*%].*cheapgold.*%d+k", --WTS大卖 [Pattern: Bladeshadow Wristguards] [Pattern: World Mender's Pants] and cheap gold 10k for 15,100k for 140 pst
	--WOW龙魂8H效率团低价出售橙匕+WOW各版本橙武。 397/403/410/416装备。带刷成就龙(ICC,ULD,CATA,FL)。帅气坐骑.死翼坐骑/火鹰/等。带刷RBG荣誉.1-85手工代练美金消费欢迎咨询QQ: 1416781477
	"出售.*成就.*欢迎.*qq", --WOW龙魂8H美金消费团出售橙匕+WOW各版本橙武。 397/403/410/416装备。带刷成就龙(ICC,ULD,CATA,FL)。低价出售帅气坐骑.死翼坐骑/火鹰/等。带刷RBG荣誉.1-85手工代练欢迎咨询QQ: 1416781477

	--[[  Advanced URL's/Misc  ]]--
	"%d+eu.*deliver.*credible.*kcq[%.,]", --12.66EUR/10000G 10 minutes delivery.absolutely credible. K C Q .< 0 M
	"deliver.*gears.*g4p", --Fast delivery for Level 359/372 BoE gears!Vist <www.g4pitem.com> to get whatever you need!
	"pkpkg.*boe.*deliver", --[PKPKG.COM] sells all kinds of 346,359lvl BOE gears. fast delivery. your confidence is all garanteed
	"service.*pst.*info.*%d+k.*usd", --24 hrs on line servicer PST for more infor. Thanks ^_^  10k =32 u s d  -happy friday :)
	"okgolds.*only.*%d+.*euro", --WWW.okgolds.COM,10000G+2000G.only.15.99EURO}/2
	"mmo4store.*%d+[kg].*good.*choice", --{square}MMO4STORE.C0M{square}14/10000G{square}Good Choice{square}
	"promotion.*serve.*%d+k", --Special promotion in this serve now, 21$ for 10k
	"pkpkg.*gear.*pet", --WWW.PkPkg.C{circle}M more gears,mount,pet and items on
	"euro.*gold.*safer.*trade", --Only 1.66 Euros per 1000 gold, More safer trade model.
	--WWW.PVPBank.C{circle}MCODE=itempvp(20% price off)
	"www[%.,]pvpbank[%.,]c.*%d+", --Wir haben mehr Ausr?stungen, Mounts und Items, die Sie mochten. Professionelles Team fuer 300 Personen sind 24 Stunde fuer Sie da.Wenn Sie Fragen haben,wenden Sie an uns bitteWWW.PVPBank.C{circle}M7 Tage 24 Uhr Service.
	"wts.*boeitems.*sale.*ignah", --wts [Lightning-Infused Leggings] [Carapace of Forgotten Kings] we have all the Boe items,mats and t10/t10.5 for sale .<www.ignah.com>!!
	"mmoarm2teeth.*wanna.*gear.*season.*wowgold", --hey,this is [3w.mmoarm2teeth.com](3w=www).do you wanna get heroic ICC gear,season8 gear and wow gold?
	"skillcopper.*wow.*mount.*gold", --skillcopper.eu Oldalunk ujabb termekekel bovult WoWTCG Loot Card-okal pl.:(Mount: Spectral Tiger, pet: Tuskarr Kite, Spectral Kitten Fun cuccok: Papa Hummel es meg sok mas) Gold, GC, CD kulcsok Akcio! Latogass el oldalunkra skillcopper.eu
	"meingd[%.,]de.*eur.*gold", --[MeinGD.de] - 0,7 Euro - 1000 Gold - [MeinGD.de]
	"%$.*boe.*deliver.*interest", --{rt3}{rt1} WTS WOW G for $$. 10k for 20$, 52k for 100$. 105k for 199$. all item level 359 BOE gear. instant delivery! PST if ya have insterest in it. ^_^
	"^wtscheapergold/whisper$", --{square} WTS CHeaper gold /whisper {square}
	"wowhelp%.1click%.hu", --{square}Have a nice day, enjoy the game!{square} - {star} [http://wowhelp.1-click.hu/] - One click for all WoW help! {star}
	"g4p.*gold.*discount", --Saray Daily Greetings ? thanks for your previous support on G4P,here I am reminding you of our info, you may need it again :web:G4Pgold,Discount code:saray,introducer ID:saray
	"%d+k.*deliver.*item", --$20=10K, $100=57k,$200=115k with instant delivery,all lvl378 items,pst
	"money.*gold.*gold2sell", --Ingame gold for real money! Real gold for Ingame gold! Ingame gold for a account key! If you're intrested, then check out: "gold2sell.org" now!
	"%d+=%d+k.*cheap.*fast.*boe", --WTS RBG 2400 Rating,3.88=10k, cheap and fast. Also kinds of BOE in store. Pst me for detail
	"wtsgold.*mount.*tar?bard.*acc", --WTS gold and some TCG mounts and Tarbard of the lightbringer and 80lvl acc
	"%d+[/\\=]%d+.*gold4power", --?90=5oK Google:Gold4Power, Introducer ID:saray
	"k%.?4g[o0]ldcom.*code", --{star}.W{star}.W{star}W {square} k{triangle}.4{triangle}g{triangle}o{triangle}l{triangle}d {square} c{star}o{star}m -------{square}- c{star}o{star}d{star}e : CF \ CO \ CK
	"kb8g[o0]ld.*%d+.*st[o0]ck", --KB8GOLD com 8.5EUR = 10000,269K IN STOCK NOW!
	--www K4power c@m.Lowest Price + 10% Free G.{Code:4Power}--
	--~~K.4.p.0.W.e.r,C,o,m~~ 4.€.~1O0O0
	"k[%.,]*4[%.,]*p[%.,]*[o0][%.,]*w[%.,]*e[%.,]*r.*%d[%do]+", --WWW K4POWER C0M {Code:Xmas}->>Xmas Promotions{18th Dec-26th Dec}->35% Free,0rder 50k More->X-53 Rocket Mount For Free!
	"%d[%do]+.*k[%.,]*4[%.,]*p[%.,]*[o0][%.,]*w[%.,]*e[%.,]*r", --4e<> 10O0O @ k4põwér C'Q'M @
	"deliver.*g[@o]ldw[@o]w2012", --$$ Lv 1-85=127EUR+7days $$ 397-410 professional equipment,TCG Loot card,rare mount $$ fast delivery within 24 horus $$ g@ldW@W2012 C@M $$
	"wts.*%[.*%].*cheap.*gold.*%d+%$", --WTS [Reins of the Swift Spectral Tiger] [Tabard of the Lightbringer]{rt3}{rt3}cheapest gold,110$=100k,pst with more offer,plz!!!!
	"wts.*euro.*boe.*deliver", --WTS RBG 2400 RATING, 3.88 "euro"=10 K,Also kinds of BOE 11in store.fast delivery,Pst me for detail
	"msn.*salliaes7587.*%d[%do]+", --1K 1TL ! MSN Adresi salliaes7587@hotmail.c@m !isteyene referans gosterilir :)MSNden eklemeniz yeterli!1OOk 9O TL :)
	"gear.*%d+=%d+.*ourgamecenter", --WTS gear & item 410/416, 25m raid team{star}10000=8 ,50000=40{star}wwvv-OurGameCenter-< om{star}waiting for u!!!
	"like.*facebook.*goldsdepot", --{diamant}anyone who {diamant}LIKE {diamant}our FACEBOOK{dreieck}goldsdepot{dreieck}can get 4000  free G !!!
	"g[0o]ld.*deliver.*bonus", --3WG0ldsDepot C0M SAVE UP 40% 15Mins DELIVERY 10000=5.99 NEW MEMEBER CAN GET 10% BONUS,NICE CUST0MER ASSISTANT say “NO” to “ ST0LEN G0LD “!!!
	--{square}G0lDSDEP0T C..0..M {square}{star}10mns.. {star}{diamond} 10k=5.99 {diamond}
	"g[%.,]*[0o][%.,]*[l1][%.,]*d[%.,]*s[%.,]*d[%.,]*e[%.,]*p[%.,]*[o0][%.,]*t.*%d[%do]+[%.,]*[kg]", --{square}G01dsDepot{square}c..0..m {square}10k=5.99{square}Refuse St01en G01d{square}
	"g[%.,]*[0o][%.,]*[l1][%.,]*d[%.,]*s[%.,]*d[%.,]*e[%.,]*p[%.,]*[o0][%.,]*t.*d[%.,]*e?[%.,]*[l1][%.,]*i[%.,]*v[%.,]*e?[%.,]*r", --{diamond} G.0.l.d.s.d.e.p.o.t,C,o,m {diamond}10m,in Dlivry,10000=5.99, 10% Extra G for Easter
	"k[%.,]*4[%.,]*g[%.,]*u[%.,]*i[%.,]*l[%.,]*d.*d[%.,]*e[%.,]*[l1][%.,]*i[%.,]*v[%.,]*e", ----3.W,K.4.G.U.I.L.D,C.@.m 4.5 Êürõ--10k+1O%Disçòünt, Délìvèry 6 M.i.n.s
	"k[%.,]*4[%.,]*p[%.,]*[o0][%.,]*w[%.,]*e[%.,]*r.*d[%.,]*e[%.,]*[l1][%.,]*i[%.,]*v[%.,]*e", --3.w,K.4.P.0.W.E.R,c.@.m 4 èü // 1Ok,Délìvèry 6 M.i.n.s
	"w[%.,]*o[%.,]*w[%.,]*4[%.,]*w[%.,]*o[%.,]*w.*d[%.,]*e[%.,]*[l1][%.,]*i[%.,]*v[%.,]*e",
	"[hl][%.,]*[au][%.,]*[pc][%.,]*[pk][%.,]*y[%.,]*g[%.,]*o[%.,]*l[%.,]*d[%.,]*s.*d[%.,]*e[%.,]*[l1][%.,]*i[%.,]*v[%.,]*e",
	"[hl!|][%.,]*[au][%.,]*[pc][%.,]*[pk][%.,]*y[%.,]*g[%.,]*[o0q][%.,]*[l!|][%.,]*d[%.,]*s.*%d[%do]+",
	"%d[%do]+.*[hl!|][%.,]*[au][%.,]*[pc][%.,]*[pk][%.,]*y[%.,]*g[%.,]*[o0q][%.,]*[l!|][%.,]*d[%.,]*s",
	"[wv][%.,]*[o0q][%.,]*[wv]v?[%.,]*4[%.,]*[wv]v?[%.,]*[o0q][%.,]*[wv]v?.*%d[%do]+",
	"%d[%do]+.*[wv][%.,]*[o0q][%.,]*[wv]v?[%.,]*4[%.,]*[wv]v?[%.,]*[o0q][%.,]*[wv]v?",
	"^[wv][%.,]*[o0][%.,]*[wv]v?[%.,]*4[%.,]*[wv]v?[%.,]*[o0][%.,]*[wv]v?[%.,]*c[%.,]*[o0][%.,]*m$",
	"^[hl][%.,]*[au][%.,]*[pc][%.,]*[pk][%.,]*y[%.,]*g[%.,]*[o0][%.,]*l[%.,]*d[%.,]*s[%.,]*c[%.,]*[o0][%.,]*m$",
	"[hl!|][%.,]*[au][%.,]*[pc][%.,]*[pk][%.,]*y[%.,]*g[%.,]*[o0q][%.,]*[l!|][%.,]*d[%.,]*s.*s[%.,]*[ae][%.,]*[l!|][%.,]*[l!|e]",
	"[wv][%.,]*[o0q][%.,]*[wv]v?[%.,]*4[%.,]*[wv]v?[%.,]*[o0q][%.,]*[wv]v?.*s[%.,]*[ae][%.,]*[l!|][%.,]*[l!|e]",
	"s[%.,]*[ae][%.,]*[l!|][%.,]*[l!|e].*[hl!|][%.,]*[au][%.,]*[pc][%.,]*[pk][%.,]*y[%.,]*g[%.,]*[o0q][%.,]*[l!|][%.,]*d[%.,]*s",
	"s[%.,]*[ae][%.,]*[l!|][%.,]*[l!|e].*[wv][%.,]*[o0q][%.,]*[wv]v?[%.,]*4[%.,]*[wv]v?[%.,]*[o0q][%.,]*[wv]v?",
	"\\/\\/[o0]\\/\\/4\\/\\/[o0]\\/\\/.*%d[%do]+",
	"%d[%do]+.*\\/\\/[o0]\\/\\/4\\/\\/[o0]\\/\\/",
	"\\/\\/[o0]\\/\\/4\\/\\/[o0]\\/\\/.*s[%.,]*[ae][%.,]*[l!|][%.,]*[l!|e]",
	"s[%.,]*[ae][%.,]*[l!|][%.,]*[l!|e].*\\/\\/[o0]\\/\\/4\\/\\/[o0]\\/\\/",
	--Vend RBG 2400{star} 3.88“euro”=10k{moon}rapide et sûre.{star}D'autres types de BOE est également en vente.
	"vend.*prix.*livraison.*wow%.po", --Vend Po à prix interessant Livraison instantanée. Paiement par SMS/Tel ou Paypal, me contacter Skype: wow.po
	"verkauf.*hotgolds.*%d+g", --Gréat Vérkauf! .Hôtgôlds.côrn10000G.only.2.éUR.Hôtgôlds.côrnWWWé habén 783k spéichért und k?nnén Sié érhaltén innérhalb von 5-10 Minutén.wénn Sié kaufén ,  4403
	"%d[%do]+=%d+%.?%d*e.*bonus.*skype", --@1òòòO=5.52ё.5% BòNuS.5-15mins can Gёt./w me for skype@
}

--This is the replacement table. It serves to deobfuscate words by replacing letters with their English "equivalents".
local repTbl = {
	["а"]="a", ["à"]="a", ["á"]="a", ["ä"]="a", ["â"]="a", ["ã"]="a", ["å"]="a", --First letter is Russian "\208\176". Convert > \97
	["с"]="c", ["ç"]="c", --First letter is Russian "\209\129". Convert > \99
	["е"]="e", ["è"]="e", ["é"]="e", ["ë"]="e", ["ё"]="e",["ê"]="e", --First letter is Russian "\208\181". Convert > \101
	["ì"]="i", ["í"]="i", ["ï"]="i", ["î"]="i", --Convert > \105
	["Μ"]="m", ["м"]="m",--First letter is capital Greek μ "\206\156". Convert > \109
	["о"]="o", ["ò"]="o", ["ó"]="o", ["ö"]="o", ["ō"]="o", ["ô"]="o", ["õ"]="o", --First letter is Russian "\208\190". Convert > \111
	["ù"]="u", ["ú"]="u", ["ü"]="u", ["û"]="u", --Convert > \117
}

local strfind = string.find
local IsSpam = function(msg, num)
	for i=1, #instantReportList do
		if strfind(msg, instantReportList[i]) then
			if myDebug then print("Instant", instantReportList[i]) end
			return true
		end
	end

	local points, phishPoints = num, num
	for i=1, #whiteList do
		if strfind(msg, whiteList[i]) then
			points = points - 2
			phishPoints = phishPoints - 2 --Remove points for safe words
			if myDebug then print(whiteList[i], points, phishPoints) end
		end
	end
	for i=1, #commonList do
		if strfind(msg, commonList[i]) then
			points = points + 1
			if myDebug then print(commonList[i], points, phishPoints) end
		end
	end
	for i=1, #heavyList do
		if strfind(msg, heavyList[i]) then
			points = points + 2 --Heavy section gets 2 points
			if myDebug then print(heavyList[i], points, phishPoints) end
		end
	end
	for i=1, #heavyRestrictedList do
		if strfind(msg, heavyRestrictedList[i]) then
			points = points + 2
			phishPoints = phishPoints + 1
			if myDebug then print(heavyRestrictedList[i], points, phishPoints) end
			break --Only 1 trigger can get points in the strict section
		end
	end
	for i=1, #phishingList do
		if strfind(msg, phishingList[i]) then
			phishPoints = phishPoints + 1
			if myDebug then print(phishingList[i], points, phishPoints) end
		end
	end
	if points > 3 or phishPoints > 3 then
		return true
	end
end

--[[ Chat Scanning ]]--
local gsub, prevLineId, result, chatLines, chatPlayers, prevWarn = gsub, 0, nil, {}, {}, 0
local filter = function(_, event, msg, player, _, _, _, flag, channelId, _, _, _, lineId)
	if lineId == prevLineId then
		return result --Incase a message is sent more than once (registered to more than 1 chatframe)
	else
		if not lineId then --Still some addons floating around breaking stuff :-/
			local t = GetTime()
			if t-prevWarn > 60 then --Throttle this warning as I imagine it could get quite spammy
				prevWarn = t
				print("|cFF33FF99BadBoy|r: One of your addons is breaking critical chat data I need to work properly :(")
			end
			return
		end
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
					--don't bother checking server anymore as bnet has been bugging up a lot lately
					--returning "" as server/location (probably other things too) making the check useless
					if rName == player and rGame == "WoW" then
						result = nil return
					end
				end
			end
		end
	end
	local debug = msg --Save original message format
	msg = msg:lower() --Lower all text, remove capitals

	--They like to use raid icons to avoid detection
	local icon = 0
	if strfind(msg, "{", nil, true) then --Only run the icon removal code if the chat line has raid icons that need removed
		local found = 0
		for i=1, #restrictedIcons do
			msg, found = gsub(msg, restrictedIcons[i], "")
			if found > 0 then
				icon = 1
			end
		end
		if myDebug and icon == 1 then print("Removing icons, adding 1 point.") end
	end
	--End icon removal
	msg = gsub(msg, "[“”%*%-%(%)\"`'_%+#%%%^&;:~{} ]+", "") --Remove spaces, symbols, etc

	--They like to replace English letters with UTF-8 "equivalents" to avoid detection
	if strfind(msg, "[аàáäâãåсçеèéëёêìíïîΜмоòóöōôõùúüû]+") then --Only run the string replacement if the chat line has letters that need replaced
		--This is no where near as resource intensive as I originally thought, it barely uses any CPU
		for k,v in pairs(repTbl) do --Parse over the 'repTbl' table and replace strings
			msg = gsub(msg, k, v)
		end
		if myDebug then print("Running replacements") end
	end
	--End string replacements

	--20 line text buffer, this checks the current line, and blocks it if it's the same as one of the previous 15
	for i=1, #chatLines do
		if chatLines[i] == msg and chatPlayers[i] == player then --If message same as one in previous 15 and from the same person...
			result = true return true --...filter!
		end
		if i == 20 then tremove(chatLines, 1) tremove(chatPlayers, 1) end
	end
	tinsert(chatLines, msg) tinsert(chatPlayers, player)
	--End text buffer

	if IsSpam(msg, icon) then
		if BadBoyLogger and not myDebug then
			BadBoyLogger("BadBoy", event, player, debug)
		end
		if myDebug then
			print("|cFF33FF99BadBoy_REPORT|r: ", debug, "-", event, "-", player)
		else
			if BADBOY_POPUP then --Manual reporting via popup
				--Add original spam line to Blizzard popup message
				StaticPopupDialogs["CONFIRM_REPORT_SPAM_CHAT"].text = "BadBoy: ".. REPORT_SPAM_CONFIRMATION .."\n\n".. gsub(debug, "%%", "%%%%")
				local dialog = StaticPopup_Show("CONFIRM_REPORT_SPAM_CHAT", player)
				dialog.data = lineId
			else
				--Show block message
				if not BADBOY_NOREPORT then
					ChatFrame1:AddMessage(reportMsg:format(lineId, player), 0.2, 1, 0.6)
				end
			end
		end
		result = true
		return true
	end
	result = nil
end

--[[ Configure report links ]]--
do
	local reportTbl = {}
	local oldShow = ChatFrame_OnHyperlinkShow
	ChatFrame_OnHyperlinkShow = function(self, data, ...)
		local badboy, lineId, player = strsplit(":", data)
		if badboy and badboy == "badboy" then
			lineId = tonumber(lineId)
			if CanComplainChat(lineId) and not reportTbl[player] then
				reportTbl[player] = true
				ReportPlayer("spam", lineId)
			end
			return
		end
		oldShow(self, data, ...)
	end
end

--[[ Configure popup reporting ]]--
StaticPopupDialogs["CONFIRM_REPORT_SPAM_CHAT"].OnHide = function(self)
	self.text:SetText(REPORT_SPAM_CONFIRMATION) --Reset popup message to default for manual reporting
end

--[[ Add Filters ]]--
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", filter)

SetCVar("spamFilter", 1)

