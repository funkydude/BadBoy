
-- GLOBALS: BADBOY_BLACKLIST, BADBOY_OPTIONS, BadBoyLog, ChatFrame1, GetTime, print, ReportPlayer, CalendarGetDate, SetCVar
-- GLOBALS: GameTooltip, C_Timer, IsEncounterInProgress, GameTooltip_Hide
local L
do
	local _
	_, L = ...
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
	"mount",
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
	"store",
	"trusted",
	"well?come",
	"%d+k[\\/=]%d+euro",
	"%d+%$[\\/=]%d+g",

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
}

local boostingList = {
	"paypal",
	"skype",
	"b[o0][o0]st",
	"arena",
	"rbg",
	"gladiator",
	"service",
	"cheap",
	"fast",
	"safe",
	"price",
	"account",
	"rating",
	"legal",
	"guarantee",
	"m[o0]unt",
	"sale",
	"season",
	"professional",
	"experience",
	"customer",
	"discount",
	"selfplay",
	"coaching",
	"live",
	"mythic",
	"leveling",
	"accshar[ei]",
	"secure",
	"delivery",
	"store",
	"pri?est[ie]ge",
	"quality",
	"pil[o0]ted",
	"artifactpower",
	"unlock",
	"quantity",
}
local boostingWhiteList = {
	"members",
	"guild",
	"social",
	"|hspell",
	"%d+k[/\\]?dungeon",
	"%d+k[/\\]?each",
	"onlyacceptinggold",
	"goldonly",
	"goldprices",
	"forgold",
	"%d+kperrun",
	"tonight",
	"gametime",
	"servertime",
	"entrance",
	"%.battle%.net/",
	"recrui?t",
	"appl[iy]", --apply/application
	"enjin%.com",
	"guildlaunch%.com",
	"gamerlaunch%.com",
	"corplaunch%.com",
	"wowlaunch%.com",
	"wowstead%.com",
	"guildwork.com",
	"guildportal%.com",
	"guildomatic%.com",
	"guildhosting.org",
	"%.wix%.com",
	"shivtr%.com",
	"own3d%.tv",
	"ustream%.tv",
	"twitch%.tv",
}

--These entries remove -2 points
local whiteList = {
	"%.battle%.net/",
	"recrui?t",
	"dkp",
	"looking",
	"lf[gm]",
	"|cff",
	"raid",
	"scam",
	"roleplay",
	"physical",
	"appl[iy]", --apply/application
	"enjin%.com",
	"guildlaunch%.com",
	"gamerlaunch%.com",
	"corplaunch%.com",
	"wowlaunch%.com",
	"wowstead%.com",
	"guildwork.com",
	"guildportal%.com",
	"guildomatic%.com",
	"guildhosting.org",
	"%.wix%.com",
	"shivtr%.com",
	"own3d%.tv",
	"ustream%.tv",
	"twitch%.tv",
	"social",
	"fortunecard",
	"house",
	"join",
	"community",
	"guild",
	"progres",
	"transmor?g",
	"arena",
	"boost",
	"players",
	"portal",
	"town",
	"synonym",
	"[235]v[235]",
	"sucht", --de
	"gilde", --de
	"rekryt", --se
	"soker", --se
	"kilta", --fi
	"etsii", --fi
	"sosyal", --tr
	"дкп", --ru, dkp
	"peкpуt", --ru, recruit
	"нoвoбpaн", --ru, recruits
	"лфг", --ru, lfg
	"peйд", --ru, raid
}
local sites = {
	"prestigewow[%.,]c[0o]m", --prestige-wow
	"farm4gold[%.,]com",
	"dving[%.,]net",
	"speedruncharacter[%.,]net",
	"boosthive[%.,]eu",
	"leprestore[%.,]com",
	"1proboost[%.,]com",
	"hordebank[%.,]com",
	"justboost[%.,]net",
	"pvpok[%.,]c[0o]m",
	"boostila[%.,]com",
	"pewpewshop[%.,]pro",
	"perfectway[%.,]one",
	"demonboost[%.,]com", --demon-boost
	"bestboost[%.,]club",
	"bestboost[%.,]com", --best-boost
	"topboost[%.,]pro",
	"gamesales[%.,]pro",
	"mythicstore[%.,]com", --mythic-store
}

--Any entry here will instantly report/block
local instantReportList = {
	--[[  Casino  ]]--
	"%d+.*d[ou][ub]ble.*%d+.*trip", --10 minimum 400 max\roll\61-97 double, 98-100 triple, come roll,
	"casino.*%d+x2.*%d+x3", --{star} CASINO {star} roll 64-99x2 your wager roll 100x3 your wager min bet 50g max 10k will show gold 100% legit (no inbetween rolls plz){diamond} good luck {diamond}
	"casino.*%d+.*double.*%d+.*tripp?le", --The Golden Casino is offering 60+ Doubles, and 80+ Tripples!
	"casino.*whisper.*info", --<RollReno's Casino> <Whisper for more information!>
	"d[ou][ub]ble.*%d+.*tripp?le", --come too the Free Roller  gaming house!  and have ur luck of winning gold! :) pst me for invite:)  double is  62-96 97-100 tripple we also play blackjack---- u win double if you beat the host in blackjack
	"casino.*bet.*%d+", --Casino time. You give me your bet, Than You roll from 1-11 unlimited times.Your rolls add up. If you go over 21 you lose.You can stop before 21.When you stop I do the same, and if your closer to 21 than me than you get back 2 times your bet
	"roll.*%d+.*roll.*%d+.*bet", --Roll 63+ x2 , Roll 100 x3, Roll 1 x4 NO MAX BETS
	"casino.*roll.*double", --CASINO IS BACK IN TOWN COME PAY ME ROLL +65 AND GET DOUBLE
	"casino.*roll.*%d+.*roll.*%d+", --Casino is back in town !! Roll over 65 + and get your gold back 2X !!  Roll 100 and get your gold back 3X !!
	"double.*tripp?le.*casino", --Hey there wanna double your money in casino? or triple or even quad it? give me a whisp if you want to join my casino :)
	"casino.*legit.*safe.*casino", --LEGIT CASINO IN TRADE DESTRICT! /w * for a legit and safe casino!
	"luck.*roll.*%d+k.*minutes.*pst", --test your luck. all you gotta do is roll. make 1-100k+ in minutes. pst for details.
	"roll.*win.*double.*min.*max", --Game 2 Roll Wars. Trade wager then roll. We both rol. Highest Roll wins. If you win ill double your wager 500g Minimum 5k Maximum
	"casino.*/w.*%d+.*roll", --CASINO /W ME 50/50 ROLL

	--[[  Runescape Trading  ]]--
	--WTB RS gold paying WoW GOLD
	--WTT RS3 Gold to Wow Gold (i want wow gold) pm for info
	"wt[bst]rs3?gold.*wowgold", --WTB rs gold trading wow gold PST
	"wt[bs]wowgold.*rsgold", --WTS Wow gold for rs gold
	"wt[bs]wowgold.*rscoint?s", --WTS Wow gold for rs coints
	--WTS RUNESCAPE GOLD !~!~!~ PST
	--WTB RUNESCAPE GOLD WITH WOW GOLD PST
	"wt[bs]runescapegold", --WTB Runescape Gold, Trading WOW Gold, PST -- I will trade first.
	"exchangingrsgold", --Exchanging RS gold for WoW gold. I have 400m PST
	--WTS level 25 guild with 80k gold for runescape gold
	"goldforrunescapegold", --Exchanging WoW gold for Runescape gold pst me better price for higher amount.
	--Buying runescape account! :D Add me on skype "*"
	"buying?runescape[ag]", --buyin runescape g
	"wt[bs]runescapeaccount", --WTB runescape accounts ( pure only ) or money! i pay with wow gold. GOT 170k gold atm.
	"wt[bs]runescapepure", --WTB runescape pure ( STR PURE IS A $$ PAYING EXTRA FOR STR PURE )!
	--WTB big amount of runescape money. 2mil = 1k gold. ONLY LEGIT PEOPLE.
	"wt[bs].*runescapemoney.*%d+k", --WTB runescape money. 3mil = 1k in wow! easy money making.
	"^wt[bs]rsaccount", --wts rs acount 10k .... lvl 95 with items for over 15 mil with 6 year old holiday
	"^wt[bs]%d+rsaccount", --WTS 137 RS ACCOUNT /W ME
	--WTS awesome rs account with 99's /w me
	--WTS an awesome rs account /w me details
	"^wt[bs]a?n?awesomersaccount", --wts awesome rs account /w me
	"runescapegoldforwowgold", --Selling my runescape gold for wow gold
	"^buyingrs3stuff", --Buying RS3 stuff for gold

	--[[ CS:GO ]]--
	"^wt[bst]somecsgoskin", --WTB some CSGO skins and sell some /w for more info
	--WTS CS:GO Skins
	--WTB CS.GO SKINS/KEYS FOR GOLD!
	"^wt[bst]cs%.?goskin", --WTB CS GO skins /w for more infomation
	"^wt[bst]csgokey", --{rt1} WTB CS:GO KEYS & SKINS FOR GOLD {rt1}
	"^wt[bst]csgoacc", --WTS CS GO ACC UNRANK
	"^wt[bst]csgokni[fv]e", --WTSCS GO knife M9 Bayonet Stained in (minimal wear) /w and give me offer
	"^wt[bst]csgoitem", --WTB CS:GO Items for Gold! /W me your items!!
	"^wt[bst]csgocase", --WTB Cs Go Case keys or a Knife .
	"^wt[bst]anycsgoskin", --{rt1} WTB ANY CS:GO SKINS FOR WOW GOLD {rt1}
	--{rt1}{rt8} Buying cs.g0 skins {rt8} {rt1}
	"^buyingcs%.?g[0o]skin", --{rt1}{rt3} Buying CS:GO Skins & Keys for WoW Gold | Paying good  {rt3}{rt1}
	"^buyingcheapcsgoskin", --Buying cheap CS:GO skins (1-5 eu each) I can go first!
	"^buyingcsgokey", --{rt3}Buying Cs:Go Key's for {rt4}4k{rt4} Per key! Buying high amount! Whisper for more information!{rt3}
	"^buyingcsgokni[fv]e", --Buying CS:GO Knives and Skins! Trusted trader with feedback! /w me for more info. Serious people only please.
	"^sellingcsgoskin", --Selling CS:GO skins for wow gold!
	"^sellingsomecsgocase", --Selling some CS:GO cases! PM ME!
	"^sellingcsgocase", --Selling CS:GO cases! PM ME!
	"^sellingcsgoitem", --{rt1} SELLING CS GO ITEMS FOR GOLD {rt1}
	"^wt[bst]csskins", --wtb cs skins /w me what u have 300k +
	"^wt[bst]keysincsgo", --WTB Keys in CS:GO for 3k each!
	"wanttobuy[/\\]sellcsgoitem", --Want to buy/sell CS:GO items whisper me for more information :)
	"wanttosell[/\\]buycsgoitem", --Want to sell/buy CS:GO items for wow gold, whisper me for more information :)
	"wowgoldforcsgokey", --{rt6} Want to trade WoW Gold for CS:GO Keys  Whisper me for more info!! / Swish till svenskar {rt6}
	"^wt[bst]csgocamo", --WTS CS:GO CAMOS
	"^wt[bst]cheapcsgoskin", --WTB CHEAP CS:GO SKINS /W ME !
	"^wt[bst]csgocdkee?y", --WTB CS GO CD KEEY PAY GOLD AND GOOD WISP ME YOUR OFFER WTB CS GO KNIFE SKINS
	"^tradingcsgo.*gold", --Trading Cs:GO Knife for Gold /w me for more information!!!
	"^wt[bst]csgocheap", --WTB CS GO CHEAPS BELOW 5 EURO WITH WOW GOLD!
	"^wt[bst]goldforcsgo", --WTS gold for cs:go knife, i will pay good if its  a good one, add me and /w if you are intrested
	"^wt[bst]mywowgold.*csgoskin", --WTT: My WOW Gold for your CSGO Skins. Offer 3k per 1€ skin value. No selling, Just trading! /w me for a chat.
	"^sellinggolds?forcsgo", --Selling golds for CS:GO skins !!
	"^wt[bst]csgosteamgift", --WTB CS GO STEAM GIFT  (it cost 8.36 EUROS) FROM G2A FOR GOLD AND I'M OFFERING A GOOD PRICE !!!

	--[[ SC 2 ]]--
	"^wtsstarcraft.*cdkey.*gold", --WTS Starcraft Heart of Swarm cd key for wow golds.

	--[[  Dota 2 ]]--
	"^sellingdota2", --Selling 2 Dota2 for wow gold! /W me
	--wtt dota 2 keys w
	--wts dota 2beta key 10k
	"^wt[bst]dota2", --WTB Dota 2 hero/store items,/W me what you have
	"^buyingdotaitems", --buying dota items w/Me i got  [Ethereal Soul-Trader] [Jade Panther] :)
	"^buyingdota2", --buying dota 2 skins w/me
	"^wt[bst]alldota2", --WTB ALL DOTA 2 SKINS W/ME <3

	--[[  Steam  ]]--
	"^wtssteamaccount", --WTS Steam account with 31 games (full valve pack+more) /w me with offers
	"^sellingborderlands2", --Selling Borderlands 2 cd-key cheap for gold (I bought it twice by mistake. Can send pictures of both confirmations emails without the cd-keys, if you dont trust me)
	"^wtssteamwalletcode", --WTS Steam wallet codes/CS GO skins /W

	--[[  League of Legends  ]]--
	"^wt[bs]lolacc$", --WTB LoL acc
	"^wt[bs]%d?x?leagueoflegends?account", --WTS 2x League of Legend accounts for 1 price !
	--WTT My LoL Account for WoW gold, Its a platiunum almost diamond ranked account atm on EUW if u want more information /w me
	"^wt[bst]m?y?lolaccount", --WTS LOL ACCOUNT LEVEL 30 with 27 SKINS and 14k IP
	"^sellingloleuw?acc.*info", --Selling LOL EUW acc pm for more info
	"^wt[bs].*leagueoflegends.*points.*pay", --WTB 100 DOLLARS OF LEAGUE OF LEGENDS RIOT POINTS PST. YOU PAY WITH YOUR PHONE. PST PAYING A LOT.
	"wts.*leagueoflegends.*acc.*info", --{rt1}wts golden{rt1} League of Legends{rt1} acc /w me for more info{rt1}
	"sellingm?y?leagueoflegends", --Selling my league of legends account, 100 champs 40 skins 2-3 legendary 4 runepage, gold. /EUW /W
	"^wt[bs]lolacc.*cheap", --WTS LOL ACC PLAT 4 1600 NORMAL WINS, EUW 40 SKINS, 106 CHAMPS  CHEAP!!
	"^wt[bs]lolacc.*skins", --WTS LoL acc level 30 EUW name ** got about 50 skins /w me for info include 3200 RP!
	"^wt[bst]mygold%d*leagueoflegends", --WTT My Gold 3 League of Legends account for some sick CS:GO skins! 116 Champions, 158 Skins, 6 rune pages. /w me for more info/skype!
	"^sellingwowgoldforleagueoflegends", --SELLING WOW GOLD FOR LEAGUE OF LEGENDS RP! /W ME
	"^wt[bs]lolacc.*gold", --WTB lol acc for gold here w/me

	--[[  Account Buy/Sell  ]]--
	"selling.*accounts?forgold", --Selling Spotify,Netflix Accounts for gold!!! /w me
	"wtsnonemergeacc.*lvl?%d+char", --!WTS none-merge acc(can get a lv80 char)./W me for more info!
	--! WTS lvl 80 char.{all class}.Diablo3 g0ld /W me for more info !
	--^{diamond}lv80 char all class./w me for more info if you WTB^
	"lvl?%d+char%.?allclass.*info", --^{Square} WTS lvl 80 char all class ! /w me for more info{square}^
	"lvl?%d+char.*fast.*g[o0]ld", --# WTS lvl 80 char .TCG mount.cheap fast D3 g0ld/w me for more #
	"%d+lvloldaccounts?tosell", --80lvl old account to sell
	"wtswowaccount.*epic", --y WTS WOW ACCOUNT 401 ITEM LEVEL ROGUES WITH FIRST STAGE LEGENDARY FULL CATA!! WITH 1X VIAL OF SANDS/CRIMSON DEATHCHARGER FULL EPIC GEMED 1X ROGUE 1 X WARRIOR PVP AIMED ADD SKYPE * AND I ALSO HAVE FULL HIERLOOM FOR EVER SINGLE CHARACTER A
	"^wanttotradeaccount", --Want to trade account full cata rogue on * with full epic 50 agil gems(vial of the sands and crimson dk and warrior with 1 cata and mechanohog it is on * wt t for a class with full cata on * /w me!!!!!
	"^wttacc.*epic.*mount.*/w", --WTT ACC MINE HAS FULL CATA+FULL EPIC GEMS  ROGUE WITH NICE MOUNTS WTT FOR AND ACC WITH FULL CATA  RESTO SHAMAN!! /W ME!!
	"^wttacc?ount.*gear.*char", --WTT Acount Resto/Enha shaman / Resto / Balance druid / Prot warr / Mage / Paladin for just one full cata geared pvp character /w me with info
	--WTS wow account 85human Rogue with LEGENDARIES + JC BS.  u pay with gold./w me for more info
	"^wt[st]wowaccount", --WTT Wow account /w me for more info
	"^wt[bs]mopcode", --WTS MoP Code /w me for info
	"^wttaccountfor.*youget.*tier", --WTT Account for a 90 tier 1 ROGUE, you get 90mage(tier1)90druid (tier1) 85 priest, 85 rogue, 85 warrior /wme
	--WTS ACCOUNT with 90 rogue, and 90 priest for gold /wme
	--WTS Account with free lvl 80 And GAME  TIME!! /w me
	"^wt[st]accountwith", --WTT ACCOUNT with 90 mage(TIER1) 90 Feral (TIER1) 85 priest, 85 warrior, 85 rogue for 90 ROGUE with TIER 1/wme
	"^wt[bst]legionkey", --WTS Legion key for gold
	"^wt[bst]legioncdkey", --WTS Legion CD-Key for gold!

	--[[  Brazzers, yes, really...  ]]--
	"sell.*brazzersaccount.*info", --Hey there! I'm here to sell you Brazzers account /w me for more info!
	"^wtsbrazzersaccount", --WTS BRAZZERS ACCOUNT UNLIMITED TIME /W OFFER

	--[[  Diablo 3  ]]--
	"^wttrade%d+kgold.*diablo", --WT trade 6k gol;d for 300k in diablo 3. /w me
	"^wttwowgold.*diablo", --WTT wow gold for diablo gold. /w if interested.
	"^wtbd3forgold", --WTB D3 for gold!
	--SELLING DIABLO 3 / 60 DAYS PREPAIDGAMECARD - PRICES IN DND!! CHEAP
	"^sellingdiablo3", --Selling Diablo 3 CD Key.Fast & Smooth Deal.
	"^sellingd3account", --Selling D3 account cheap /w for more !
	"^wtscheapfastd3g", --*WTS cheap fast D3 G,/W for skype*
	"^wt[bs]d3key", --WTs D3 key Wisp me for info and price!
	"^wts.*%d+day.*diablo.*account", --WTS [Winged Guardian] [Heart of the Aspects] [Celestial Steed]Each 22k gc90days=30Kdiablo III Account for=70k
	"tradediablo3?goldforwowgold", --anyone want to trade diablo gold for wow gold?
	--SELLING 60 DAYS GAMECARD - VERY CHEAP - ALSO SELL DIABLO ! -SAFE
	"^selling.*gamecard.*diablo", --SELLING 60 DAY GAMECARDS & DIABLO 3!!!!
	"^wt[bs]d3account", --WTS D3 account /w for more !
	"^wtsd3.*transfer.*item", --WTS D3/faction/race change server transfer and other items!
	--WTS Diablo 3 code 30 K !!
	--WTS Diablo 3 CD KEY
	--WTB Diablo 3 key cheap
	--WTB Diablo3 Gold for WoW Gold! /w me D3Gold per WoWGold!
	"^wt[bs]diablo3", --WTB Diablo 3 Gold!
	--WTB WOW GOLDS WITH D3 GOLDS ASAP
	"^wt[bst]wowgold.*d3gold", --WTT Wow Gold For D3 Gold! /w me with your price!
	--{rt1}{rt1}{rt1}WTT my WoW gold for your D3 gold. EU softcore. MSG.
	"wowgoldfory?o?u?r?d3gold", --T> My WoW gold for D3 gold
	--T> My WoW gold for Diablo 3 gold
	--Trading My WoW gold for Diablo 3 gold
	"wowgold.*fordiablo3?gold", --T> My WoW gold (15,000g) for Diablo 3 gold
	"tradediablo3?gold.*wowgold", --LF someone that wants to trade diablo 3 gold for my wow gold
	"^wt[bs]diablogold", --wtb diablo gold for wow gold!
	"trading.*fordiablo3?gold", --TRADING LVL 25 GUILD FOR DIABLO GOLD!!!!!!!!!!!!!
	"diablogoldforwowgold", --WTT my diablo gold for wow gold
	--WTT D3 gold to WoW gold! /w me!
	--WTT 270mil D3 gold to WoW gold! /w me!
	"^wt[bst].*d3gold.*wowgold", --WTB d3 golds for wow golds !
	"^wtt.*mygold.*diablo3gold", --WTT all my gold, 8783g for about 30m Diablo 3 gold, any takers?
	"wowgoldforyourdiablo3?gold", --{rt1}Looking to trade my 10k wow gold for your diablo 3 gold, we can do in trades as low as 0.5k wow gold at a time for safety reasons{rt1}
	"wts.*diablo3goldfor%d+", --wts 150 mill Diablo 3 gold for 50k

	--[[ Items ]]--
	"^wtscheapgold", --WTS cheap gold /w me for more info
	"^wtscheapandfastgold", --WTS cheap and fast gold ( no chineese website) /w me for more info
	"^wtbgold.*gametime", --WTB GOLD, OR TRADE GOLD FOR GAMETIME!!
	"^wtbgold.*mount", --WTB Gold paying decent(also TCG pets,mounts)/w me!
	"^wt[bs]gametime", --WTS {rt1} GAMETIME {rt1} {rt8} MoP Upgrade{rt8}
	"^wt[bs]prepaidcard", --WTS prepaid card (30,60,90 days), mounts
	"^wt[bs]gamecard", --WTB GAME CARD
	"^wt[bs]gamecode", --wtb game codes
	"^wt[bs]prepaidgamecard", --WTS *Pre-Paid Game Card 60 Days* - Can prove I've got loads in stock /w me offers
	"^wt[bs]%d+day.*gamecard", --WTS 60 DAYS PREPAID GAMECARD
	"^wt[bs]%d+month.*gametime", --WTS 2 Month(60Days) Gametime-Cards w/ me ! {rt1}
	"^wt[bs][36]0days?prepaidgametime", --WTS 60day Prepaid Gametime  Card and WOD
	"^wts%d+days?gametime", --wts 60 days gametime cde. and more stuff from blizzstore
	"^wts%d+days?gamecard", --wts 60 days game card /w me
	"^wts%d+kfor%d+eu", --WTS 950K FOR 35EURO(PayPal) /w me !
	"wts%d+kgoldfor%d+eu", --WTS 800k GOLD FOR  35 EURO NOW !

	--[[  2016  ]]--
	"titaniumbay.*extra", ---= TitaniumBay =- Get 10 % extra {rt2}! Fast and safe delivery!
	"titaniumbay.*livraison", ---= TitaniumBay =- Obtenez 10% supplémentaire! Livraison rapide et sûr!
	"titaniumbay.*obtenez", --TitaniumBay - Obtenez 40% plus d'or en 15 min! le plus fameux et valeureux de la ville!
	"titaniumbay.*minut[eo]", --TitaniumBay - Erhalten Sie 40% mehr Gold in 15 Minuten! Das beste Angebot in der Stadt!
	"titaniumbay.*gold", -- -= TitaniumBay =- Get up to 30% more gold compared to WoW Token
	"titaniumbay.*gratis", ---= TiвtaniumBay =- Oferta Limitada >> Obtenga el 50% extra oro Gratis!
	--WTS [Keystone Conqueror] (2-10lvl) ►ŠELFPLĄY◄ Teâm Is Reâdy To Gø Right Nøw! ŠKYPĒ: FindGuys
	"skype.*findguys", --Hello. Im sorry but I cant write here all prices. For all info and prices please add me in Skype: FindGuys
	"wts.*help.*mythic.*dungeon.*gear.*info", --█ WTS █ Help with Heroic and Mythic dungeon runs and full gear - running today! /w me for info
	"wts.*le?ve?ling.*power.*farming.*info", --█ WTS █ Level 100-110 Character Leveling and Artifact Power farming - get your character ready for raiding! /w for more info
	"wts.*spot.*heroic.*raid.*loot.*spec.*invite", --█ WTS █ SPOTS in Emerald Nightmare Normal/Heroic raid next week, all loot for your spec is yours. /w to get invited!
	"wts.*help.*honor.*prestige.*season.*info", --█ WTS █ Help with PvP Honor or Prestige levels and PvP Rewards today - season is starting soon! /w for info
	"selling.*glory.*fast.*stress.*ilvl.*info", --█ Selling █ Glory of the Legion Hero - get your Leyfeather Hippogryph fast and with no stress! No ilvl requirements - /w for info
	"loot.*piloted.*today.*%d%d%d%d.*whisper", --WTS: ▌▌THE EMERALD NIGHTMARE 7/7 (MYTHIC) ▌▌LOOT RUN ▌▌ SELFPLAY/PILOTED ▌▌MASTER LOOT ▌▌TODAY 21:00 CET▌▌Whisper me! ▌▌
	"loot.*piloted.*now.*discount.*whisper", --WTS:  ▌▌ TRIAL OF VALOR 3/3 (HEROIC) ▌▌LOOT RUN ▌▌SELFPLAY/PILOTED ▌▌MASTER LOOT ▌▌RIGHT NOW! ▌▌ DISCOUNT for CLOTH, MAIL and PLATE! ▌▌ Whisper me! ▌▌
	--WTS: ▓▓ XAVIUS (HEROIC) KILL ▓▓ PERSONAL LOOT ▓▓ SELFPLAY/PILOTED ▓▓ TODAY 00:00 CET ▓▓ SUPER PRICE! Whisper me! ▓▓
	"loot.*piloted.*%d%d%d%d.*price.*whisper", --WTS: ▓▓▓▓HELLFIRE CITADEL: 13/13 (MYTHIC)! ▓▓MASTER LOOT, PILOTED!▓▓TOMORROW 20:00 CET▓▓ 100% SAFE! NEW SUPER PRICE! Whisper me! ▓▓▓▓▓▓▓▓
	"wts.*arena.*rbg.*rating.*loot.*info", --WTS Arena/Rbg ratings 1800-2400 , WTS 7/7HC emerald lootrun /w for info
	"wts.*dungeon.*fast.*prestige.*emerald.*info", --[WTS] <<New Mythic/Heroic Dungeons>> | <<Artifact farm>> | <<Fast 100-110>> | <<Honor & Prestige Leveling>> | Emerald Nightmare Normal/Heroic/Mythic Raids and more. /W for more info
	"wts.*fast.*dungeon.*rbg.*emerald.*info", --[WTS] <<Fast 100-110>> | <<New Mythic/Mythic+ Dungeons>> | <<Honor/Prestige leveling>> | <<RBG Wins> || Emerald Nightmare Normal/Heroic/Mythic Raids and more. /W for more info
	"wts.*fast.*dungeon.*pvp.*emerald.*info", --[WTS] <<Fast 100-110>> | <<New Mythic/Heroic Dungeons>> | <<Full Dungeon Gear>> | <<Full PVP Gear>> || Emerald Nightmare Normal/Heroic/Mythic Raids and more. /W for more info
	"wts.*character.*dungeon.*pvp.*emerald.*info", --[WTS] <<Character ↑↑ 100-110 ↑↑ lvl>> | <<New Mythic/Heroic Dungeons>> | <<Full Dungeon Gear>> | <<Full PVP Gear>> || Emerald Nightmare Normal/Heroic/Mythic Raids and more. /W for more info
	"wts.*lift.*dungeon.*pvp.*emerald.*info", --<<Character lift 100-110 lvl>> | <<New Mythic/Heroic Dungeons>> | <<Full Dungeon Gear>> | <<Full PVP Gear>> || Emerald Nightmare Normal/Heroic/Mythic Raids and more. /W for more info
	"wts.*boost.*dungeon.*pvp.*emerald.*info", --[WTS] <<Character boost 100-110 lvl>> | <<New Mythic/Heroic Dungeons>> | <<Full Dungeon Gear>> | <<Full PVP Gear>> || Emerald Nightmare Normal/Heroic/Mythic Runs and more. /W for more info
	"wts.*le?ve?ll?i?n?g?.*dungeon.*pvp.*emerald.*info", --[WTS] <<Character leveling 100-110 lvl>> | <<New Mythic/Heroic Dungeons>> | <<Full Dungeon Gear>> | <<Full PVP Gear>> || Soon Emerald Nightmare Runs and more. /W for more info.
	"selling.*rbg.*honor.*mount.*selfplay", --██Selling RBG 1-75wins(honor rank/Priestige),40/75wins mounts [Vicious War Trike] and  [Vicious Warstrider]self play,PST
	"selling.*mount.*honor.*gear.*accshare.*", --selling 1-75winsEarn mount +honor rank+ priestige/legendary gears 6vicious mount  ;also selling[Vicious War Trike]and[Vicious Saddle]},no acc share .PST
	"rbg.*artifact.*mount.*accshar", --▓▓WTS RBGs,1-75wins(get HR and artifact power and 6vicious mounts)[Vicious War Trike]and[Vicious Saddle]right now,no accshare▓PST
	"heroic.*amazingprice.*strong.*group.*gua?rantee.*drop.*spot", --Wts Emerald nightmare Heroic 7/7 clear for amazing price with strong guide groupe we gurantee you Full heroic loot that drop for your class on tonight 19:00 st only 2 spots ! w me for more infos.
	"wts.*tonight.*arena.*rbg.*mythic.*coaching", --WTS Emerald Nightmare 7/7 MYTHIC with ML tonight , 1 spot for now / Arena/RBG/Mythics/Coaching /w for info
	--Legion 139Toman Game Time 30Toman Gold har 1k 450Toman Level Up ham Anjam midim |Web: www.iran-blizzard.com  Tel: 000000000000
	"legion.*gametime.*iranblizzard[%.,]com", --Legion 140T - Game Time 30Day 35T - 60Day 70Toman - www.iran-blizzard.com
	--=>>[www.bank4dh.com]<<=19E=100K. 5-15 mins Trade. More L895   Gears for sale!<<skype:bank4dh>> LVL835-870 Classpackage  Hot Sale! /2 =>>[www.bank4dh.com]<<=
	"bank4dh.*skype", --=>>[www.bank4dh.com]<<=32U=100K. 5-15 mins Trade. More More cheapest   Gears for sale!<<skype:bank4dh>> LVL835-870 Classpackage  Hot Sale! Buy more than 200k will get 10%  or [Obliterum]*7 or  [Vial of the Sands]as bounes   [www.bank4dh.com]
	"bank4dh.*%d+k", --=>>[www.bank4dh.com]<<=19E=100K. 5-15 m
	"trusted.*bank4dh", --WTS BOE class set, 860 Six-Feather Fan, Best BOE gears for rading and alt [lvling.Trusted] seller,K+ feedback from OC. Plz vistor www bank4dh com Cheaper than AH.
	"wts.*mythic.*powerle?ve?l.*glory.*info", --▲ WTS RUN in Emerald Nightmare (Normal or heroic) TODAY ▲ Mythic+ ▲ Power leveling 100-110 ▲ All Glory ▲ we have a lot runs every day ▲ and more other ▲ /W for more information ▲
	"rbg.*mount.*prestige.*accshare", --███WTS RBG40&75wins/Vicious Saddle/all 6 vicious mounts/honor rank/prestige[Vicious War Trike]and[Vicious Warstrider]no acc share,carry right now/w me
	"mythic.*boostinglive.*faster", --Mythic dungeons, Heroic raids, and more on [boostinglive.com] !Dress up your character faster than others!
	"koroboost.*everyday.*mythic", --Top guild "Koroboost" inviting you everyday from 1:00 pm CET  to mythic/mythic + dungeons. Became [Brokenly Epic] within 4 hours. Msg me!
	"doyouwant.*level110.*12h.*noproblem.*msgme.*info", --Do you want [Level 110] within 12h? No problem, Msg me for info ♥♥
	"rbg.*artifact.*honor.*mount.*carry", --█░█WTS RBG 1-75wins(Artifact Power+Honor Rank)6Vicious mount[Vicious Saddle]also[Reins of the Long-Forgotten Hippogryph]carry u right now ▲PST
	"^wtspowerleveling.*fast", --WTS Powerleveling (Fastest available)
	"fast.*leveling.*honor.*в[o0][o0]st", -- ►►►Fastest leveling 100-110 (6-12 hours), 850+ gear, Honor Ranks and MUCH MORE on [RРD-В00SТ,С0М]◄◄◄
	"^wtsmythickarazhandungeons[,.]*whispme", --WTS Mythić+ & Kârazhan Dungeøns. Whísp me.
	"^wtskarazhanboost[,.]mythic.*mythicdungeons?boost.*info", --WTS Karazhan boost, Mythic+ CHEST RUN, Mythic dungeons boost. /w for info
	"^wtskarazhan[,.]mythic.*mythic+dungeon$", --WTS karazhan. mythic and mythic+ dungeon
	"^wtsboostkarazhan[,.]mythic[,.]mythicdungeon", --WTS boost karazhan. mythic. mythic+ dungeon
	"^wtskarazhan.*,mythic.*mythicdungeons?boost$", --WTS Karazhan,Mythic+,10/10Mythic dungeon boost
	"rbg.*boost.*2200.*yourself.*account.*sharing.*info", --{RBG PUSH} Wts RBG Boost /1800/2000/2200/HOTA . You play yourself/NO account SHARING /w for more info  :)
	"rbg.*honor.*priestige.*mount.*selfplay", --WTS RBG 1-75wins(honor rank/Priestige),6RBG mounts[Vicious Saddle]and BOP mount[Reins of the Long-Forgotten Hippogryph]},self play .PST
	"powerle?ve?l.*yourspuregame[,.]com", --EN Myth/HC lootRuns,Karazhan,Powerlevling,Mounts,Myth+Boosting and more in >>> www.yourspuregame.com <<<
	"xperiencedparty.*runs.*walkthrough.*mythic.*glory.*karazhan", --xperienced party 880+ (more than 45 runs) will help you to walkthrough mythic, mythic+, Glory of the Legion Hero, Karazhan.
	"wh?isp.*skype.*igor.*price", --Wisp in Skype [] for Detal/Prices.
	"elitistgaming[,.]com.*mount", --Elitist-gaming,com Selling Emerald Nightmare on ALL difficulties, [Ahead of the Curve: Xavius]MYTHIC + dungeons and NIGHTBANE MOUNT, all self play  & more whisper for schedules
	"juststarted.*leveling.*twink.*gear.*dungeon.*more", --● Just Started The Legion or leveling a twink ? Need To Gear Up ? Try Our Karazhan, Emerald Nightmare N/HC/M, Dungeons+ Runs and More ●
	"wts.*saddle.*carry.*hour.*start.*info", --█ [WTS] Vicious saddle. 100 3v3 wins carry just in 3 hours. We can start right now, whisper me for information █
	"getgearup.*karazhan.*nightmare.*dungeons.*runs.*more", --● Get gear up  ►►► Karazhan, Emerald Nightmare N/HC/M, Dungeons+ Runs and More ●
	"wts.*mythic.*master.*loot.*mythic.*details.*private", --EN WTS Mythic/HC Master - Loot, Karazhan, Mythic+ and more in >> details private messeng
	"wts.*nightmare.*boosting.*loot.*mythic.*glory", --WTS Emerald Nightmare Mythic/Heroic/Normal boosting +loot, Karazhan boost, Mythic Keystone Boost 1-10+lvl, Mythic dungeons boost, Glory of the Legion Hero
	"skype.*landroshop", --WTS [Keystone Conqueror] (2-10 lvl) and Karazhan, fast, smooth and fair. Details in skype: Landroshop
	"wtskarazhan.*timerun.*mount.*mythic.*dungeonboost", --WTS Karazhan8/8,Timerun with 100% mount,Mythic+,10/10Mythic dungeon boost
	--▄▀▄ WTS Artifact Leveling █ Emerald Nightmare Loot Runs █ Karazhan & Mythic+ Dungeons █ [Vicious Saddle] + Honor 1-50 + Prestige █ [Conquest-Capped.com] ▄▀▄
	"saddle.*conquestcapped[%.,]com", -- ▄▀▄ WTS Full Conquest Cap █ [Vicious Saddle] + 27,000 Conquest Points █ [Conquest-Capped.com]█ /w to get 5% discount ▄▀▄
	"^wts.*good.*fast.*powerle?ve?l", --WTS good and fast power leveling
	"service.*mythic.*raid.*pay.*price", --▲▲▲/GUILD SERVICE/-/Emerald Nightmare/-/Mythic+/-/Trust raids-pay after b00st/-/RAID TODAY/-/Best prices/-/No resell. And many more   ▲▲▲
	"wts.*karazhan.*mount.*nightmare.*hc.*dungeon.*run.*more", --● WTS  ►►► Karazhan(mount+), Emerald Nightmare N/HC/M, Dungeons+ Runs and More ●
	"offer.*honor.*prestige.*boost.*pvp.*mount", --Offer Honor and Prestige boosts : Unlock all PvP talents, 840-870 PvP gear, mounts, artifact power & appearance and a lot more ! /w me for more détails !
	"brb2game.*sale", --=>>www.brb2game.com<<=28$=100K 5-15 mins Trade.CODE:USWOW  More L895   Gears for sale! LVL835-870 Classpackage  Hot Sale! /2 =>>www.brb2game.com<<=
	"^wtsemeraldnightmare.*heroic.*pl.*tonight.*8.*fastrun.*highquality", --WTS EMERALD NIGHTMARE 7/7 Heroic with PL. Raid tonight at 8 pm. Fast run. High quality.
	"elitegamerboosting[%.,]de.*skype", --Return to Karazhan! Organisiere dir durch und mit uns einen unbeschwerten Ausflug in die neue Instanz - Erfolge, Loot und Mount inklusive! Alle Angebote auf [elite-gamer-boosting.de] | Skype: [real.elite.gamer] | Ab sofort 3% sparen mit dem Code: SIMON
	"wts.*nightmare.*mythic.*loot.*dungeon.*pvp.*glory", --►►►[WTS] The Emerald Nightmare Mythic/Heroic/Normal with loot, Mythic+ dungeons,► PvP help◄, Glory of the Legion hero & more!◄◄◄
	"juststarted.*legion.*gearup.*karazhan.*nightmare.*dungeon.*more", --Just Started The Legion ? Need To Gear Up ? Try Our KARAZHAN, EMERALD NIGHTMARE, +DUNGEONS AND MORE runs WTS!
	"%d+k.*giveaway.*guild.*selling.*karazhan.*mount.*mythic.*dungeon.*nightmare.*raid", --100K weekly giveaway from our guild! By the way we are selling Karazhan with mount, Mythic Dungeons+, Emerald Nightmare raids
	"l[o0][o0]tcl[o0]ud.*b[o0][o0][s5]t", --▲▲▲■■■LFB?>-L00tcl0ud?c0m?-GUILD B005T/-/EN HC 69e/-/Mythic+/-/Trust raids/Karazhan/-/Best offers/ And many more here-?L00tcl0ud?com?   ▲▲▲■■■
	"wtskara.*fasttimerun.*guarantee.*mount", --WTS KARAZHAN // fast time runs with guaranteed awesome MOUNT! /w me for more info.
	"wtsarena.*boost.*2%.?200.*2%.?400.*gladiator.*info", --WTS ARENA BOOST // 2.200 // 2.400 // 2.600 // 2.800 // GLADIATOR / /w Me for more info!
	--««WTS Emerald Nightmare Mythic/Heroic/Normal with Master Loot, Quick Raids everyday! Write me for info»
	"wts.*nightmare.*mythic.*master.*loot.*quickraids.*everyday.*write", --««WTS Emerald Nightmare Heroic/Mythic with Master Loot or Personal, Quick Raids everyday! Write me for info»»
	"2.*2%.4.*glad.*le?ve?ling.*100110.*info$", --B00st 2k/2.4+ 3s 2s, (glad/r1), Leveling 100-110, Want to get 2/2.2k+ playing yourself with r1? /w me for more info
	"2.*2%.4.*glad.*coach.*100110.*info$", --B0ost! Help 2.2/2.2/2.4, (glad/r1), Coaching from glads, Leveling 100-110 /w me for more info
	"arena.*2%.4.*2.*glad.*teammates.*push", --Arena 2k/2.4/2.7+ (glad, r1), cant find teammates for push rating? /w me
	"b[o0][o0]st.*2%.4.*2.*glad.*livestream.*info$", --B0ost 2.2/2.4/2.7+ (glad, r1), live streams, cant find teammates for push rating? /w me for info
	"b[o0][o0]st.*2%.4.*2.*glad.*selfplay.*info$", --B0ost 2k/2.4/2.7+ (glad, r1), Want get 2k or more selfplay? /w for info
	--B0ost arena 2.2/2.4/2.7+ (glad, r1), live streams, cant find teammates for push rating? /w me for info
	"arena.*2%.4.*2.*glad.*livestream.*info$", --B0ost arena 2.2/2.4/2.7+ (glad, r1), live streams, Want get 2k or more selfplay? /w me for info
	"wtsemeraldnightmarelootraids.*heroic.*mythic.*dungeons.*wisp$", --WTS Emerald Nightmare lootraids, Heroic/Mythic Dungeons. Wisp!
	"wts.*mythic.*boosting.*loot.*keystone.*dungeon.*glory", --WTS EN and Trial of Valor Mythic/Heroic/Normal boosting +loot, Karazhan boost, Mythic Keystone Boost 1-10+lvl, Mythic+ dungeons chests runs,  Mythic dungeons boost, Glory of the Legion Hero
	"selling.*professional.*team.*mount.*loot", --Selling <<Mythic+>>/<<Karazhan(mount)>>/<<EMERALD NIGHTMARE heroic>> by a professional team! Come get your mount and loot! Going Now pst for detail
	"^wtslegiondungeons.*mythic,karazhan$", --WTS Legion dungeons(myhic,mythic +),karazhan
	"wts.*valor.*lootrun.*mythic.*mount.*prestige", --[WТS] Trial of Valor normal & heroic lootrun; Emerald Nightmare Mythic/Heroic/Normal with loot; Karazhan lootrun+mount, Mythic+ dungeons,► Honor & Prestige lvl◄ & more! /w for info!◄◄◄
	--Hello! Offer 2000/2200/2400, (glad/r1), Coaching from glads, Leveling 100-110 /w me for more info
	"hello.*2200.*glad.*le?ve?ling.*info", --Hello! Offer 2000/2200/2400, (glad/r1), Leveling 100-110, Want to get 2k+ playing yourself? /w me for more info
	"karazhanmount.*nightmareruns.*spotsleft.*contact.*details$", --Karazhan mount, Emerald Nightmare runs. Few spots left! Contact for more details
	"trial.*karazhanmount.*nightmareruns.*spotsleft.*contact.*details$", --Trial of Valor, Karazhan mount, Emerald Nightmare runs. Few spots left! Contact for more details
	"wts.*heroic.*raid.*fast.*quality.*discount.*selfplay", --WTS EMERALD NIGHTMARE 7/7 Heroic with PL. Raid right now. Fast run. High [quality.Discount] for selfplay tonight!!!
	"^wts.*emeraldnightmare.*masterloottoday.*cheapandfast.*whisperme$", --WTS the Emerald Nightmare 7/7 HC Master Loot today,cheap and fast,whisper me
	"wtsrbg.*wins.*mount.*carry.*reins", --█ █WTS RBG 1-75wins(AP+HR)6Vicious [mount.carry] u right [now.also][Reins of the Long-Forgotten Hippogryph]and[Voidtalon of the Dark Star]█PST
	"^wts.*viciousmounts.*saddle.*star.*getrightnow", --Wts 6vicious mounts[Vicious Saddle]/[Voidtalon of the Dark Star]}get right Now! /Pst
	"wts.*today.*nightmare.*lootrun.*masterloot.*bestprice", --WTS: |=Today EMERALD NIGHTMARE MYTHIC Lootrun (7/7)||Master Loot|| Best Price!!!
	"wts.*valor.*lootrun.*mount.*mythic.*glory", --WTS: |=TRIALS OF VALOR N/HC=|=KARAZHAN Lootrun+Mount=|=Mythic+ Dungeons=|=Glory of the Legion Hero=|W/me!!!
	"^wtsgamingservices.*pve/pvp.*write.*info", --WTS gaming services in PvE/PvP write me for info
	"^wtsenandtov.*mythic.*heroic.*boosting.*loot.*karazhan.*dungeonsboost", --WTS EN and ToV Mythic/Heroic/Normal boosting +loot, Karazhan Boost, Mythic+ Dungeons Boost
	"gold.*g4game[%.,]c[o0]m", --WTS 60000 Gold=$20----------------------------- WWW.G4GAME.C0M.-----------------------------Buy Now
	"gold.*g[o0]ldce[o0][%.,]c[o0]m", --Sell Cheap Gold Welcome to WWW.G0LDCE0.C0M    WWW.G0LDCE0.C0M  WWW.G0LDCE0.C0M    WWW.G0LDCE0.C0M
	"^onespotleft.*nightmare.*mythicboost.*clear.*loot.*amazingprice.*raidstarts", --"one spot Left"Wts Emerald nightmare Mythic boost 7/7 clear including 8-12 loot Minimum for amazing price , raid starts at 15:00 st ! w me
	"trial.*valor.*nightmare.*myth.*karazhan.*powerleveling.*muchmor", --TRIAL OF VALOR, EMERALD NIGHTMARE HC/MYTH, KARAZHAN, POWERLEVELING, MYTH+ AND MUCH MOR >>>
	"^wts.*nightmare.*mythicboost.*clear.*loot.*amazingprice.*raidstarts", --Wts Emerald nightmare Mythic boost 7/7 clear including 8-12 loot Minimum for amazing price , raid starts at 18:00 st! w me .
	--Doing Honor and Prestige boosts : Unlock all PvP talents, 840-870 PvP gear, PvP Saddle, artifact power & appearance and a lot more ! visit [www.prestige-wow.com] for more details !
	"%d+.*prestigewow[%.,][cf]", --Offering Honor and Prestige boosts : Unlock all PvP talents, 840-870 PvP gear, mounts, artifact power & appearance, golds and a lot more ! With [www.prestige-wow.com1]
	"skype.*vf3399", --[5000+ forums vouches]wts virtual currency 0.23$/k,safe gold guaranteed,mmogoldbay.NET,{laugh} my skype is vf3399
	"wtskarazhanwithmount.*mythicdungeons.*valor.*nightmare", --BLACK FRIDAY SALES! DON'T MISS IT! WTS Karazhan with mount, Mythic Dungeons+, Trial of Valor, Emerald Nightmare raids
	"loot.*mount.*mythic.*dungeons.*ask", --►►► [WТS] ► Trial of Valor Normal/Heroic with loot ► Emerald Nightmare Heroic/Mythic with loot ► Karazhan lootrun + mount ► Mythic+ 0-15 lvl dungeons - TUESDAY SALE 20% OFF ◄ ask me to get more info!
	"sale.*mount.*loot.*mythic.*dungeons", --►►► [WТS] ► SUNDAY Sale! Karazhan lootrun + mount 20% OFF► Trial of Valor Normal/Heroic with loot ► Emerald Nightmare Heroic/Mythic with loot ► Mythic+ 1-15 lvl dungeons ◄ ask me to get more info!
	"wts.*mythic.*lootrun.*master.*fast.*cheap.*ready.*info", --[WTS] Now Emerald Nightmare Mythic Lootrun!Master Loot!Fast and Cheap!Ready to go in 15 min,/w me for more info
	"selling.*nightmare.*heroic.*masterloot.*boost.*server.*info", --Selling Emerald Nightmare Heroic Masterloot boost, tomorrow at 19:00 server time, /w me for more info!!
	"wts.*xavius.*boost.*completed500.*curve.*%d+.*me.*info", --WTS HC Xavius boost we completed 500+ run take your curve next run 16:40 server time /w me more info !!
	"^wtsenmythiclootruntonight.*goldpossible.*w", --WTS EN Mythic Lootrun tonight (ML, gold possible) ./w
	"^wts.*keystoneconqueror.*karazhan.*fast,smoothandfair.*whisp", --WTS [Keystone Conqueror] (2-12 lvl) and Karazhan, fast, smooth and fair. Whisper for more info.
	"^wtsen.*tov.*boost.*mythic.*karazhan.*mount.*info", --WTS EN, TOV heroic BOOST (master loot),  Mythic+ (up to 12+ keys), Karazhan (with Nightbane and mount) PM for info
	"^wtstoday.*nightmaremythic.*master.*fastcheap.*info", --WTS Today Emerald Nightmare Mythic(7/7) with Master Loot||Fast & Cheap||/w me for more info
	"^=*wts=*today.*nightmaremythic.*master.*bestprice$", --=WTS= Today Emerald Nightmare Mythic(7/7)!Master Loot!Best Price!!!
	"wts.*lootrun.*myth.*mount.*offers.*live", --■■■ <[WТS]> ToV NM/HC lootrun>; EN myth/hc/nm with loot; Karazhan lootrunMount, Mythic dungeons,<►Crazy offers◄> /w to get the best offer today!!! <Live support>■■■
	"wtsfast.*smooth.*karazhan.*mount.*valor.*nightmare.*wisp", --WTS FAST and SMOOTH Karazhan with mount, Trial of Valor, Emerald Nightmare run. Wisp!
	"wts.*nightmare.*heroic.*ml.*quality.*discount.*come.*items", --WTS EMERALD NIGHTMARE 7/7 Heroic with ML. High [quality.Discount] for cloth/mail/leather! Come get your 865+ items.
	"wts.*heroic.*raid.*tonight.*come.*items.*quality.*discount", --WTS EMERALD NIGHTMARE 7/7 Heroic with ML. Raid tonight at 19.00 CET. Come get your 865+ [items.High] [quality.Discount] for cloth/leather/mail!
	"wts.*nightmare.*valor.*le?ve?ling.*best.*info", --►►►WTS: THE EMERALD NIGHTMARE | TRIAL OF VALOR | MYTHIC DUNGEONS | CHARACTER LVLing | BEST PRICE | WHISPER ME FOR MORE INFO!◄◄◄
	"wts.*rbgs.*mounts.*saddle.*accshare", --▓▓WTS RbgS(1-75wins)HR/ap/6 vicious mounts(viciours saddle)also[Reins of the Time-Lost Proto-Drake]▓[Voidtalon of the Dark Star]RN,no accshare▓PST
	"^wts.*nightmare.*mythic.*gear.*gua?rantee.*amazing.*price.*details", --WTS Emerald nightmare mythic 7/7 clear including 8-12 Gear for you atleast (guranteed) for amazing price only today Going on 15:00 st ! w for more details.
	"^wtsmount.*karazhan.*timerun.*quality.*service", --Wts mount from Karazhan (time run) right now! High quality service.
	"wts.*mythic.*dungeon.*loot.*items.*le?ve?ling.*hours.*info", --[WTS} Mythic Dungeon with additional loot, get 20-30 items!!! Fast leveling 100-110 in 6-10 hours! Write me for info!
	"wts.*mythicplus.*timer.*loot.*gift.*write", --►►► WTS Mythic Plus any lvl!! +10 and +15 on the timer!! loot as a gift for you! ►►► Write me for more info!
	"wts.*heroic.*master.*loot.*mythic.*items.*guarantee.*info", --►►► [WТS] ► Trial of Valor Heroic with Master loot  ► Emerald Nightmare Heroic & Mythic 6 Items Guaranteed! ◄ ask me to get more info!
	"wts.*today.*raid.*nightmare.*mythic.*heroic.*loot.*guarantee.*items", --WTS Today Raid Emerald Nightmare ^ Mythic // Heroic ^ with ALL Loot for you! !^Guarantee 5-6 items!For Mythic raid we have a good offer today!
	"^wtskarazhad?nrunwithmount.*startin%d+.*wformoreinfo$", --WTS Karazhan run with mount, start in 30 min, /w for more info!
	"^wtsnow.*nightmaremythic.*withmlfastcheap.*readytostartin%d+minute", --WTS Now Emerald Nightmare Mythic(7/7)with ML!Fast & Cheap!Get ready to start in 15 minutes!!!
	"^wtstodaymythic.*higher.*hurry.*beforereset.*weeklychest.*write.*info", --▲▲▲WTS Today Mythic+10 or higher, Hurry do it before reset for weekly chest!! Write me for more info▲▲▲
	"wts.*earnmount.*rank.*viciousmount.*selling.*accshare", --WTS 1-75wins Earn mount +honor rank  AP and 6vicious mount  ;also selling[Reins of the Long-Forgotten Hippogryph]and[Voidtalon of the Dark Star]},no acc share 
	"wtsartifactpower.*mount.*saddle.*accshare", --Wts artifact power to get  higher weapon lvls/ 6vicious mounts[Vicious Saddle]also selling[Voidtalon of the Dark Star]}No need acc share ! /Pst
	"sellingrbg.*honou?r.*mount.*accountshare", --Selling RBG 1-100wins(honor rank),6RBG mounts [Vicious Saddle],BOP mount[Voidtalon of the Dark Star][Reins of the Long-Forgotten Hippogryph]},no account share
	"telegram.*amirangaming", --Foorooshe Legion 135T , BattleChest 44T  Tahvil fori , Telegram : https://telegram.me/AG_Co Or  @AmiranGaming
	"^wts.*tonight.*nightmare.*mythic.*masterloot.*guarantee.*cheap.*price", --WTS ►Tonight Emereld Nightmare Mythic with Master Loot ▌▌7 loot guaranteed ▌▌Cheapest price! /w me
	"strongandskilledteam.*helpyouwithmythicdungeon.*upto%d+fastandeasy", --Strong and skilled team will help You with Mythic+ dungeons up to 14+ fast and easy.
	"experiencedteamoffriends.*helpyouwithmythicdungeon.*upto%d+inshorttime", --Experienced team of friends will help You with Mythic+ dungeons up to 14+ in short time!
	"helpyou.*skype.*warstre", --We will help you with the Emerald Nightmare N | H, Karazhan; Ember Wyrm; Mythic + Dungeon and other services. Skype: Warstre
	"wtsmythic.*runs.*difficulty.*karazhan.*mount.*selfplay.*runseveryday.*info", --█ WTS █ Mythic+ Runs of any difficulty, Karazhan including mount. Selfplay! Runs every day. /w for more info
	"prestigewow[%.,]+[cf].....................................",

	--[[ Chinese ]]--
	"ok4gold.*skype", --纯手工100-110升级█翡翠英雄团█5M代刷 大秘境2-10层（橙装代刷）█代刷神器点数 解锁神器第三槽█金币20刀=10w█微信ok4gold█QQ或微信549965838█skype；gold4oks█微信ok4gold█v
	"微信.*549965838", --金币最低价20刀10w 微信ok4gold   微信或者QQ549965838 微信ok4gold  百万库存20刀=10w 百万库存20刀=10w QQ或者微信549965838 微信ok4gold  微信或者QQ549965838 微信ok4gold
	"qq.*1505381907", --特价[Reins of the Swift Spectral Tiger]，金币28刀十万，量大优惠。等级代练，大秘境(刷橙装），荣誉等级(送坐骑），翡翠团本代练;,QQ:1505381907或者微信：babey1123
	"微信.*1505381907", --圣诞节金币特价，25刀10万，大秘境刷箱子（低层掉橙装和高层拿低保）,翡翠梦境团本(史诗全通）,荣誉和等级代练纯手工，苏拉玛任务，大小幽灵虎等坐骑,需要的加我Q/微信：1505381907
	"qq.*1513941814", --圣诞特价金币、等级代练，5h、m、大密、卡拉赞通刷坐骑、世界任务维护、苏拉玛1-8章、神器点数、翡翠团本，联系QQ1513941814、微信
	"qq.*593837031", --纯手工100-110 低价，大秘境1-10层热销中，翡翠梦境英雄普通包团毕业。橙装，神器三插槽，金币大量，感兴趣的联系QQ:593837031 skype:wspamela 微信 593837031
	"100110.*q228102174", --100-110纯手工升级低价热卖，无敌飞机头 ，星光龙热卖1-2周保证拿到，，翡翠梦魇普通包团毕业火热销售中,职业大厅，神器点数，神器解锁三插槽 [，金币大量QQ228102174,微信894580231。skype.raulten1234]
	"gold.*eddie8806", --GOLD全服最低890装等双橙大号出售自营AH绿色G，安全便宜快速，非工作室黑G，北美IP交易，买G最重1要就是安全 要的速M 人在就10分钟！保证全场最低价微信eddie8806
	"100110.*苏拉玛任务.*星空龙", --纯手工90-100-110任务升级（任务全做，开启声望）。苏拉玛任务11/8。神器三插槽。荣誉50等级~（送邪气鞍座）。军团6大声望 [~手工金币30刀十万，现货秒发。200MB=10万.星空龙~无敌] 飞机头 1-2CD必出
	--小号代练--翡翠英雄本特价大秘镜3箱(橙装代刷),苏拉玛任务，堕落精灵声望，神器点代刷，解锁神器第三插槽,金币169=10万需要微信17788955341
	--***大秘境12层保底885特价+++微信17788955341 ***超效率便宜翡翠H团***卡拉赞坐骑***金币159十万
	--出售[Reins of the Swift Spectral Tiger].,.金币179RMB=10W,899RMB=500K.QQ微信17788955341
	"微信.*17788955341", --特价Six-Feather Fan-,六禽羽扇855/860特价,179RMB=10万,99刀=40万--11层大秘境《刷橙》,翡翠英雄团,KLZ梦魇龙,成就声望另售幽灵虎微信/QQ: 17788955341
	"qq.*1433535628", --N/H翡翠梦境包团毕业， 大秘境（刷箱子刷橙装 ）， 地下城， 荣誉解锁送神器点数 ，装绑装备和材料以及各种坐骑， 金币和飞行解锁。欢迎咨询QQ:1433535628  skype：forgotmylove
	--低层三箱刷橙 10层低保，新开11层12层低保 KLZ梦魇坐骑和全通 需要的加Q 1292706134
	"低层三.*q1292706134", --大酋长团队 接大秘境维护1-10层，低层三箱刷橙，团本毕业，等级100-110，需要的加QQQ1292706134
	"微信.*sesegold", --特价大小老虎,鸡蛋军马各TCG长期供货,金币169RMB=10万,98-110等级代练,大秘境保底,翡翠梦境H/M包团,5M代刷套餐特价-需要微信sesegold
	"%d+.*万金.*支付宝", --100人民币=10万金，有30，个人出售，支付宝微信，骗子移步
	"qq.*2278048179", --特价[Six-Feather Fan]850等级 金币32刀 10万 现货秒发。。大小老虎卡牌坐骑。 十年信誉品牌 欢迎咨询 QQ: 2278048179
	"金.*778587316", --亲，出售金币,10w29刀，-专业快速代练100-110 纯任务升级**苏拉吗9/11,解锁世界任务，神器三槽，，代练声望，翡翠梦境包团，重返卡拉赞+梦之魇坐骑，pvp邪气鞍座等微信：mia11125 Q778587316
	"100110.*送坐骑.*tiger", --100-110级纯手工练级------G币28刀十万,现货秒发；荣誉等级(送坐骑），大秘境刷箱子（橙装掉率很高），翡翠梦境团本，大小tiger坐骑有需要的M我
	"100110.*币.*幽灵虎", --纯手工100-110升级    G币20刀十万    翡翠英雄团 5M代刷 大秘境2-10层（橙装掉率很高） 卡拉赞前置任务代做 卡拉赞副本通关 代刷神器点数 解锁神器第三槽 苏拉码任务8/11  大小幽灵虎，有需要的M
	"^marine.*在秒回", --Marine5人本类业务，卡拉赞，5Mx10 大秘境10层低保ilvl880 及大秘境15层幻化解锁-----人在秒回
	"881.*安全便宜快速.*ip", --881装等双橙大号出售自营AH绿色G，安全便宜快速，非工作室黑G，北美IP交易，买G最重要就是安全！全场最低 要的速M 人在就10分钟！
	"特价出售黄金.*稀有坐骑", --特价出售黄金，等级代练纯手工，荣誉等级(送坐骑），大秘境刷箱子（橙装掉率很高），翡翠梦境团本，稀有坐骑有需要的MMMMMMM
	"200万手工金币.*paypal", --→→活动促销200万手工金币2.8刀1万 低价甩~ 买的多还送坐骑 安全 效率 要的老板密→支持淘宝、paypal 多种付款 薄利多销 另售卡牌坐骑 承接各种代练
	"qq.*153874069", --华哥超低黄金27刀10万安全效率 大小幽灵虎坐骑请咨询 承接各种代练 支持淘宝、paypal 多种付款+微信QQ：153874069
	"qq.*3450345", --PGP工作室 H翡翠包团200刀可单买，团长分配保证6+拾取，新客户可免费再带一周。100-110代  练纯手工快速 12小时，代清世界任务，卡拉赞坐骑，联系QQ或微信都是 3450345
	"练级.*bearwow[,.]com", --承接WOW 100-110练级、大秘境、卡拉赞、世界任务、神器外观、神器第三槽解锁等,纯手工，市场最低价，请登陆网站：w w w.bearwow.c o m
	--特价[Reins of the Swift Spectral Tiger]，金币25for100K，等级代练纯手工，荣誉等级(送坐骑），大秘境刷箱子（橙装掉率很高），翡翠梦境团本，稀有坐骑,需要的mmmmmmm
	--特价[Reins of the Swift Spectral Tiger]，金币25刀10万，等级代练纯手工，神器点数，荣誉等级，大秘境刷箱子，苏拉玛1-8章,翡翠梦境团本代练，稀有坐骑,需要的mmm
	"特价.*tiger.*稀有坐骑", --特价[Reins of the Swift Spectral Tiger]，黄金,26for100K，等级代练纯手工，荣誉等级(送坐骑），大秘境刷箱子（橙装掉率很高），翡翠梦境团本，稀有坐骑,需要的mmmmmm
	--出售特价金  20 for 100K    纯手工100-110升级 翡翠英雄团 5M代刷 大秘境2-10层（橙装掉率很高） 卡拉赞前置任务代做通关 代刷神器点数 解锁神器第三槽 苏拉码任务8/11  大小幽灵虎，需要M我
	"出售特价金.*%d+for%d+k.*100110", --出售特价金  20 for 100K    纯手工100-110升级 翡翠英雄团 5M代刷 大秘境2-10层（橙装掉率很高） 卡拉赞前置任务代做通关 代刷神器点数 神器三槽 特价Reins of the Spectral Tiger，需要M我
	"拿任意橙.*神器三槽.*110", --2层箱子热卖,脱非入櫛§，不在遥远.无限2箱,拿任意橙督。 8-10层大秘境,箱子+周奖励,快捷提升袛等.H梦魇包团,毕业,] 个人拾取热销中。神器三槽,110等级代练,苏拉玛任务声望代练接单.
	--100-110手工任务，清世界任务，荣誉等级（送坐骑），825装等毕业，5人M本840+毕业。神器三槽。大密境，苏拉玛1-8章，翡翠梦境团本。各种稀有坐骑~金25刀10万。
	"100110.*神器.*金", --纯手工100-110，世界任务~神器三槽~苏拉玛11/8。荣誉等级（送坐骑），金币-26刀10W。星空龙~无敌 飞机头。
	"qq.*100845995", --●橙装必备(大秘境无限刷低层箱子)√●提升装等必备(850-885装绑)√●长期在售 大秘境高层保底/卡拉赞坐骑/翡翠梦境(H/M)+勇气试炼团本/稀有坐骑~ 欢迎各wower老板咨询QQ:100845995 微信:446298161
	--怒刷一个人品渣子，角色名profoundsea，被X了装备退会太没有道德情义。希望收留他的公会可以继续把他插毕业 然后可以接受让他带一群人跑
	"个人品渣子.*profoundsea", --怒刷一个人品渣子，角色名profoundsea,此人在工会骗取坦克装备毕业就退会，平常工会活动没需求就早退打大米。xsj18605816678微信 实名叫jiayxia玩一天就刷一天到你没队友为止。
	"style.*快速练级.*50lvl", --Style工会强力手工快速练级，荣誉等级50LVL，3v3马鞍奖励，卡拉赞坐骑H和M翡翠包团毕业，10到12高层大米拿2箱奖 励和低保，2层3层无限刷橙装和神器点数奖励，另黑市高端坐骑代买。
	--喜迎7.15版本和新春，本工作室手工110练级，荣誉50等级解锁送3v3马鞍大酬宾，强力卡拉赞坐骑M或者H翡翠包团及毕业，10到12层大米拿885低保送2箱，欧皇带你2-3层刷橙子和神器点数，欢迎咨询
	"15版本和新春.*10", --喜迎7.15版本和新春稀有坐骑大酬宾无敌  飞机头 星光龙  季鲲子嗣  赫利东子赤炎  实验题12  黑龙  火乌鸦  纯血一周包出，10年稀有代刷经验为你服务
	"无限拾取套餐特价.*金币25", --H/M大米2-12无限拾取套餐特价+850升级870装等套餐+H/M包团+卡拉赞全通加龙特价。。金币25十万大小老虎MMM
	"低价出售翡翠包团.*金25", --纯手工任务升级~低价出售翡翠包团，KLZ龙。神器三槽~5人H-M本毕业。大密境（刷箱子），苏拉玛1-8章。星空龙，无敌 飞机头等坐骑。金25刀十万。
	"低层刷橙装和高层拿低保.*大小幽灵虎等稀有坐骑", --圣诞节特价，金子23刀=10万，大秘境刷箱子（低层刷橙装和高层拿低保）,英雄，史诗翡翠梦境团本,等级代练纯手工，神器点数，荣誉等级，苏拉玛1-8章，大小幽灵虎等稀有坐骑,需要的mm
	"金币大量库存.*飞机头等坐骑", --手工任务升级，5人M本毕业。金币大量库存，威望等级~解锁苏拉玛1-8章，神器三插槽，翡翠梦魔包团最低价。星空龙，无敌，飞机头等坐骑。
	"^marine.*老牌华人实力公会", --Marine 20M，30H团本业务，（老牌华人实力公会，进度最快，活跃玩家人数最多)支持包团，全LOOT及个人拾取
	--Marine5人本成就及各种，卡拉赞，5Mx10 大秘境10层低保ilvl880 及大秘境15层幻化解锁
	"^marine.*幻化", --Marine PVP一起打上分，2V2，3V3上分2000-2400，决斗者，角斗士称号及精锐幻化套餐
	"^marine便宜金子", --Marine 便宜金子
	"守望先锋上分.*2000.*3000.*前私密谈", --守望先锋上分 2000前每100分40， 2500前每100分50， 3000分60，4000前私密谈
	--翡翠梦魇H/M副本包团包毕业装备，金币大量库存,j神器三插槽，威望等级，5M大米，手工升级，欢迎咨询,绝不忽悠.
	"金币大量库存.*欢迎咨询", --Leo 手工等级业务,翡翠梦魇H/M包团，包毕业，H包团送普通包团，神器三插槽，神器能量，特价金币大量库存，解锁苏拉玛，荣誉和威望1234，全部纯手工，欢迎咨询
	"^style.*光龙无敌火鹰等热卖", --Style手工练级，3v3马鞍奖励和威望等级，荣誉等级50,英雄H史诗M翡翠梦魇包团及毕业,10和12层大米拿2箱奖励或低保提升装等，2层3层欧皇低价无限刷橙装，卡拉赞坐骑星光龙无敌火鹰等热卖。
	"圣诞节金币特价.*大小幽灵虎等坐骑", --圣诞节金币特价，23刀=10万，大秘境刷箱子（低层掉橙装和高层拿低保）,翡翠梦境团本(史诗全通）,荣誉和等级代练纯手工，苏拉玛任务，大小幽灵虎等坐骑,需要MMMM
	"层箱子无限刷橙.*试炼包团", --大米2层箱子无限刷橙,10-12层箱子+周奖励,快捷提升装等.H&M翡翠可包团,毕业。神器三槽,110等级代练,苏拉玛任务声望代练接单.每日世界任务代清,燃尽巨龙代刷.H试炼包团
	--圣诞节大甩卖 金20for10W，等级代练纯手工，神器点数，荣誉等级(送坐骑），大秘境刷箱子（低层掉橙装和高层拿低保），苏拉玛1-8章,翡翠梦境团本代练，大小老虎坐骑,需要的M我
	--圣诞节金币热销 20for10W，等级代练纯手工，荣誉等级(送坐骑），大秘境刷箱子（低层掉橙装和高层拿低保），苏拉玛1-8章,翡翠梦境团本代练（史诗全通），老虎，战马，公鸡等坐骑,需要的M我
	"20for10w.*刷箱子", --圣诞节大甩卖金子 20 for10w大小幽灵虎现货秒发 KLZ龙 纯手工任务升级 神器三槽 世界任务 神器能量5M毕业 大秘境（刷箱子） 苏拉玛1-8章 星空龙 翡翠包团  鸡蛋 龙鹰  幽灵马  大甩卖金子 m我
	"清世界任务.*金%d+刀%d+万", --等级代练纯手工任务，清世界任务，神器三槽。5人H-M本毕业。苏拉玛8章，翡翠梦境团本最低价。星空龙，无敌，飞机头。金23刀10万
	"无限拾取套餐特价.*金币二十万", --H/M大米2-12无限拾取套餐特价；卡拉赞龙队全通拾取特价；；H/M包团保底七个；勇气试炼H强力团购。。金币二十万=299RMB。大小老虎微信meitao1131
	"热售翡翠梦境包团.*金币", --热售翡翠梦境包团~等级纯手工任务升级~5人M本毕业，苏拉玛第8章~神器三槽。金币22刀十万。星空龙，无敌，飞机头等坐骑
	"工作室手工任务练级.*龙无敌火鹰等热卖", --工作室手工任务练级，PVP装备荣誉等级马鞍奖励速刷,10或12层大秘境拿2箱奖励或低保快速提升装等，2层-3层欧皇无限刷橙装，英雄H史诗M翡翠梦魇包团及毕业,卡拉赞坐骑星光龙无敌火鹰等热卖
	"圣诞节大甩卖金币.*金子大甩卖", --圣诞节大甩卖金币 大小幽灵虎现货秒发 KLZ龙 纯手工任务升级 神器三槽 世界任务 神器能量5M毕业 秘境（刷箱子苏拉玛1-8章 星空龙 翡翠包团  鸡蛋 龙鹰  幽灵马  大小幽灵虎现货 金子大甩卖 m我
	"神器三槽.*金%d+刀%d+万", --N-110等级纯手工任务，神器三槽。5人M本毕业。大密境，苏拉玛8章，翡翠梦境团本最低价。星空龙，无敌，飞机头。金23刀10万。
	"圣诞节金币大促销.*送坐骑", --圣诞节金币大促销 20刀--10万，等级代练纯手工，清理世界任务，荣誉等级(送坐骑），大秘境刷箱子（低层掉橙装和高层拿低保）,翡翠梦境团本代练，老虎，公鸡等坐骑,需要的密我.

	--[[  Russian  ]]--
	"maxlvl[%.,]net.*пpoдaжa", --MAXLVL.NET Продажа персонажей 110(870+илвл). Лут-рейды ИК Нормал, Героик, Эпох. МИФ+15. Фарм престижа. Оденем вашего персонажа до 885+ илвл.
	--Успей получить [Мстительный боец]  Цена снижена к концу сезона - https://LootKeeper.com
	"цeн[ae].*lootkeeper[%.,]com", --Дракон из Каражана по хорошей цене ☼ Прокачка персонажей и фарм силы артефакта ☼ Фарм хонора и престижа ☼ Маунты ☼ - https://LootKeeper.com
	"dving[%.,]ru.*уcлуги", --►►► DVING.RU - ПРОКАЧКА ПЕРСОНАЖА, ПОДЗЕМЕЛЬЯ ЛЮБОЙ СЛОЖНОСТИ, ИК С МАСТЕР ЛУТОМ , ПВП РЕЙТИНГИ И ДРУГИЕ УСЛУГИ - ПРОМОКОД "N16" - DVING.RU ◄◄◄
	"низkиeцeны.*getloot[%.,]ru", --Поможем с ИК,ИД,мификами и плюсами, а так же [Возвращение в Каражан] Низкие цены на getloot. ru
	"wowmart[%.,]ru.*зoлoto", ---= WOWMART.ru =- Купим все ваши монетки. Продаем Legion за золото - 300к!
	--| [Rpg-Gold.ru]\ Скупаем 9р за 1.000 Золото\\ Ищем поставщиков ||Все способы оплаты
	"rpggold[%.,]ru.*cпocoбы", --|Сервис [Rpg-Gold.ru] | Прокачка 100-110ур/Лут-рейды|Мифик+|Каражан|Ключ Легиона За ГОЛД|Онлайн чат на сайте.| Ищем поставщиков||Все способы оплаты

	--[[  Spanish  ]]--
	"oro.*tutiendawow.*barato", --¿Todavía sin tu prepago actualizada? ¡CÓMPRALA POR ORO EN WWW.TUTIENDAWOW.COM! ¡PRECIOS ANTICRISIS! ¡65KS 60 DÍAS! Visita nuestra web y accede a nuestro CHAT EN VIVO. ENTREGAS INMEDIATAS. MAS BARATO QUE FICHA WOW.

	--[[  French  ]]--
	"osboosting[%.,]com.*tarifs.*remise", --☼ www.os-boosting.com ☼ Le meilleur du boosting WoW à des tarifs imbattables. Donjons mythique 10/10 - Raids Cauchemar d'Emeraude 7/7 Normal & Héroïque - Métiers 700-800 - Pack 12 Pets TCG - Réputations Legion - Gold   | Code remise 5%: OS5%
	"wallgaming.*loot.*keystone", --¤ www.WallGaming.com ¤ Raids Cauchemar d'Emeraude HM 7/7 6 loots/+ | Gloire au héros de Legion | Donjons Mythique 10/10 +5keystone | Arène 2c2 3c3 2000 & 2200 | Honneur PvP niveau 50 | Pets & Montures TCG |  N°1 FR
	"pvp.*wallgaming[%.,]com", --☺♥ Profitez des dernières nouveautés de Legion maintenant  ♥☺ Cauchemar d'Emeraude HM Master Loot | Gloire au héros de Legion | Donjons Mythique+ / Karazhan 9/9 Mythique | Selle Vicieuse | Stuff PvE & PvP | www.wallgaming.com  Team FR
	--"pvp.*prestigewow[%.,]fr", --Propose PL Honneur et Prestige ; Débloque tous les talents pvp, équipement 840-870 ilvl, monture, puissance d'artefact & nouveau skin pour l'arme artefact, gold et bien plus encore ! Visitez notre site web : www.prestige-wow.fr pour plus d'infos !

	--[[ Danish ]]--
	"^sælgerguldfor%d+", --sælger guld for 170kr pr. 100k (w for andre servere)
	"^sælgerg[ou]ld.*mobilepay", --Sælger guld, forgår over mobile pay, 100k - 150 kr
	"tilbud.*sælger%d+k.*mobilepay", --Dagens tilbud: Sælger 200 K for blot 280 kr - whisper for mere info: Mobilepay & Swipp
	"sælgerguld.*skype", --Sælger guld 20k 33kr og 100k til 149kr, skype ...
	"sælgerguld.*priser", --Sælger guld: 200k for 250kr. Mulighed for bedre priser ved større køb
	"sælgerlidtguld.*mobilepay", --Hej, jeg sælger lidt guld via. mobilepay. Tilbud : 100k for 150kr , 250k for 350kr - Skriv for mere info. :)
	"sælgerg.*%d+kr?pr", --sælger g / w 1k pr. 1k
	"sælgerguld.*info", --Hej. Sælger guld: 240 pr 200 K. [w for mere info]- mængderabat muligt
	"nogen.*skalkobeg.*info", --Er der nogen der skal købe g? {w for mere info]
	"sælgerguldviamp", --< SÆLGER GULD VIA MP!
	"sælgerguldviamobile?pay", --Sægler Guld Via mobilepay 100k 100 Kroner w/me
	"nogleg.*sælgerovermobilepay", --Har du brug for nogle g? Jeg sælger over mobilepay /w mig!
	"sælger%d+kguld.*mobile", --Sælger 100k guld for 100DKK. Skriv til mig :) Vi bruger mobilepay :)
	"^sælgerguld.*skrivtilmig", --Sælger guld, skriv til mig
	"manglerdugold.*kroner.*mobilepay", --Mangler du gold! så du kommet til den rette!  100k = 89.5 kroner!!! MÆNGDERABAT PÅ ALT OVER 100k! PAYPAL/MOBILEPAY
	"sælgerg.*mobilepay", --Hej. Sælger g. 100 dkk pr 100 K. [w for mere information]- Mobilepay, Swipp & Paypal

	--[[ Swedish ]]--
	"saljerguld.*detail.*stock", --Säljer guld 1.7kore details Stock: 3000k
	-->>>>Säljer Guld Via Swish!<<<<
	--Säljer guld via Swish! 130kr / 100k Leverans direkt!
	--Säljer guld via Swish. 1,3kr per 1k alltså 130kr för 100k. Snabbt och smidigt. /w för mer info.
	--Säljer guld via swish, /w vid intresse!!
	--Säljer Guld Via Swish! /w mig!
	"^saljerguldviaswish", --Säljer guld via swish 135kr för 100k /w för mer info eller adda Skype Dobzen2
	"^saljergviaswish", --Säljer g via swish 1.7kr per 1k /w mig =D [minsta köp 50k]
	"^saljerguldsnabbtviaswish", --Säljer guld snabbt via Swish 100k=170SEK 1.7kr/1000g Billigare vid bulk  /Whispra mig och chilla på svar
	--köper wow guld via swish
	"^koperw?o?w?guldviaswish", --Köper guld via swish
	"^kopergviaswish", --KÖPER G VIA SWISH
	--Guld finns till salu, 1.3 per tusen! Betalning sker via swish! Mängdrabatt tillkommer.
	--Guld finns via swish, 1.3kr per tusen! /w vid intresse.
	"^guldfinns.*viaswish", --Guld finns till salu via SWISH, /w för mer info
	"^saljerwowguld.*viaswish", --Säljer wow guld för 140kr per 100k, via Swish! /W
	"^saljer%d+kguldfor.*viaswish", --Säljer 600k guld för 800kr, via swish! Nu eller aldrig
	"^saljerguld,swish", --Säljer guld, swish
	"guldkvar.*viaswish", --100k guld kvar! 1,8kr/1000g betalning sker via swish! /w mig vid intresse! 50k är minsta köp!
	"^guldviaswish", --Guld via swish /w :)
	"^guld%d+k.*kr.*skype", --Guld 20k til 30kr og 100k til 129kr, skype
	"^saljerviaswish", --Säljer via swish /w vid Intresse
	"^gfinnsswish$", --g finns swish
	"^gfinnsbilligt$", --g finns billigt
	"^gfinns@swish", --G finns @ swîsh /w
	--900k finns att köpa Billigt @swish
	"^%d+kfinns.*@swish", --700k finns @ swish /w
	--någon som säljer g via swish? /w
	"^nagonsomsaljergu?l?d?viaswish", --NÅGON SOM SÄLJER GULD VIA SWISH?
	"^behoverdug@swish", --behöver du g? @ swish /w
	"^gfinnsatt?kopa.*swish", --G finns att köpa genom swish
	"spelpengar@swish", --behöver du spelpengar ? @ swish /w
	"^guldfinns.*kopa.*swish$", --Guld finns att köpa genom swish
	"^gsaljsbilligt.*swish", --G säljs billigt! (swish)
	"guldsalje[rs]viaswish", --Wow guld säljes via swish! 120kr per 100k.
	"^saljerwowguldgenomswish", --Säljer wow guld genom Swish 120 kr per 100k /w för skype!
	"^saljerguldpaswish", --Säljer guld på swish. /w mig hur mycket du vill ha så säger jag ett pris
	"^wtbg[ou]ldviaswish", --wtb guld via swish
	--will köpa guld via swish
	"^[vw]illkop[as]guldviaswish", --VILL KÖPS GULD VIA  SWISH
	"^billigtguldviaswish", --Billigt guld via Swish /w vid intresse {Säljer på alla servrar]

	--[[ German ]]--
	"besten.*skype.*sarmael.*coaching", --[Melk Trupp]Der Marktführer kanns einfach am Besten, nun sogar als aktueller Blizzconsieger! Melde Dich bei mir im Skype:Sarmael123456 und überzeuge Dich selbst! Ob Arena, Dungeons, Coachings oder Raids-Bei uns bekommst du jede Hilfe, die Du benötigst!
	--[mmo-prof.com] raffle: Hellfire Citadel (Difficulty level: Mythic) 13/13 including loot. Eligibility requirements to be found on [mmo-prof.com]; Heroic raids, CM GOLD, mounts, PVP and more can be found , too. We're looking forward to your visit!
	"mmoprof.*loot.*gold", --{rt2} [mmo-prof.com] {rt2} BRF Heroic / Highmaul Heroic , Mystisch Lootruns !! Arena 2,2k - Gladiator .. Jegliche TCG Mounts , Play in a Pro Guild (Helfen euch einer absoluten Top Gilde beizutreten, alles für Gold !! Schau vorbei {rt2} [mmo-prof.com] {rt2}
	"mythic.*coaching.*mmoprof", --Bieten Smaragdgrüner Alptraum Mythic/Heroic/Normal Lootruns. Mythic + Instanzen 2-10! Item-Level Push. Coaching für dich! Play with a Pro! Oder komm ich deine Traumgilde und erspiele dir mit Profis deine Erfolge! [mmo-prof.de]
	"lootrun.*selfplay.*piloted.*gunstig", --WTS: ▌▌DIE PRÜFUNG DER TAPFERKEIT 3/3 (Heroisch) LOOTRUN▌▌SELFPLAY/PILOTED ▌▌ MASTER LOOT(Plündermeister ) ▌▌HEUTE 21:00 CET▌▌SEHR GÜNSTIG ▌▌ Ermäßigung für Stoff, Kette und Platte ▌▌ /w ▌▌
	"rocketgaming.*mount.*skype", --RocketGaming die 1.Slots verfügbaren IDs von Emerald Nightmare HC/Myth, auch Nighthold sei der erste mit dem Guldan Mount! Hol dir die ClasshallTruhe der Mythic+ Inis für dein BiS Item, jede ID! Gladi/R1 Titel+Mount! Adde Skype: [christoph.rocket-gaming.]
	"wts.*alptraum.*mythisch.*boost.*boost.*glory", --WTS Der Smaragdgrüne Alptraum Mythisch/Heroisch/Normal boosting,Karazhan boost, Mythischer Schlüsselstein boost 1-10+lvl, Mythisch dungeons boost, Glory of the Legion Hero
}

local repTbl = {
	--Symbol & space removal
	["[%*%-%(%)\"!%?`'_%+#%%%^&;:~{} ]"]="",
	["¨"]="", ["”"]="", ["“"]="", ["▄"]="", ["▀"]="", ["█"]="", ["▓"]="", ["▲"]="", ["◄"]="", ["►"]="", ["▼"]="",
	["░"]="", ["♥"]="", ["♫"]="", ["●"]="", ["■"]="", ["☼"]="", ["¤"]="", ["☺"]="", ["↑"]="", ["«"]="", ["»"]="",
	["▌"]="", ["√"]="", ["《"]="", ["》"]="",

	--This is the replacement table. It serves to deobfuscate words by replacing letters with their English "equivalents".
	["а"]="a", ["à"]="a", ["á"]="a", ["ä"]="a", ["â"]="a", ["ã"]="a", ["å"]="a", ["Ą"]="a", ["ą"]="a", --First letter is Russian "\208\176". Convert > \97. Note: Ą fail with strlower, include both.
	["с"]="c", ["ç"]="c", ["Ć"]="c", ["ć"]="c", --First letter is Russian "\209\129". Convert > \99. Note: Ć fail with strlower, include both.
	["е"]="e", ["è"]="e", ["é"]="e", ["ë"]="e", ["ё"]="e", ["ę"]="e", ["ė"]="e", ["ê"]="e", ["Ě"]="e", ["ě"]="e", ["Ē"]="e", ["ē"]="e", ["Έ"]="e", ["έ"]="e", ["Ĕ"]="e", ["ĕ"]="e", --First letter is Russian "\208\181". Convert > \101. Note: Ě, Ē, Έ, Ĕ fail with strlower, include both.
	["Ğ"]="g", ["ğ"]="g", ["Ĝ"]="g", ["ĝ"]="g", ["Ģ"]="g", ["ģ"]="g", -- Convert > \103. Note: Ğ, Ĝ, Ģ fail with strlower, include both.
	["ì"]="i", ["í"]="i", ["ï"]="i", ["î"]="i", ["ĭ"]="i", ["İ"]="i", --Convert > \105
	["к"]="k", ["ķ"]="k", -- First letter is Russian "\208\186". Convert > \107
	["Μ"]="m", ["м"]="m", -- First letter is capital Greek μ "\206\156". Convert > \109
	["о"]="o", ["ò"]="o", ["ó"]="o", ["ö"]="o", ["ō"]="o", ["ô"]="o", ["õ"]="o", ["ő"]="o", ["ø"]="o", ["Ǿ"]="o", ["ǿ"]="o", ["Θ"]="o", ["θ"]="o", ["○"]="o", --First letter is Russian "\208\190". Convert > \111. Note: Ǿ, Θ fail with strlower, include both.
	["р"]="p", --First letter is Russian "\209\128". Convert > \112
	["Ř"]="r", ["ř"]="r", ["Ŕ"]="r", ["ŕ"]="r", ["Ŗ"]="r", ["ŗ"]="r", --Convert > \114. -- Note: Ř, Ŕ, Ŗ fail with strlower, include both.
	["Ş"]="s", ["ş"]="s", ["Š"]="s", ["š"]="s", ["Ś"]="s", ["ś"]="s", --Convert > \115. -- Note: Ş, Š, Ś fail with strlower, include both.
	["т"]="t", --Convert > \116
	["ù"]="u", ["ú"]="u", ["ü"]="u", ["û"]="u", --Convert > \117
	["ý"]="y", ["ÿ"]="y", --Convert > \121
	["•"]=".", ["º"]="o",
}

local strfind = string.find
local IsSpam = function(msg)
	for i=1, #instantReportList do
		if strfind(msg, instantReportList[i]) then
			return true
		end
	end

	local points, boostingPoints = 0, 0
	for i=1, #whiteList do
		if strfind(msg, whiteList[i]) then
			points = points - 2
		end
	end
	for i=1, #commonList do
		if strfind(msg, commonList[i]) then
			points = points + 1
		end
	end
	for i=1, #sites do
		if strfind(msg, sites[i]) then
			points = points + 3
			boostingPoints = boostingPoints + 3
		end
	end

	for i=1, #boostingWhiteList do
		if strfind(msg, boostingWhiteList[i]) then
			boostingPoints = boostingPoints - 1
		end
	end
	for i=1, #boostingList do
		if strfind(msg, boostingList[i]) then
			boostingPoints = boostingPoints + 1
		end
	end

	return report
end

--[[ Chat Scanning ]]--
local Ambiguate, BNGetGameAccountInfoByGUID, gsub, lower, next, type, tremove = Ambiguate, BNGetGameAccountInfoByGUID, gsub, string.lower, next, type, tremove
local IsCharacterFriend, IsGuildMember, UnitInRaid, UnitInParty, CanComplainChat = IsCharacterFriend, IsGuildMember, UnitInRaid, UnitInParty, CanComplainChat
local blockedLineId, chatLines, chatPlayers = 0, {}, {}
local spamCollector, spamLogger, prevShow = {}, {}, 0
local btn, reportFrame
local function BadBoyIsFriendly(name, flag, lineId, guid)
	if not guid then return true end -- LocalDefense automated prints
	if not guid:find("^Player") then
		local msg = "BadBoy: Unexpected GUID requested by an addon: ".. guid
		print(msg)
		geterrorhandler()(msg)
		return true
	end
	local _, characterName = BNGetGameAccountInfoByGUID(guid)
	if characterName or not CanComplainChat(lineId) or IsGuildMember(guid) or IsCharacterFriend(guid) or UnitInRaid(name) or UnitInParty(name) or flag == "GM" or flag == "DEV" then
		return true
	end
end
local function Cleanse(msg)
	msg = lower(msg) --Lower all text, remove capitals
	for k,v in next, repTbl do
		msg = gsub(msg, k, v)
	end
	return msg
end
local eventFunc = function(_, event, msg, player, _, _, _, flag, channelId, channelNum, _, _, lineId, guid)
	blockedLineId = 0
	if event == "CHAT_MSG_CHANNEL" and (channelId == 0 or type(channelId) ~= "number") then return end --Only scan official custom channels (gen/trade)

	local trimmedPlayer = Ambiguate(player, "none")
	if BadBoyIsFriendly(trimmedPlayer, flag, lineId, guid) then return end

	local debug = msg --Save original message format
	msg = Cleanse(msg)

	--20 line text buffer, this checks the current line, and blocks it if it's the same as one of the previous 20
	if event == "CHAT_MSG_CHANNEL" then
		for i=1, #chatLines do
			if chatLines[i] == msg and chatPlayers[i] == guid then --If message same as one in previous 20 and from the same person...
				blockedLineId = lineId
				--
				if spamCollector[guid] and IsSpam(msg) then -- Reduce the chances of a spam report expiring (line id is too old) by refreshing it
					spamCollector[guid] = lineId
					if BADBOY_OPTIONS.tipSpam then
						spamLogger[guid] = debug
					end
				end
				--
				return
			end
			if i == 20 then tremove(chatLines, 1) tremove(chatPlayers, 1) end --Don't let the DB grow larger than 20
		end
		chatLines[#chatLines+1] = msg
		chatPlayers[#chatPlayers+1] = guid
	end
	--End text buffer

	if IsSpam(msg) then
		if BadBoyLog then
			BadBoyLog("BadBoy", event, trimmedPlayer, debug)
		end
		if (not BADBOY_BLACKLIST or not BADBOY_BLACKLIST[guid]) and not IsEncounterInProgress() then
			spamCollector[guid] = lineId
			if BADBOY_OPTIONS.tipSpam then
				spamLogger[guid] = debug
				if btn:IsShown() and reportFrame:IsMouseOver() then
					GameTooltip_Hide()
					reportFrame:GetScript("OnEnter")(reportFrame) -- Add more spam to tooltip if shown
				end
			end

			local t = GetTime()
			if t-prevShow > 90 then
				if prevShow == 0 then
					prevShow = t+25
					-- Delay the first one to grab more spam on really bad realms
					C_Timer.After(25, function() btn:Show() end)
				else
					prevShow = t
					btn:Show()
				end
			end
		end
		blockedLineId = lineId
		return
	end
end
local filterFunc = function(_, _, _, _, _, _, _, _, _, _, _, _, lineId)
	if blockedLineId == lineId then
		return true
	end
end

do
	btn = CreateFrame("Frame", nil, ChatFrame1)
	btn:SetWidth(50)
	btn:SetHeight(50)
	btn:SetPoint("BOTTOMRIGHT", 18, -20)
	btn:SetFrameStrata("DIALOG")
	local tx = btn:CreateTexture()
	tx:SetAllPoints(btn)
	tx:SetMask("Interface\\CharacterFrame\\TempPortraitAlphaMask")
	tx:SetTexture(132360) -- Interface/Icons/Ability_Warrior_ShieldMastery
	local animGroup = btn:CreateAnimationGroup()
	animGroup:SetLooping("REPEAT")
	local scale = animGroup:CreateAnimation("Scale")
	scale:SetOrder(1)
	scale:SetFromScale(0.25,0.25)
	scale:SetToScale(1,1)
	scale:SetDuration(0.4)
	local scale2 = animGroup:CreateAnimation("Scale")
	scale2:SetOrder(2)
	scale2:SetFromScale(1,1)
	scale2:SetToScale(0.25,0.25)
	scale2:SetDuration(0.4)
	scale2:SetEndDelay(8)
	animGroup:Play()
	btn:Hide()

	reportFrame = CreateFrame("Button", nil, btn)
	reportFrame:SetAllPoints(ChatFrame1)
	reportFrame:SetFrameStrata("DIALOG")
	local ticker = nil
	local tickerFunc = function()
		local canReport = false
		for k, v in next, spamCollector do
			if CanComplainChat(v) then
				canReport = true
			else
				spamCollector[k] = nil
				spamLogger[k] = nil
			end
		end
		if not canReport then
			btn:Hide()
		end
	end
	btn:SetScript("OnShow", function()
		if ticker then ticker:Cancel() end
		ticker = C_Timer.NewTicker(5, tickerFunc)
		tickerFunc()
		-- Don't animate if the feature is disabled
		if animGroup:IsPlaying() and BADBOY_OPTIONS.noAnim then
			btn:SetWidth(12)
			btn:SetHeight(12)
			animGroup:Stop()
			btn:ClearAllPoints()
			btn:SetPoint("BOTTOMRIGHT", 0, -5)
		elseif not animGroup:IsPlaying() and not BADBOY_OPTIONS.noAnim then
			btn:SetWidth(46)
			btn:SetHeight(46)
			animGroup:Play()
			btn:ClearAllPoints()
			btn:SetPoint("BOTTOMRIGHT", 18, -20)
		end
	end)
	btn:SetScript("OnHide", function()
		if ticker then
			ticker:Cancel()
			ticker = nil
		end
	end)
	reportFrame:SetScript("OnClick", function(self, btn)
		if IsAltKeyDown() then -- Dismiss
			prevShow = GetTime() -- Refresh throttle so we don't risk showing again straight after reporting
			self:GetParent():Hide()
			for k, v in next, spamCollector do
				spamCollector[k] = nil
				spamLogger[k] = nil
			end
		else -- Report
			prevShow = GetTime() -- Refresh throttle so we don't risk showing again straight after reporting
			self:GetParent():Hide()

			local systemMsg = {GetFramesRegisteredForEvent("CHAT_MSG_SYSTEM")} -- Don't show the "Complaint Registered" message
			local infoMsg = {GetFramesRegisteredForEvent("UI_INFO_MESSAGE")} -- Don't show the "Thanks for the report" message
			local calendarError = {GetFramesRegisteredForEvent("CALENDAR_UPDATE_ERROR")} -- Remove calendar error popup (Blizz bug)
			local reportSubmit = {GetFramesRegisteredForEvent("PLAYER_REPORT_SUBMITTED")} -- Fix clearing chat that shouldn't be cleared (Blizz bug)
			for i = 1, #systemMsg do
				systemMsg[i]:UnregisterEvent("CHAT_MSG_SYSTEM")
			end
			for i = 1, #infoMsg do
				infoMsg[i]:UnregisterEvent("UI_INFO_MESSAGE")
			end
			for i = 1, #calendarError do
				calendarError[i]:UnregisterEvent("CALENDAR_UPDATE_ERROR")
			end
			for i = 1, #reportSubmit do
				reportSubmit[i]:UnregisterEvent("PLAYER_REPORT_SUBMITTED")
			end

			for k, v in next, spamCollector do
				if CanComplainChat(v) then
					BADBOY_BLACKLIST[k] = true
					ReportPlayer("spam", v)
				end
				spamCollector[k] = nil
				spamLogger[k] = nil
			end

			for i = 1, #systemMsg do
				systemMsg[i]:RegisterEvent("CHAT_MSG_SYSTEM")
			end
			for i = 1, #infoMsg do
				infoMsg[i]:RegisterEvent("UI_INFO_MESSAGE")
			end
			for i = 1, #calendarError do
				-- There's a delay before the event fires
				C_Timer.After(5, function() calendarError[i]:RegisterEvent("CALENDAR_UPDATE_ERROR") end)
			end
			for i = 1, #reportSubmit do
				reportSubmit[i]:RegisterEvent("PLAYER_REPORT_SUBMITTED")
			end
		end
	end)
	reportFrame:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		GameTooltip:AddLine(L.spamBlocked, 1, 1, 1)
		GameTooltip:AddLine(L.clickToReport, 1, 1, 1)
		if next(spamLogger) then
			GameTooltip:AddLine(" ", 0.5, 0.5, 1)
			for k, v in next, spamLogger do
				GameTooltip:AddLine(v, 0.2, 1, 0)
			end
		end
		GameTooltip:Show()
	end)
	reportFrame:SetScript("OnLeave", GameTooltip_Hide)
	local function a(t) local n = {} for i=1,#t do n[i] = t[i] end return n end
	if bbdbgn then bbdbgn(a(commonList), a(boostingList), a(boostingWhiteList), a(whiteList), a(sites), a(instantReportList), a(repTbl)) end
end

--[[ Add Filters ]]--
do
	local f = CreateFrame("Frame")
	f:SetScript("OnEvent", eventFunc)
	local tbl = {
		"CHAT_MSG_CHANNEL",
		"CHAT_MSG_YELL",
		"CHAT_MSG_SAY",
		"CHAT_MSG_WHISPER",
		"CHAT_MSG_EMOTE",
		"CHAT_MSG_DND",
		"CHAT_MSG_AFK",
	}
	for i = 1, #tbl do
		local event = tbl[i]
		local frames = {GetFramesRegisteredForEvent(event)}
		f:RegisterEvent(event)
		ChatFrame_AddMessageEventFilter(event, filterFunc)
		for i = 1, #frames do
			local frame = frames[i]
			frame:UnregisterEvent(event)
			frame:RegisterEvent(event)
		end
	end
end

--[[ Blacklist ]]--
do
	local f = CreateFrame("Frame")
	f:RegisterEvent("ADDON_LOADED")
	f:RegisterEvent("PLAYER_LOGIN")
	f:SetScript("OnEvent", function(frame, event, addon)
		if addon == "BadBoy" then
			if type(BADBOY_OPTIONS) ~= "table" then BADBOY_OPTIONS = {} end
			if type(BADBOY_BLACKLIST) ~= "table" then BADBOY_BLACKLIST = {} end
			frame:UnregisterEvent(event)
		elseif event == "PLAYER_LOGIN" then
			-- Blacklist DB setup, needed since Blizz nerfed ReportPlayer so hard the block sometimes only lasts a few minutes.
			local _, _, day = CalendarGetDate()
			if BADBOY_BLACKLIST.dayFromCal ~= day then
				BADBOY_BLACKLIST = {dayFromCal = day} -- Can't use ADDON_LOADED as CalendarGetDate isn't always ready on very first login.
			end
			SetCVar("spamFilter", 1)
			frame:UnregisterEvent(event)
			frame:SetScript("OnEvent", nil)
		end
	end)
end

_G.BadBoyIsFriendly = BadBoyIsFriendly
