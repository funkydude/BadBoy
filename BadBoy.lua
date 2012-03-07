--[[	BLIZZARD IF YOU'RE READING THIS I'M BEGGING FOR YOUR HELP.
		Please let me fetch either player level from the given guid (will also help BadBoy_Levels)
		or let me fetch if the player is in a guild or not from the given guid (spammers never guilded)
		or both!

		I can then, 1) only scan chat from unguilded WoW players, 2) only scan chat from
		players below level 10 (55-60 for DKs), this would near enough eliminate any chance of false positives.

		You haven't implemented anything to help filtering gold spam since ComplainChat(), that was years ago, please show us you care.
]]--

-- GLOBALS: print, SetCVar, GetTime, ipairs, UnitInParty, UnitInRaid, UnitIsInMyGuild, ComplainChat, CanComplainChat, BNGetNumFriends, BNGetNumFriendToons, BNGetFriendToonInfo, GetRealmName
local myDebug = nil

--These entries remove -2 points
local whiteList = {
	"recruit",
	"dkp",
	"looking", --guild
	"lf[gm]",
	"|cff",
	"raid",
	"roleplay",
}

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
	"gold",
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

	--German
	"billigster", --cheapest
	"lieferung", --delivery
	"preis", --price
	"willkommen", --welcome

	--Spanish
	"barato", --cheap
	"gratuito", --free
	"r[\195\161a]+pido", --fast
	"seguro", --safe/secure
	"servicio", --service

	--Chinese
	"金币", --gold currency
	"大家好", --hello everyone

	--Russian
	"з[o0]л[o0]т[ao0]", --gold
	"дocтaвкa", --delivery
	"cкидкa", --discount [russian]
	"oплaт", --payment [russian]
	"прoдaжa", --sale [serbian]
	"нaличии", --stock/presence
	"цeнe", --price [serbian]
	"пoкупкe", --buy/buying/purchase [russian]
	"купи", --buy [serbian]
	"быcтрo", --fast/quickly
	"ищeмпocтaвщикoв", --ищем поставщиков --looking for suppliers
	"[%.,]ru", --really can't risk any more TLDs for 2 points (Heavy Strict) until Blizz implements my requests to reduce FPs, which will probably be never
}

--These entries add +2 points
local heavyList = {
	"[\226\130\172%$\194\163]+%d+[%.%-]?%d*[fp][oe]r%d+%.?%d*[kg]", --Add separate line if they start approx prices
	"[\226\130\172%$\194\163]+%d+%.?%d*[/\\=]%d+%.?%d*[kg]",
	"%d+%.?%d*eur?o?s?[fp][oe]r%d+%.?%d*[kg]",
	"%d+%.?%d*[\226\130\172%$\194\163]+[/\\=%-]%d+%.?%d*[kg]",
	"%d+%.?%d*[kg][/\\=][\226\130\172%$\194\163]+%d+",
	"%d+%.?%d*[kg][/\\=]%d+%.?%d*[\226\130\172%$\194\163]+",
	"%d+%.?%d*[kg][/\\=]%d+[%.,]?%d*eu",
	"%d+%.?%d*eur?o?s?[/\\=]%d+%.?%d*[kg]",
	"%d+%.?%d*usd[/\\=]%d+%.?%d*[kg]",
	"%d+%.?%d*usd[fp][oe]r%d+%.?%d*[kg]",
	"%d+%.?%d*кзa%d+%.?%d*р", --14к за 21р
}

--These entries add +2 points, but only 1 entry will count
local heavyRestrictedList = {
	"www[%.,{]",
	"[%.,]c%-?[o0@]%-?m",
	"[%.,]c{circle}m",
	"[%.,]c{rt2}m",
	"[%.,]cqm",
	"[%.,]net",
}

--These entries add +1 point, but only 1 entry will count
local restrictedIcons = {
	"{rt%d}",
	"{star}",
	"{circle}",
	"{diamond}",
	"{triangle}",
	"{moon}",
	"{square}",
	"{cross}",
	"{цр%d}", --Russian
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

--Any entry here will instantly report/block
local instantReportList = {
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

	--Russian
	--[skull]Ovoschevik.rf[skull] continues to harm the enemy, to please you with fresh [circle]vegetables! BC 450. Operators of girls waiting for you!
	"{.*}.*oвoщeвик%.рф.*{.*}", --[skull]Овощевик.рф[skull] продолжает, на зло врагaм, радовaть вас свежими [circle]oвoщaми! Бл 450. oператoры девyшки ждyт вaс!
	-- [[MMOSHOP.RU]] [circle] ot23r] real price [WM BL:270] [ICQ:192625006 Skype:MMOSHOP.RU, chat on the site] [Webmoney,Yandex,other]
	"mmoshop%.ru.*цeнa.*skype", -- [ [MMOSHOP.RU]] [circle] от23р] реальная цена [WM BL:270] [ICQ:192625006 Skype:MMOSHOP.RU, Чат на сайте] [Вебмани,Яндекс,другие]
	--[square] [RPGdealer.ru] [square] gives you quick access to wealth. Always on top!
	--[square] [RPGdealer.ru] [square] предоставит Вам быстрый доступ к богатству. Всегда на высоте!
	--GOLD WOW + SATELLITE PRESENT EACH! Lotteries 2 times a month of valuable prizes [circle] Site : [RPGdealer.ru] [circle] ICQ: 485552474. BL 360 Info on the site.
	"rpgdealer%.ru.*{.*}", --ЗОЛОТО WOW + СПУТНИК В ПОДАРОК КАЖДОМУ! Розыгрыши 2 раза в мес ценных призов [circle] Сайт: [RPGdealer.ru] [circle] ICQ: 485552474. BL 360 Инфа на сайте.
	--Buy MERRY COINS on the funny-money.rf Funny price:)
	--Купи ВЕСЕЛЫЕ МОНЕТКИ на фани-мани.рф Смешные цены:)
	--Buy GOLD at [circle]funny-money.rf[circle] Price Calculator on the site.
	"купи.*фaни-мaни%.рф", --Купи ЗОЛОТО на [circle]фани-мани.рф[circle] Калькулятор цен на сайте.
	--[COINS] of 23 per 1OOO | website | INGMONEY. RU | | SALE + Super Award - Spectral Tiger! ICQ 77-21-87 | | Skype INGMONEY. RU
	"ingmoney%.ru.*skype", --[МОНЕТЫ]  от 23 за 1OOO | сайт | INGMONEY. RU ||АКЦИЯ + Супер Приз - Спектральный Тигр! ICQ 77-21-87 || Skype INGMONEY. RU
	--Sell 55kg of potatoes at a low price quickly! Skype v_techno_delo [circle] 8 = 1kg
	"прoдaм.*кaртoшки.*cрoчнo.*cкaйп", --Продам 55кг картошки по дешевке  срочно! скайп v_techno_delo  [circle] 8 = 1кг
	--Gold Exchange Invitation to participate suppliers and shops. With our more than 800 suppliers and 100 stores. GexDex.ru
	"з[o0]л[o0]т[ao0].*gexdex%.ru", --[skull][skull][skull] Биржа золота приглaшaет к учaстию постaвщиков и магазины. С нами болee 800 постaвщиков и 100 магaзинов. GеxDеx.ru
	--Cheapest price only here! Price 1000 gold-20R, from 40k-18r on, from-60k to 17p! Website [playwowtime.vipshop.ru]! ICQ 196-353-353, skype nickname playwowtime2011!
	"vipshop%.ru.*skype", --Самые дешевые цены только у нас! Цены 1000 золотых- 20р , от 40к -по 18р , от 60к-по 17р ! Сайт [playwowtime.vipshop.ru] ! ICQ 196-353-353 , skype ник playwowtime2011!

	--Chinese
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

	--Advanced URL's/Misc
	"%d+eu.*deliver.*credible.*kcq[%.,]", --12.66EUR/10000G 10 minutes delivery.absolutely credible. K C Q .< 0 M
	"happy.*%d+for%d+k.*gear.*mount", --{star}{star}{star}happy new year, $100=30K,$260 for 100K, and have the nice 359lvl gears about $39~99 best mount for ya as well{star}{star}{star}{star}
	"deliver.*gears.*g4p", --Fast delivery for Level 359/372 BoE gears!Vist <www.g4pitem.com> to get whatever you need!
	"sale.*joygold.*store", --Great sale! triangletriangletriangle www.joygold.com.www.joygold.com diamonddiamonddiamond 10000G.only.13.99 EUR circle WWWE have 257k stores and you can receive within 5-10 minutes star
	"pkpkg.*boe.*deliver", --[PKPKG.COM] sells all kinds of 346,359lvl BOE gears. fast delivery. your confidence is all garanteed
	"service.*pst.*info.*%d+k.*usd", --24 hrs on line servicer PST for more infor. Thanks ^_^  10k =32 u s d  -happy friday :)
	"deathwing.*fear.*terror.*official.*cata.*surprise.*ZYY", --Deathwing has come spreading fear and terror, it is now officially World of WarCraft Cataclysm. Make sure you are prepared and find surprises at ZYY.
	"okgolds.*only.*%d+.*euro", --WWW.okgolds.COM,10000G+2000G.only.15.99EURO}/2
	"mmo4store.*%d+[kg].*good.*choice", --{square}MMO4STORE.C0M{square}14/10000G{square}Good Choice{square}
	"^%W+.*mmoggg", -->>> MMOGGG is recruiting now!
	"customer.*promotion.*cost.*gold", --Dear customer: This is kyla from promotion site : mmowin ^_^Long time no see , how is going? Been miss ya :)As the cataclysm coming and the market cost line for gold and boe item has been down a lot recently , we will send present if ya get 30k or 50k
	--40$ for 10k gold or 45$ for  10k gold + 1 rocket  + one month  time card  .   25$ for  a  rocket .  we have  all boe items and 264 gears selled . if u r interested in .  plz whsiper me . :) ty
	--$45=10k + one X-53 Touring Rocket, $107=30K + X-53 Touring Rocket, the promotion will be done in 10 minutes, if you like it, plz whisper me :) ty
	"%$.*rocket.*%$.*rocket.*ple?a?[sz]", --$45 for 10k with a rocket {star} and 110$ for 30k with a Rocket{moon},if you like,plz pst
	--WTS X-53 Touring Rocket.( the only 2 seat flying mount you can aslo get a free month game time) .. pst
	--WTS [X-53 Touring Rocket], the only 2seats flying mount, PST
	"wts.*touringrocket.*mount.*pst", --!!!!!! WTS*X-53 TOURING ROCKET Mount(2seats)for 10000G (RAF things), you also can get a free month game time,PST me !!!
	"wts.*touringrocket.*%d+k", --WTS[Celestial Steed],[X-53 Touring Rocket],Race,Xfer 15K,TimeCard 6K,[Cenarion Hatchling]*Rag*KT*XT*Moonk*Panda 5K
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
	"meingd[%.,]de.*eur.*gold", --[MeinGD.de] - 0,7 Euro - 1000 Gold - [MeinGD.de]
	"{.*}.*ourgamecenter.*{.*}", --Off 30% {square} 'www' OurGameCenter 'com' {square}100K=142$ !!
	--"cheap.*ourgamecenter.*deliver", --The Cheapest,10K=15,{moon} 'www' OurGameCenter 'com' {moon}Fast Delivery
	--"surprise.*%d+k.*ourgamecenter", --surprise!!11K~15.99 {square} 'www' OurGameCenter 'com' {square}
	--Sorry for disturb{diamond}(cyrillic sha sha sha) OurGameCenter (cyrillic c o m){diamond}10K=15,have stock.
	"ourgamecenter.*%d+k.*stock", --OurGameCenter com 10K~14K,full stock,fulfill 10 Mins.
	"ourgamecenter.*deliver", --www OurGameCenter com not only ensure prompt delivery but that your order remains secure every timewe guarantee it! 
	"secure.*gamecenter.*discount", --Sorry for disturb you We are a secure website 'www' OurGameCenter 'com' 11K~15.99!(EASY TO GET 10% DISCOUNT  GET ANOTHER 5% FOR INTRODUCING FRIENDS TO US)
	"%$.*boe.*deliver.*interest", --{rt3}{rt1} WTS WOW G for $$. 10k for 20$, 52k for 100$. 105k for 199$. all item level 359 BOE gear. instant delivery! PST if ya have insterest in it. ^_^
	"gold.*trading.*ourgamecenter", --A WoW Gold Professional trading siteшшш OurGameCenter сом
	--WTS [Theresa's Booklight] [Vial of the Sands] [Heaving Plates of Protection]and others pls go <buyboe dot com> 
	--WTS [Heaving Plates of Protection] [Vial of the Sands] [Theresa's Booklight], best service on<buyboe dot com> 
	--WTS[Krol Decapitator][Vitreous Beak of Julak-Doom][Pauldrons of Edward the Odd]cheapest on <buyboe dot com>
	--WTS[Gloves of Unforgiving Flame]order multiple lv378 epics to get a pet or 365 epic free on<buyboe dot com>. 
	--Free[Parrot Cage (Hyacinth Macaw)][Disgusting Oozeling][Masterwork Elementium Deathblade]on<buyboe dot com>. 
	--VK[Vial of the Sands]kauf mehr als 50k bekommt 20%-30% extra gold on <buyboe dot de>.
	--VK [Phiole der Sande][Theresas Leselampe][Maldos Shwertstock],25 Minuten Lieferung auf <buyboe(dot)de>
	"%[.*%].*buyboe.*dot.*[fcd][ro0e]", --WTS [Theresa's Booklight] [Vial of the Sands] [Heaving Plates of Protection] 15mins delivery on<buyboe dot com>
	"code.*hatchling.*card.*%d%d+[kg]", --WTS Codes redeem:6PETS [Cenarion Hatchling],Lil Rag,KT,XT,Moonkin,Pandaren 5k each;Prepaid gametimecard 6K;Flying mount[Celestial Steed] 15K.PST
	"%d+k.*card.*rocket.*deliver", --{rt6}{rt1} 19=10k,90=51K+gamecard+rocket? deliver10mins
	"%d%d+[kg].*g4pgold@com.*discount", --Speedy!10=5000G,g4pgold@com,discount code:Manager
	"%[.*%].*%[.*%].*facebook.com/buyboe", --Win Free[Volcano][Spire of Scarlet Pain][Obsidium Cleaver]from a simple contest, go www.facebook.com/buyboe now!
	"wts.*pets.*card.*mount", --WTS 6PETS [Cenarion Hatchling],Lil'Rag,XT,KT,Moonkin,Panda 8K each;Prepaid gametimecard 10K;Flying Mounts[Winged Guardian],[Celestial Steed]20K each.
	"wts.*pets.*mount.*card", --wts 6pets .mounts .rocket. gametimecard .Change camp. variable race. turn area. change a name. ^_^!
	"wts.*gametime.*mount.*pet", --WTS Prepaid gametime code 8k per month. the mount [Winged Guardian]'[Celestial Steed] 15K each and the pets 6k each, if u are interested,PST
	"wts.*mount.*pet.*card", --WTS {star}flying mounts:[Celestial Steed] and [Winged Guardian]30k each {star}PETS:Lil'Ragnaros/Lil'XT/Lil'K.T./Moonkin/Pandaren/Cenarion Hatchling 12k each,{star}prepaid timecards 15k each.{star}
	"wowhelp%.1%-click%.hu", --{square}Have a nice day, enjoy the game!{square} - {star} [http://wowhelp.1-click.hu/] - One click for all WoW help! {star}
	"g4p.*gold.*discount", --Saray Daily Greetings ? thanks for your previous support on G4P,here I am reminding you of our info, you may need it again :web:G4Pgold,Discount code:saray,introducer ID:saray 
	"wts.*rocket.*gametime", --WTS{rt3}"[X-53 Touring Rocket]&[Winged Guardian]&Celestial Steed&xt,kt,mo nk,cen.rag.moonkin and game time"{rt3}pst for more info.
	"$%d+=%d+k.*deliver.*item", --$20=10K, $100=57k,$200=115k with instant delivery,all lvl378 items,pst
	"money.*gold.*gold2sell", --Ingame gold for real money! Real gold for Ingame gold! Ingame gold for a account key! If you're intrested, then check out: "gold2sell.org" now!
	--w*w*w KB8G0LD c@m 6.99Eur0=10000G+10% Discount.Delivery 5Mins
	"kb8g[o0]ld.*%d+.*deliver", --KB8GOLD C0M 7.9€->10K Hot sales and Fast delivery
	--===3W K4Guild c0m 4.5 êúró=10k + 1O% Discóünt Fàst Délìvèry==== 
	"k4guild.*%d+.*d[éèe]+liv[éèe]+r", --w*w*w K4Guild c@m 6.99Eur0=10000G+10% Discount.Delivery 5Mins 
	"pet.*rag.*panda.*gametimecard", --Vends 6PETS [Bébé hippogriffe cénarien],Mini'Rag,XT,KT,Sélénien,Panda 12K each;payé d'avance gametimecard 15K;Bâtis volants[Gardien ailé],[Palefroi célest 
	"wts.*deliver.*cheap.*price", --WTS [Reins of Poseidus],deliver fast,cheaper price ,pst,plz 
	"%d+[/\\=]%d+.*gold4power", --?90=5oK Google:Gold4Power, Introducer ID:saray
	"wts.*mount.*rocket.*gift", --WTS 2 seat flying mount the X-53 Touring rocket , you can also get a gift--one month game , PST 
	"k{.*}4%.?{.*}g{.*}[o0]{.*}l{.*}d", --{star}.W{star}.W{star}W {square} k{triangle}.4{triangle}g{triangle}o{triangle}l{triangle}d {square} c{star}o{star}m -------{square}- c{star}o{star}d{star}e : CF \ CO \ CK
	"kb8g[o0]ld.*%d+.*st[o0]ck", --KB8GOLD com 8.5EUR = 10000,269K IN STOCK NOW!
	"reins.*vial.*%d+.*rocket", --WTS [Reins of the Crimson Deathcharger] [Vial of the Sands] [Reins of Poseidus],170usd=100k+a rocket for free
	"boe.*sale.*upitems", --wts [Krol Decapitator] we have all the Boe items,mats and 378 items for sale .<www.upitems.com>!!
	"wts.*rocket.*deliver", --WTSx-53 touring rocketinstant delivery,pst！！！！！
	"wts.*%[.*%].*$%d+.*%[.*%].*$%d+", --wts[Blauvelt's Family Crest]$34.00[Gilnean Ring of Ruination]$34.99[Signet of High Arcanist Savor]$34.90pst
	--@@@@@@ only 10K=5.99EURO 100K+10K=55.99EURO @@@@@@www luckygolds c@m @@@@@@
	"%d+k.*luckygolds", --@@@@@@@@@ www  luckygolds  c@m   only 10K=6.99EURO 100K+10K=65.99EUROwww  luckygolds  c@m @@@@@@@@@
	--@@@@@@ (www luckyg@lds c@m) @nl y_10K=5.99EUR@_100K+10K=55.99EUR(@=O)
	--@@@@@__www luckyg@lds c@m @nly_1oK=5.99EURO 1ooK+1oK=55.99EUR (@=o) 
	--vv vv vv  luckyg@lds  c@m  only l0K=5.99 � 1OO K+1O K=55.99 � (@=O)
	--vv vv vv  lùckygólds cóm  ónly  1O K=4.99 éùr    1OO K+1O K=45.99 éùr   10 mìn délìvéry (ó=O)(ù=U)
	"l[ùu]+ckyg[o@òóöōô]+lds.*[%do]+k", --@@@@@@@ www luckygolds c@m only 10K=5.99EURO 100K+10K=55.99EURO @@@@@@@ 
	--www K4power c@m.Lowest Price + 10% Free G.{Code:4Power}--
	"k4p[o0]wer.*%d+", --WWW K4POWER C0M {Code:Xmas}->>Xmas Promotions{18th Dec-26th Dec}->35% Free,0rder 50k More->X-53 Rocket Mount For Free!
	"sell.*rocket.*pet.*gametimecard", --sell  [X-53 Touring Rocket] &2mounts,6pets,gametimecard,CATA/WLK CD-key
	--WTS[Bladeshatter Treads][Splinterfoot Sandals][Rooftop Griptoes]&all 397 epic boot on <g2500 dot com>. 
	"wts.*%[.*%].*g2500.*com", --WTS[Foundations of Courage][Leggings of Nature's Champion]Search for more wow items on <g2500 dot com>. With discount code G2500OKYO5097 to order now.
	"g[o@òóöōô]+ld4rpg.*%d+k", --! vv w vv .Göld4RPG. c ö m Chóosë thè lêgal wëbsîte Chëapest Gôld,10K=13 USD,500K în Stôck> Dëlivëry in 7mins,--Chëap pôwer lëveling- Welcöme tö w vv w .Göld4RPG. c ö m disc?unt cöde : MEITBX *
	--10K=13.98For more items and for fast delivery,come toWWW.K4gg.C@M
	"%d+k.*deliver.*kk?4g", --revelry of christmas present10% code =Lucky11.5k=8.27GBP=9.53EUR=13.04USDdelivery within 5-10mins KK4g. COM
	"%d+k.*g[o@òóöōô]+ld85%.", --Chèápèst Gòld,10k=12 úsd,Dèlìvèry ìn 7 mìns,5% èxtrá fòr 15k+ òrdèr.Chèápèst wów Pòwèr Lèvèlìng --- Wèlcòmè tò w w w. Gòld85.cóm
	"%d+k.*s[áa]+f[èe]+4g[o@òóöōô]+ld", --Grèatèst Salè ónly 10k=10ùsd, Bùy Safèst,Fastèst,Chèapèst wòw gòld fróm safè4gòld .(dèlivery in5mins)Welcóme tovvwvv,safè4gòld ,còmanytime
	"k{.*}k{.*}4{.*}g%.c", --revelry of christmas present<circle>10% code =Lucky<circle>11.5k =7.58GBP=8.85EUR=12.11USD<circle>delivery within 5-10mins <triangle><triangle><triangle> K<cross>K<cross>4<cross>g. C<cross>O<cross>M
	"wts.*%[.*%].*good4game", --WTS[Blazing Hippogryph][Amani Dragonhawk][Big Battle Bear]buy TCG Mounts on good4game.c{circle}m
	--{triangle}{triangle}Chèapèst and safè Góld. 10K for $12 , with the discóunt códe:"GPS".10% èxtra góld of the órdèr 50K+. Wèlcome to <{star}w w w.mmóp.c ó m{star}>
	--{star}Dèàr èvèryonè,w w w.mmóp.c ó m{star}Chèàp and sàfè Góld,with thè discóunt códè:"gps",10K only for $ 14. 10% èxtra góld fór thè órdèr 50K+.{triangle} 
	"{.*}.*%.mm[o@òóöōô]+p%..*{.*}", --{moon}{moon}Dear friend,need gold ? Focus on <{star} WW W.mmop.C oM{star} > 10K only for 12USD,with the discount code:"GPS".
	"wts.*%[.*%].*%[.*%].*wealso.*cheapestg", --WTS [Reins of the Crimson Deathcharger] [Mechano-Hog] [Big Battle Bear]and we also have the cheapest G
	--@@@@@@@@@www.happygôlds.c@m.côm@@@@www.happygôlds.c@m.côm@<o=ô>@@@@10000G.ônly6.99EURô@@@@@@Lvl 397 items are on sale
	"happyg[o@òóöōô]+lds.*%d+[gk]", --@@@@@@@@@ www happygolds c@m @@@@@@@@@ www happygolds c@m @@@@@@@@@ 10000G.only 7.99 EUR @@@@@@@@@
	--@@@@@@vvvvvv wow4wow c@m only 1OK=4.99EUR 1OOK=45.99EUR 10 min delivery
	--vv~vv~vv wòw4wòw còm ónly 1O K=4.99èùr 1OO K=45.99èùr 1O min dèlivèry(ò=O) 
	"w[o@òóöōô]+w4w[op@òóöōô]+w.*d[éèe]+liv[éèe]+r", --@@@@@@@@ @nly 10K=5.99EUR@1OOK=55.99EUR@ www wow4wpw c@m` 10 min delivery
	"gold2store.*deliver", --vv vv vv gold2store c@m only 1OK=9.59 U S D 1OO K=99.99 U S D fast delivery (@=O)
	"mount.*sale.*c[0o]m", --New material and EPIC mount[Lavaquake Legwraps][Amani Dragonhawk]for sale on <gòldгμns dot c0m>, ome select what you want and enjoy generous bonus
	"discount.*order.*c[0o]m", -- we offer big discount on all orders[Essence of Destruction]<gòldгμns dot c0m>, your best shopping mall
	"deliver.*g[@o]ldw[@o]w2012", --$$ Lv 1-85=127EUR+7days $$ 397-410 professional equipment,TCG Loot card,rare mount $$ fast delivery within 24 horus $$ g@ldW@W2012 C@M $$
	"wts.*%[.*%].*cheap.*gold.*%d+%$", --WTS [Reins of the Swift Spectral Tiger] [Tabard of the Lightbringer]{rt3}{rt3}cheapest gold,110$=100k,pst with more offer,plz!!!!
	"ourgamecenter.*cheap.*fast", --WWW OurGameCenter C0M {diamond}{diamond} SAVE UP 30%, 10000=6.46 {diamond}{diamond} AND NEW MEMBER CAN GET 10% BONUS, GIVE YOU THE CHEAPEST & FASTEST!!! HAVE A GOOD TIME EVERYONE!!!
}

local fnd = string.find
local IsSpam = function(msg)
	for i=1, #instantReportList do
		if fnd(msg, instantReportList[i]) then
			if myDebug then print("Instant", instantReportList[i]) end
			return true
		end
	end

	local points, phishPoints = 0, 0
	for i=1, #whiteList do
		if fnd(msg, whiteList[i]) then
			points = points - 2
			phishPoints = phishPoints - 2 --Remove points for safe words
			if myDebug then print(whiteList[i], points, phishPoints) end
		end
	end
	for i=1, #commonList do
		if fnd(msg, commonList[i]) then
			points = points + 1
			if myDebug then print(commonList[i], points, phishPoints) end
		end
	end
	for i=1, #heavyList do
		if fnd(msg, heavyList[i]) then
			points = points + 2 --Heavy section gets 2 points
			if myDebug then print(heavyList[i], points, phishPoints) end
		end
	end
	for i=1, #heavyRestrictedList do
		if fnd(msg, heavyRestrictedList[i]) then
			points = points + 2
			phishPoints = phishPoints + 1
			if myDebug then print(heavyRestrictedList[i], points, phishPoints) end
			break --Only 1 trigger can get points in the strict section
		end
	end
	for i=1, #restrictedIcons do
		if fnd(msg, restrictedIcons[i]) then
			points = points + 1
			if myDebug then print(restrictedIcons[i], points, phishPoints) end
			break --Only 1 trigger can get points in the icons section
		end
	end
	for i=1, #phishingList do
		if fnd(msg, phishingList[i]) then
			phishPoints = phishPoints + 1
			if myDebug then print(phishingList[i], points, phishPoints) end
		end
	end
	if points > 3 or phishPoints > 3 then
		return true
	end
end

--[[ Chat Scanning ]]--
local gsub, orig, prevReportTime, prevLineId, result, prevMsg, prevPlayer = gsub, COMPLAINT_ADDED, 0, 0, nil, nil, nil
local filter = function(_, event, msg, player, _, _, _, flag, channelId, _, _, _, lineId)
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
	msg = (msg):lower() --Lower all text, remove capitals
	msg = gsub(msg, " ", "") --Remove spaces
	--They like to interchange Russian and English letters to avoid detection
	msg = gsub(msg, "а", "a") --\208\176 > \97
	msg = gsub(msg, "с", "c") --\209\129 > \99
	msg = gsub(msg, "е", "e") --\208\181 > \101
	msg = gsub(msg, "о", "o") --\208\190 > \111
	--Simple 'previous-line' anti-spam, check the previous line, filter if duplicate
	if msg == prevMsg and player == prevPlayer then result = true return true end
	prevMsg = msg prevPlayer = player
	--end check
	if IsSpam(msg) then
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
					StaticPopupDialogs["CONFIRM_REPORT_SPAM_CHAT"].text = REPORT_SPAM_CONFIRMATION .."\n\n".. gsub(debug, "%%", "%%%%")
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
	result = nil
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", filter)

ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", function(_, _, msg)
	--Function for disabling BadBoy reports and misc required functions
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

