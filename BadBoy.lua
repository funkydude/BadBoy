--[[	BLIZZARD IF YOU'RE READING THIS I'M BEGGING FOR YOUR HELP.
		Please let me fetch either player level from the given guid (will also help BadBoy_Levels)
		or let me fetch if the player is in a guild or not from the given guid (spammers never guilded)
		or both!

		I can then, 1) Skip scanning all chat from non-guilded WoW players, 2) skip scanning all chat from
		players above level 10, this would near enough eliminate any chance of false positives.
]]--

--DO NOT MODIFY DATABASE OR YOU MAY REPORT INNOCENT PEOPLE, HEURISTIC FUNCTION DEPENDS ON WORDS BEING ON CERTAIN LINES
-- GLOBALS: print, SetCVar, GetTime, gsub, ipairs, UnitInParty, UnitInRaid, UnitIsInMyGuild, ComplainChat, CanComplainChat, BNGetNumFriends, BNGetNumFriendToons, BNGetFriendToonInfo, GetRealmName
local myDebug = nil

--[[ Spam Recognition ]]--
local triggers = {
	--White
	"recruit", --1
	"dkp", --2
	"looking", --3 --guild
	"lf[gm]", --4
	"|cff", --5
	"raid", --6
	"roleplay", --7

	--English - Common
	"bonus", --8
	"buy", --9
	"cheap", --10
	"code", --11
	"coupon", --12
	"customer", --13
	"deliver", --14
	"discount", --15
	"express", --16
	"gold", --17
	"lowest", --18
	"order", --19
	"powerle?ve?l", --20
	"price", --21
	"promoti[on][gn]", --22
	"reduced", --23
	"rocket", --24
	"sa[fl]e", --25
	"server", --26
	"service", --27
	"stock", --28
	"well?come", --29

	--French - Common
	"livraison", --delivery --30

	--German - Common
	"billigster", --cheapest --31
	"lieferung", --delivery --32
	"preis", --price --33
	"willkommen", --welcome --34

	--Spanish - Common
	"barato", --cheap --35
	"gratuito", --free --36
	"r[\195\161a]+pido", --fast --37
	"seguro", --safe/secure --38
	"servicio", --service --39

	--Chinese - Common
	"金币", --gold currency --40
	"大家好", --hello everyone --41

	--Heavy
	"[\226\130\172%$\194\163]+%d+[%.%-]?%d*[fp][oe]r%d+%.?%d*[kg]", --42 --Add separate line if they start approx prices
	"[\226\130\172%$\194\163]+%d+%.?%d*[/\\=]%d+%.?%d*[kg]", --43
	"%d+%.?%d*eur?o?s?[fp][oe]r%d+%.?%d*[kg]", --44
	"%d+%.?%d*[\226\130\172%$\194\163]+[/\\=%-]%d+%.?%d*[kg]", --45
	"%d+%.?%d*[kg][/\\=][\226\130\172%$\194\163]+%d+", --46
	"%d+%.?%d*[kg][/\\=]%d+%.?%d*[\226\130\172%$\194\163]+", --47
	"%d+%.?%d*[kg][/\\=]%d+[%.,]?%d*eu", --48
	"%d+%.?%d*eur?o?s?[/\\=]%d+%.?%d*[kg]", --49
	"%d+%.?%d*usd[/\\=]%d+%.?%d*[kg]", --50
	"%d+%.?%d*usd[fp][oe]r%d+%.?%d*[kg]", --51

	--Heavy Strict
	"www[%.,{]", --52
	"[%.,]c%-?[o0@]%-?m", --53
	"[%.,]c{circle}m", --54
	"[%.,]c{rt2}m", --55
	"[%.,]cqm", --56
	"[%.,]net", --57

	--Icons
	"{rt%d}", --58
	"{star}", --59
	"{circle}", --60
	"{diamond}", --61
	"{triangle}", --62
	"{moon}", --63
	"{square}", --64
	"{cross}", --65

	--Phishing - English
	"account", --66
	"blizz", --67
	"claim", --68
	"congratulations", --69
	"free", --70
	"gamemaster", --71
	"gift", --72
	"launch", --73
	"log[io]n", --74
	"luckyplayer", --75
	"mount", --76
	"pleasevisit", --77
	"receive", --78
	"service", --79
	"surprise", --80
	"suspe[cn][td]", --81 --suspect/suspend
	"system", --82
	"validate", --83

	--hello![Game Master]GM: Your world of warcraft account has been temporarily suspended. go to  [http://www.*********.com/wow.html] for further informatio

	--Phishing - German
	"berechtigt", --entitled --84
	"erhalten", --get/receive --85
	"deaktiviert", --deactivated --86
	"konto", --acount --87
	"kostenlos", --free --88
	"qualifiziert", --qualified --89

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
	--GGRPG com от 25 за 1000  BL349 ЯД PayPal QIWI VISA|Master MoneyBookers. Доставка 5 мин. Ася 614 691 984, скайп Wowgoldall. ТК60 в наличии
	"ggrpg.*paypal.*visa", --GGRPG com from 25 per 1000 BL349 YaM PayPal QIWI VISA | Master MoneyBookers. Ships in 5 minutes. Icq 614691984, skype Wowgoldall. TK60 in stock
	--Золото от 24 р  за 1к  BL240+ Wowgoldsale . ru IСQ  2222-39 , на сайте онлайн чат, принимаем WM/ЯД/Visa/qiwi, ищем поставщиков
	"wowgoldsale.*i[сc]+q.*visa", --Gold from 24 p per 1K BL240 + Wowgoldsale. ru ISQ 2222-39, the site online chat, accept WM / YaM / Visa / qiwi, looking for suppliers
	--Сдам Г0лдец  по 25!  [Ася] 747661. [Скайп] y0b0b0 (через ноль))
	"г[0o]лдец.*ася.*y0b0b0", --Rent G0ld  to 25!  [Icq] 747,661. [Skype] y0b0b0 (through zero))
	--Продам картошку и другие овощи по 29-35 кило. Овощевик.рф (набирать кирилицей!) БЛ 400 - доверяйте только опытным фермерам!
	"продам.*овощевик%.рф.*фермерам", --Sell potatoes and other vegetables by 29-35 kilogramm. Ovoschevik.rf (typing Cyrillic!) BL 400 - trust only an experienced farmers!
	--[З0Л0ТО] сайт <INGMONEY.RU> От 25р Все виды оплат.Kонсультант на сайте. Участвуй в "супер акции" IСQ 44-27-99 Skype [INGMONEY.RU] Надежно!Набор поставщиков
	"ingmoney.*i[сc]+q.*skype", --[G0LD] site <INGMONEY.RU> from 25p All kind of payments.Consultant on site. Participate in a "super shares" ICQ 44-27-99 Skype [INGMONEY.RU] Reliably! There is a set of suppliers
	--[yellow star] [З0Л0ТО]-Лучшие цены на сайте [INGMONEY. RU]Любые виды оплаты.Безопасные способы выдачи.Участвуй в супер акции Ася 44-27-99 Скайп INGMONEY. RU
	"ingmoney%..*ася.*скайп", --[G0L0DO]-Best prices on the website [INGMONEY. RU]Any type of payments.Safe methods of extradition.Participate in the super stock Icq 44-27-99 Skype INGMONEY. RU
	--mmOney: продаём оплату на 1=15000г, 3=30000г или 6=55000г месяцев  за золото. Топ гильдиям возможна передача вперёд !!! Гарантии ! моментальная покупка !
	"оплату.*золото.*покупка", --mmOney: sell payment on 1 = 15000g, 3=30000g or 6 = 55000g months for gold. Top guilds can be sent ahead! Warranty! instant purchase!
	--Золотко от 49 \ Все типы оплаты \ Онлайн чат / Быстрая доставка \ Webmoney | Visa | Mc | Qiwi | Yandex | BL 400 | ICQ 5595777 | Mywowgold .ru
	--Проdaжа zoлотa от 44 dо 49. Большие зaпaсы. Быстpaя dосtавкa. Wмp Яд Bиза Мс Qiwi. ІCQ: 5595777 Sкyрe: mywowgоld.ru оnlіne-сhat MYWОWGOLD.RU
	"[Іi]+[сc]+q.*m[yу]+w[oо]+wg[oо]+ld%.", --Gold from 49 \ Any kind of payments \ Online chat / Fast delivery \ Webmoney | Visa | Mc | Qiwi | Yandex | BL 400 | ICQ 5595777 | Mywowgold .ru
	--Mywowgold.ru Проверенные фармеры представляют Золото от 24 Аккаунты с чарами 85го лвл от 1800р
	--[skull]Mywowgold.ru[skull] Лучшие фармёры предлагают [orange]Золото[orange] от 24 Персонажи 85го с катаклизмом от 1800р
	"m[yу]+w[oо]+wg[oо]+ld%..*фарм[ёе]+ры", --Mywowgold.ru Audited farmers represents the Gold from 24 Accounts with chars 85 lvl from 1800r
	--Продам по 50р. 50р-1к. Оперативная доставка, большие запасы, низкие цены. Сайт: [RPGdealer.ru] Чат на сайте, ICQ: 48 555 2474, Skype: [RPGdealer.ru] [220 BL WM] Аттестат продавца. Все виды оплат. Ищу поставщиков
	"%d+.*rpgdealer.*i[сc]+q", --I'm sell by 50r. 50r-1k. Prompt (quick) delivery, big resourses, low prices. Site: [RPGdealer.ru] Chat on site, ICQ: 48 555 2474, Skype: [RPGdealer.ru] [220 BL WM] Attestat of Seller's. Any kind of payments. Looking for supplier's
	--Продам монеты 44-49вмр, яд, QIWI, visa - 1000 любые суммы! Прокачка/продажа чаров! Ищу поставщиков! Персональный аттестат, сайт! Ася 222-041! Скайп firelordwow!
	"монеты.*%d+.*qiwi.*visa", --Sell coins 44-49wmr, yam (yandex money), QIWI, visa - 1000 any sums! Level up / Sale characters! Looking for supplier's! Personal attestat, site! ICQ 222-041! Skype firelordwow!
	--KingPeon.СОМ [от 40р - 1k] Ася:238021. Скайп: Scorpufas. Аттестат Продавца[BL 110] WM/Яд, Qiwi, Visa, Билайн/МТС и др. Моментальная передача. Онлайн-Чат на сайте.
	"kingpeon[%.,]c.*ася.*visa", --KingPeon.СОМ [from 40r - 1k] Icq:238021. Skype: Scorpufas. Attestat of Seller's[BL 110] WM/Yam, Qiwi, Visa, Beeline/MTS (both big Russian celluar country corporatrion) and etc. Instant transmission / transfer. Online-chat on site.
	--Продам [БОГАТСТВО]  50р  СКИДКИ. WM/яд/MC/Visa/QIWI IСQ 44-27-99 ,Skype [wow-g-Online] [BL 180] Надежно, просто, честно! Отвечаю в Асю, скайп! Ищу поставщиков.
	"%d+.*visa.*i[сc]+q.*wow%-g%-online", --I'm will sell [RICHNESS]  50r  SALES. WM/yam/MS/Visa/QIWI IСQ 44-27-99 , Skype [wow-g-Online] [BL 180] Надежно, simply, honestly! Replay in Icq, skype! Looking for suppliers.
	--Продам ГОЛД по 40 !!! Принимаю веб мани и яндекс деньги.
	"продам.*голд.*яндекс.*деньги", --I'm will sell GOLD by 40 !!! I'm accept web money and yandex money.
	--Продам Г по 35! Сделка с мейна. БЛ 67!!! Ася 747661 Скайп y0b0b0
	--Продам Г по 35! Сделка с мейна.Гарантии!  БЛ 67!!! Ася 747661 Скайп y0b0b0 или  в ПМ!
	"продам.*сделка.*ася", --I'm will sell G by 35! Deal from main's (character). BL 67!!! Icq 747661 Skype y0b0b0
	--Продаём голд 49р-55р за 1к. WoWMoney.гu. Visa/MC, WM, Я-Д, QIWI. BL 200+. Связь через iсq 38-48-29 или сайт.
	--Гoлд от 25р за 1к. WoWMоnеу.гu. Visа/MС, WМ, Я-Д, QIWI. BL210+. Связь через iсq 38-48-29 или сaйт.
	"w[oо]+wm[oо]+n[eе]+[yу]+[%.,].*vis[aа]+.*i[сc]+q", --We are sell gold 49r-55r for 1k. WoWMoney.гu. Visa/MS, WM, YA-M, QIWI. BL 200+. Connection through iсq 38-48-29 or site.
	--Nigmаz.соm - Зoлoтo всего по 53p за 1000. Получи до 11% в подарок! скидки постоянным клиентам. Быстро и удобно!
	"nigmаz[%.,]с.*%d+.*скидки", --Nigmаz.соm - Gold only by 53r for 1000. Receive to 11% to gift! Sales for permanent customer's. Quickly and comfortable!
	--Продам ЗОЛОТО недорого!!! От 35р за 1000!!! Оплата  Webmoney,ICQ 603388454.
	"золото.*money.*i[сc]+q", --Selling GOLD inexpensively!!! From 35r by 1000!!! Payment  Webmoney,ICQ 603388454.
	--продам голд 1к-40вмр
	"продам.*голд.*%d+", --i'll sell gold 1k-40wmr
	--mm0money предлагает оплату на 1-10к 3-20к, 6-30000г  месяцев, за игровую валюту !!! Колличество оплат ограниченно !!! Успей урвать долю счастья !!!
	"mm0money.*%d+.*валюту", --mm0money offers payment for 1-10k 3-20k, 6-30000g months, for gaming currency !!! Number of payment's is limited!!! Things to snatch a share of happiness!!!
	--онлайн магазин "Trader" - продажа золота, ключей Classic, BC, WoTLC,Cataclysm,тайм карт(руб/голд). Скупаем золото - дорого! BL146
	"продажа.*золота.*[сc]+купаем.*золото", --online shop "Trader" - sale of gold, keys Classic, BC, WoTLC,Cataclysm,time cards(rub/gold). We buy gold - it's expensive! BL146
	--СRАВВS-СОМРАNY.RU от [39-51р за 1к] Качественный сервис! любые суммы Все виды оплат. ICQ 24 74 84 Sкуре: WoW-Crabbs или в личку
	--СRАВВS-СОМР АNY.RU - [блестяшки] от 21р за 1000г. ICQ 24-74-84 Skуре: WoW-Crabbs BL 300 Услуги прокачки!
	"i[сc]+q.*wow%-crabbs", --СRАВВS-СОМРАNY.RU from [39-51r for 1k] Quality service! any sums All kind of payments. ICQ 24 74 84 Sкуре: WoW-Crabbs or PM
	--[www.marketgold.ru]  продажа золота 50р ВЫДАЧА СРАЗУ,ключи активации для игр,прокачка,любые способы оплаты,аттестат продавца,BL200+ онлайнчат  ICQ 315-025
	"marketgold%.ru.*i[сc]+q", --[www.marketgold.ru]  selling gold 50r ISSUANCE OF DIRECT,key's activation for games,level-up,any way's of payment's,attestat of seller's,BL200+ online chat  ICQ 315-025
	--Продажа  по 26рублей. (Nightfull-icq.ru/ICQ 811-563/BL 10.!
	"продажа.*рублей.*i[сc]+q", --Selling on 26rubley. (Nightfull-icq.ru/ICQ 811-563/BL 10.!
	--Продам монетки !! Гарантии,поручители  вебмани !
	"продам.*монетки.*вебмани", --Sell Coin!! Guarantees,sureties webmoney!
	--[ [GnomOptovik.ru] ] [ по 35р (от 100к по 30р)] [WM BL:250] [Безопасность и надёжность, Моментальная доставка] [ICQ:606667350, Skype:GnomOptovik, Чат на сайте]
	"gnomoptovik.*доставка.*i[сc]+q", --[ [GnomOptovik.ru] ] [by 35r (from 100k to 30R)] [WM BL: 250] [Safety and reliability, instant delivery] [ICQ: 606667350, Skype: GnomOptovik, chat on the website]
	--[orange] ЗОЛОТО 25р за 1к , без посредников . Персональный аттестат,мгновенная доставка,гарантии. ICQ - 603388454 или Skype - Kansas655
	"золото.*i[сc]+q.*skype", --GOLD 25p per 1k , without intermediaries. Personal passport, instant delivery, warrantys. ICQ - 603388454 or Skype - Kansas655
	--Пoкупaeшь больше - получаешь еще больше! Теперь до 30% бонус золота (31.5р / 1к)   - Nigmаz.сom
	"получаешь.*золота.*nigm[аa]+z", --Buy more - get more! Now up to 30% bonus gold (31.5r / 1k)   - Nigmaz.com
	--[orange] 23р за 1к , без посредников . Персональный аттестат,мгновенная доставка,гарантии. ICQ - 603388454 или Skype - Kansas655
	"доставка.*i[сc]+q.*skype", --[orange] 23r per 1k, without intermediaries. Personal passport,instant delivery,warrantys. ICQ - 603388454 or Skype - Kansas655
	--[orange]Монетки[orange] от 22. Аттестат продавца Webmoney BL100. Моментальная выдача, безопасная передача. Все виды оплат. ICQ 440-048-760; скайп: Ruszun; или пм
	"продавца.*i[сc]+q.*скайп", --[orange]Coins[orange] from 22. Certificate seller Webmoney BL100. Instant delivery, secure transmission. All types of payments. ICQ 440-048-760; skype: Ruszun; or pm
	--[orange] от 23.99 руб/к | [MMO-SHOP.RU] | Все виды оплат | BL WM 392+ | ICQ 94-94-70, skype: [mmo-shop.ru]  | Скупаем [orange] | ТК за 61 k [orange] | Крылатый страж в продаже
	"mmo%-shop%.ru.*i[сc]+q.*skype", --[orange] from £ 23.99 rub/k | [MMO-SHOP.RU] | all kinds of payments | BL WM 392 + | ICQ 94-94-70, skype: [mmo-shop.ru ] | We buy [orange] | TC for 61 k [orange]| Winged Guard for sale
	-->>> Nigmаz.сom - Золoтo всегда в наличии! Бoнус дo 30%!
	"nigm[aа]+z%.[сc]+.*наличии", -->>> Nigmaz.som - Zoloto always in stock! Bonus to 30%!
	--КупитьГолд.РФ [1k от 27р] Любые виды оплат, Быстрая доставка [BL 145+] Консультант на сайте. Ася: 238021. Skype: Scorpufas. Ищем поставщиков. +Прокачка, Маунты.
	"доставка.*ася.*skype", --BuyGold.RF [1k from 27R] Any type of payments, fast delivery [BL 145 +] Consultant on the site. Icq: 238 021. Skype: Scorpufas. We are looking for suppliers. + Leveling, Mounts.
	"night%-money%.ru.*i[сc]+q", --Mоnеты по цeнe пoстaвщиков. Пoкyпaйте у нaс - нe пeрeплачивaйтe. Всe виды oплaт. || Night-Money. Ru || Пoдaрки. ICQ 83-93-75. [70 BL WM] Аттeстат прoдaвцa. Онline-сhaт.
	"ollyvs%.ru.*i[сc]+q", --[ollyvs.ru] [От 37p до 27р за 1000г] [Webmоney,Kиви,Яндеkс,Visa,MC,На Моб счет и др.] BL200+ ICQ: 309765 Skурe: ollуvs или в личку
	--Маунты Огненный ястреб и Феникс пепел Ал'ара поступили в продажу в магазине-- [eubattlenet.vipshop.ru]
	"продажу.*eubattlenet%.vipshop%.ru", --Mount Fire Hawk and Phoenix Al'ara ashes are on sale at the store--[eubattlenet.vipshop.ru]

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
	"%d+.*items.*deliver.*k4gg", --10K=13.98For more items and for fast delivery,come toWWW.K4gg.C@M
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
	"%[.*%].*buyboe.*dot.*[cd][o0e]", --WTS [Theresa's Booklight] [Vial of the Sands] [Heaving Plates of Protection] 15mins delivery on<buyboe dot com>
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
	"k{.*}4%.?{.*}g{.*}[o0]{.*}l{.*}d", --{star}.W{star}.W{star}W {square} k{triangle}.4{triangle}g{triangle}o{triangle}l{triangle}d {square} c{star}o{star}m -------{square}- c{star}o{star}d{star}e : CF \ CO \ CK
}
local fnd = string.find
local IsSpam = function(msg)
	local points, phishPoints, strict, iconBlock = 0, 0, nil, nil
	for i=1, #triggers do --Scan database
		if fnd(msg, triggers[i]) then --Found a match
			if i>89 then --!!!CHANGE ME ACCORDING TO DATABASE ENTRIES!!!
				points = points + 9 --Instant report
			elseif i>65 and i<90 then
				phishPoints = phishPoints + 1
			elseif i>57 and i<66 and not iconBlock then
				points = points + 1 --Only 1 trigger can get points in the icons section
				iconBlock = true
			elseif i>51 and i<58 and not strict then
				points = points + 2 --Only 1 trigger can get points in the strict section
				phishPoints = phishPoints + 1
				strict = true
			elseif i>41 and i<52 then
				points = points + 2 --Heavy section gets 2 points
			elseif i>7 and i<42 then
				points = points + 1 --All else gets 1 point
			elseif i<8 then
				points = points - 2
				phishPoints = phishPoints - 2 --Remove points for safe words
			end
			if myDebug then print(triggers[i], points, phishPoints) end
			if points > 3 or phishPoints > 3 then
				return true
			end
		end
	end
end

--[[ Calendar Scanning ]]--
--[[
CURRENT ISSUE: remove/complain/reject functions seems to have a cooldown?
do
	local start = GetTime()
	--Maybe you could make this $#!+ easier to do please Blizzard?
	--Is...
	--for i=1, CalendarGetNumPendingInvites() do local title, player, desc, month, day, event = CalendarEventInfoPendingInvite(i) end
	--...too much to ask for?
	BadBoyConfig.CALENDAR_ACTION_PENDING = function(self)
		--Completely random chosen number to prevent lockup
		count = count + 1
		if count > 10 then
			self:UnregisterEvent("CALENDAR_ACTION_PENDING")
			--self.CALENDAR_ACTION_PENDING = nil
			return
		end
		local numInvites = CalendarGetNumPendingInvites()
		if numInvites == 0 then print("0 events, returning") return end
		local noUpdate
		local countedInvites = 0
		print("Lets begin")
		for m=0, 99 do
			for d=1, 31 do
				local numEvents = CalendarGetNumDayEvents(m, d)
				for i=1, numEvents do
					noUpdate = true
					if CalendarContextInviteIsPending(m, d, i) then
						CalendarContextSelectEvent(m, d, i)
						print("Found an invite:", m, d, i)
						countedInvites = countedInvites + 1
						--if CalendarContextEventCanComplain() then
							print("we can complain:", m, d, i)
							CalendarOpenEvent(m, d, i) --CalendarOpenEvent() also fires CALENDAR_ACTION_PENDING... /facepalm
							local _, msg, player = CalendarGetEventInfo() --msg is sometimes nil even after OpenCalendar() has updated and fired the event FFS
							if not msg then print("FAIL") return end --Usually becomes available after a few loops
							print(msg, player)
							--Msg is finally available, check all calendar events for spam and completely disable the functionality
							if IsSpam(msg) then
								--CalendarContextEventComplain(m, d, i)
								CalendarContextInviteRemove(m, d, i)
								OpenCalendar()
								print("|cFF33FF99BadBoy|r: Reported player '", player, "' for spamming your calendar with gold spam advertisements.")
							end
						--end
						--Don't loop further when we've checked all pending invites
						if countedInvites == numInvites then print("returning due to max invites") return end
					end
				end
			end
		end
		--We can't read calendar invites so force another update
		if not noUpdate then print"update" OpenCalendar() end
	end
	BadBoyConfig:RegisterEvent("CALENDAR_ACTION_PENDING")
end
]]

--[[ Chat Scanning ]]--
local orig, prevReportTime, prevLineId, result, prevMsg, prevPlayer = COMPLAINT_ADDED, 0, 0, nil, nil, nil
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

