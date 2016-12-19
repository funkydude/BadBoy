
-- GLOBALS: BADBOY_BLACKLIST, BADBOY_OPTIONS, BadBoyLog, ChatFrame1, GetTime, print, ReportPlayer, CalendarGetDate, SetCVar
-- GLOBALS: GameTooltip, C_Timer, IsEncounterInProgress, GameTooltip_Hide
local L
local commonList, boostingList, boostingWhiteList, whiteList, sites, instantReportList
do
	local _
	_, L = ...

	local as = LibStub("AceSerializer-3.0")
	_, commonList = as:Deserialize("^1^T^N1^Sbonus^N2^Sbuy^N3^Scheap^N4^Scode^N5^Scoupon^N6^Scustomer^N7^Sdeliver^N8^Sdiscount^N9^Sexpress^N10^Sg[0o]ld^N11^Slowest^N12^Smount^N13^Sorder^N14^Spowerle?ve?l^N15^Sprice^N16^Spromoti[on][gn]^N17^Sreduced^N18^Srocket^N19^Ssa[fl]e^N20^Sserver^N21^Sservice^N22^Sstock^N23^Sstore^N24^Strusted^N25^Swell?come^N26^S%d+k[\\/=]%d+euro^N27^S%d+%$[\\/=]%d+g^N28^Slivraison^N29^Smoinscher^N30^Sprix^N31^Scommande^N32^Sbilligster^N33^Slieferung^N34^Spreis^N35^Swillkommen^N36^Sbarato^N37^Sgratuito^N38^Srapid[oe]^N39^Sseguro^N40^Sservicio^t^^")
	_, boostingList = as:Deserialize("^1^T^N1^Spaypal^N2^Sskype^N3^Sb[o0][o0]st^N4^Sarena^N5^Srbg^N6^Sgladiator^N7^Sservice^N8^Scheap^N9^Sfast^N10^Ssafe^N11^Sprice^N12^Saccount^N13^Srating^N14^Slegal^N15^Sguarantee^N16^Sm[o0]unt^N17^Ssale^N18^Sseason^N19^Sprofessional^N20^Sexperience^N21^Scustomer^N22^Sdiscount^N23^Sselfplay^N24^Scoaching^N25^Slive^N26^Smythic^N27^Sleveling^N28^Saccshar[ei]^N29^Ssecure^N30^Sdelivery^N31^Sstore^N32^Spri?est[ie]ge^N33^Squality^N34^Spil[o0]ted^N35^Sartifactpower^N36^Sunlock^N37^Squantity^t^^")
	_, boostingWhiteList = as:Deserialize("^1^T^N1^Smembers^N2^Sguild^N3^Ssocial^N4^S|hspell^N5^S%d+k[/\\]?dungeon^N6^S%d+k[/\\]?each^N7^Sonlyacceptinggold^N8^Sgoldonly^N9^Sgoldprices^N10^Sforgold^N11^S%d+kperrun^N12^Stonight^N13^Sgametime^N14^Sservertime^N15^Sentrance^N16^S%.battle%.net/^N17^Srecrui?t^N18^Sask^N19^Sappl[iy]^N20^Senjin%.com^N21^Sguildlaunch%.com^N22^Sgamerlaunch%.com^N23^Scorplaunch%.com^N24^Swowlaunch%.com^N25^Swowstead%.com^N26^Sguildwork.com^N27^Sguildportal%.com^N28^Sguildomatic%.com^N29^Sguildhosting.org^N30^S%.wix%.com^N31^Sshivtr%.com^N32^Sown3d%.tv^N33^Sustream%.tv^N34^Stwitch%.tv^t^^")
	_, whiteList = as:Deserialize("^1^T^N1^S%.battle%.net/^N2^Srecrui?t^N3^Sdkp^N4^Slooking^N5^Slf[gm]^N6^S|cff^N7^Sraid^N8^Sscam^N9^Sroleplay^N10^Sphysical^N11^Sappl[iy]^N12^Senjin%.com^N13^Sguildlaunch%.com^N14^Sgamerlaunch%.com^N15^Scorplaunch%.com^N16^Swowlaunch%.com^N17^Swowstead%.com^N18^Sguildwork.com^N19^Sguildportal%.com^N20^Sguildomatic%.com^N21^Sguildhosting.org^N22^S%.wix%.com^N23^Sshivtr%.com^N24^Sown3d%.tv^N25^Sustream%.tv^N26^Stwitch%.tv^N27^Ssocial^N28^Sfortunecard^N29^Shouse^N30^Sjoin^N31^Scommunity^N32^Sguild^N33^Sprogres^N34^Stransmor?g^N35^Sarena^N36^Sboost^N37^Splayers^N38^Sportal^N39^Stown^N40^Ssynonym^N41^S[235]v[235]^N42^Ssucht^N43^Sgilde^N44^Srekryt^N45^Ssoker^N46^Skilta^N47^Setsii^N48^Ssosyal^N49^Sдкп^N50^Speкpуt^N51^Sнoвoбpaн^N52^Sлфг^N53^Speйд^t^^")
	_, sites = as:Deserialize("^1^T^N1^Sprestigewow[%.,]c[0o]m^N2^Sfarm4gold[%.,]com^N3^Sdving[%.,]net^N4^Sspeedruncharacter[%.,]net^N5^Sboosthive[%.,]eu^N6^Sleprestore[%.,]com^N7^S1proboost[%.,]com^N8^Shordebank[%.,]com^N9^Sjustboost[%.,]net^N10^Spvpok[%.,]c[0o]m^N11^Sboostila[%.,]com^N12^Spewpewshop[%.,]pro^N13^Sperfectway[%.,]one^N14^Sdemonboost[%.,]com^N15^Sbestboost[%.,]club^N16^Sbestboost[%.,]com^N17^Stopboost[%.,]pro^N18^Sgamesales[%.,]pro^N19^Smythicstore[%.,]com^t^^")
	_, instantReportList = as:Deserialize("^1^T^N1^S%d+.*d[ou][ub]ble.*%d+.*trip^N2^Scasino.*%d+x2.*%d+x3^N3^Scasino.*%d+.*double.*%d+.*tripp?le^N4^Scasino.*whisper.*info^N5^Sd[ou][ub]ble.*%d+.*tripp?le^N6^Scasino.*bet.*%d+^N7^Sroll.*%d+.*roll.*%d+.*bet^N8^Scasino.*roll.*double^N9^Scasino.*roll.*%d+.*roll.*%d+^N10^Sdouble.*tripp?le.*casino^N11^Scasino.*legit.*safe.*casino^N12^Sluck.*roll.*%d+k.*minutes.*pst^N13^Sroll.*win.*double.*min.*max^N14^Scasino.*/w.*%d+.*roll^N15^Swt[bst]rs3?gold.*wowgold^N16^Swt[bs]wowgold.*rsgold^N17^Swt[bs]wowgold.*rscoint?s^N18^Swt[bs]runescapegold^N19^Sexchangingrsgold^N20^Sgoldforrunescapegold^N21^Sbuying?runescape[ag]^N22^Swt[bs]runescapeaccount^N23^Swt[bs]runescapepure^N24^Swt[bs].*runescapemoney.*%d+k^N25^S~}wt[bs]rsaccount^N26^S~}wt[bs]%d+rsaccount^N27^S~}wt[bs]a?n?awesomersaccount^N28^Srunescapegoldforwowgold^N29^S~}buyingrs3stuff^N30^S~}wt[bst]somecsgoskin^N31^S~}wt[bst]cs%.?goskin^N32^S~}wt[bst]csgokey^N33^S~}wt[bst]csgoacc^N34^S~}wt[bst]csgokni[fv]e^N35^S~}wt[bst]csgoitem^N36^S~}wt[bst]csgocase^N37^S~}wt[bst]anycsgoskin^N38^S~}buyingcs%.?g[0o]skin^N39^S~}buyingcheapcsgoskin^N40^S~}buyingcsgokey^N41^S~}buyingcsgokni[fv]e^N42^S~}sellingcsgoskin^N43^S~}sellingsomecsgocase^N44^S~}sellingcsgocase^N45^S~}sellingcsgoitem^N46^S~}wt[bst]csskins^N47^S~}wt[bst]keysincsgo^N48^Swanttobuy[/\\]sellcsgoitem^N49^Swanttosell[/\\]buycsgoitem^N50^Swowgoldforcsgokey^N51^S~}wt[bst]csgocamo^N52^S~}wt[bst]cheapcsgoskin^N53^S~}wt[bst]csgocdkee?y^N54^S~}tradingcsgo.*gold^N55^S~}wt[bst]csgocheap^N56^S~}wt[bst]goldforcsgo^N57^S~}wt[bst]mygoldforcsgoskins^N58^S~}wt[bst]mywowgold.*csgoskin^N59^S~}sellinggolds?forcsgo^N60^S~}wt[bst]csgosteamgift^N61^S~}wtsstarcraft.*cdkey.*gold^N62^S~}sellingdota2^N63^S~}wt[bst]dota2^N64^S~}buyingdotaitems^N65^S~}buyingdota2^N66^S~}wt[bst]alldota2^N67^S~}wtssteamaccount^N68^S~}sellingborderlands2^N69^S~}wtssteamwalletcode^N70^S~}wt[bs]lolacc$^N71^S~}wt[bs]%d?x?leagueoflegends?account^N72^S~}wt[bst]m?y?lolaccount^N73^S~}sellingloleuw?acc.*info^N74^S~}wt[bs].*leagueoflegends.*points.*pay^N75^Swts.*leagueoflegends.*acc.*info^N76^Ssellingm?y?leagueoflegends^N77^S~}wt[bs]lolacc.*cheap^N78^S~}wt[bs]lolacc.*skins^N79^S~}wt[bst]mygold%d*leagueoflegends^N80^S~}sellingwowgoldforleagueoflegends^N81^S~}wt[bs]lolacc.*gold^N82^Sselling.*accounts?forgold^N83^Swtsnonemergeacc.*lvl?%d+char^N84^Slvl?%d+char%.?allclass.*info^N85^Slvl?%d+char.*fast.*g[o0]ld^N86^S%d+lvloldaccounts?tosell^N87^Swtswowaccount.*epic^N88^S~}wanttotradeaccount^N89^S~}wttacc.*epic.*mount.*/w^N90^S~}wttacc?ount.*gear.*char^N91^S~}wt[st]wowaccount^N92^S~}wt[bs]mopcode^N93^S~}wttaccountfor.*youget.*tier^N94^S~}wt[st]accountwith^N95^S~}wt[bst]legionkey^N96^S~}wt[bst]legioncdkey^N97^Ssell.*brazzersaccount.*info^N98^S~}wtsbrazzersaccount^N99^S~}wttrade%d+kgold.*diablo^N100^S~}wttwowgold.*diablo^N101^S~}wtbd3forgold^N102^S~}sellingdiablo3^N103^S~}sellingd3account^N104^S~}wtscheapfastd3g^N105^S~}wt[bs]d3key^N106^S~}wts.*%d+day.*diablo.*account^N107^Stradediablo3?goldforwowgold^N108^S~}selling.*gamecard.*diablo^N109^S~}wt[bs]d3account^N110^S~}wtsd3.*transfer.*item^N111^S~}wt[bs]diablo3^N112^S~}wt[bst]wowgold.*d3gold^N113^Swowgoldfory?o?u?r?d3gold^N114^Swowgold.*fordiablo3?gold^N115^Stradediablo3?gold.*wowgold^N116^S~}wt[bs]diablogold^N117^Strading.*fordiablo3?gold^N118^Sdiablogoldforwowgold^N119^S~}wt[bst].*d3gold.*wowgold^N120^S~}wtt.*mygold.*diablo3gold^N121^Swowgoldforyourdiablo3?gold^N122^Swts.*diablo3goldfor%d+^N123^S~}wtscheapgold^N124^S~}wtscheapandfastgold^N125^S~}wtbgold.*gametime^N126^S~}wtbgold.*mount^N127^S~}wt[bs]gametime^N128^S~}wt[bs]prepaidcard^N129^S~}wt[bs]gamecard^N130^S~}wt[bs]gamecode^N131^S~}wt[bs]prepaidgamecard^N132^S~}wt[bs]%d+day.*gamecard^N133^S~}wt[bs]%d+month.*gametime^N134^S~}wt[bs][36]0days?prepaidgametime^N135^S~}wts%d+days?gametime^N136^S~}wts%d+days?gamecard^N137^S~}wts%d+kfor%d+eu^N138^Swts%d+kgoldfor%d+eu^N139^Stitaniumbay.*extra^N140^Stitaniumbay.*livraison^N141^Stitaniumbay.*obtenez^N142^Stitaniumbay.*minut[eo]^N143^Stitaniumbay.*gold^N144^Stitaniumbay.*gratis^N145^Sskype.*findguys^N146^Swts.*help.*mythic.*dungeon.*gear.*info^N147^Swts.*le?ve?ling.*power.*farming.*info^N148^Swts.*spot.*heroic.*raid.*loot.*spec.*invite^N149^Swts.*help.*honor.*prestige.*season.*info^N150^Sselling.*glory.*fast.*stress.*ilvl.*info^N151^Sloot.*piloted.*today.*%d%d%d%d.*whisper^N152^Sloot.*piloted.*now.*discount.*whisper^N153^Sloot.*piloted.*%d%d%d%d.*price.*whisper^N154^Swts.*arena.*rbg.*rating.*loot.*info^N155^Swts.*dungeon.*fast.*prestige.*emerald.*info^N156^Swts.*fast.*dungeon.*rbg.*emerald.*info^N157^Swts.*fast.*dungeon.*pvp.*emerald.*info^N158^Swts.*character.*dungeon.*pvp.*emerald.*info^N159^Swts.*lift.*dungeon.*pvp.*emerald.*info^N160^Swts.*boost.*dungeon.*pvp.*emerald.*info^N161^Swts.*le?ve?ll?i?n?g?.*dungeon.*pvp.*emerald.*info^N162^Sselling.*rbg.*honor.*mount.*selfplay^N163^Sselling.*mount.*honor.*gear.*accshare.*^N164^Srbg.*artifact.*mount.*accshar^N165^Sheroic.*amazingprice.*strong.*group.*gua?rantee.*drop.*spot^N166^Swts.*tonight.*arena.*rbg.*mythic.*coaching^N167^Slegion.*gametime.*iranblizzard[%.,]com^N168^Sbank4dh.*skype^N169^Sbank4dh.*%d+k^N170^Strusted.*bank4dh^N171^Swts.*mythic.*powerle?ve?l.*glory.*info^N172^Smythic.*boostinglive.*faster^N173^Skoroboost.*everyday.*mythic^N174^Sdoyouwant.*level110.*12h.*noproblem.*msgme.*info^N175^Srbg.*artifact.*honor.*mount.*carry^N176^S~}wtspowerleveling.*fast^N177^Sfast.*leveling.*honor.*в[o0][o0]st^N178^S~}wtsmythickarazhandungeons[,.]*whispme^N179^S~}wtskarazhanboost[,.]mythic.*mythicdungeons?boost.*info^N180^S~}wtskarazhan[,.]mythic.*mythic+dungeon$^N181^S~}wtsboostkarazhan[,.]mythic[,.]mythicdungeon^N182^S~}wtskarazhan.*,mythic.*mythicdungeons?boost$^N183^Srbg.*boost.*2200.*yourself.*account.*sharing.*info^N184^Srbg.*honor.*priestige.*mount.*selfplay^N185^Spowerle?ve?l.*yourspuregame[,.]com^N186^Sxperiencedparty.*runs.*walkthrough.*mythic.*glory.*karazhan^N187^Swh?isp.*skype.*igor.*price^N188^Selitistgaming[,.]com.*mount^N189^Sjuststarted.*leveling.*twink.*gear.*dungeon.*more^N190^Swts.*saddle.*carry.*hour.*start.*info^N191^Sgetgearup.*karazhan.*nightmare.*dungeons.*runs.*more^N192^Swts.*mythic.*master.*loot.*mythic.*details.*private^N193^Swts.*nightmare.*boosting.*loot.*mythic.*glory^N194^Sskype.*landroshop^N195^Swtskarazhan.*timerun.*mount.*mythic.*dungeonboost^N196^Ssaddle.*conquestcapped[%.,]com^N197^S~}wts.*good.*fast.*powerle?ve?l^N198^Sservice.*mythic.*raid.*pay.*price^N199^Swts.*karazhan.*mount.*nightmare.*hc.*dungeon.*run.*more^N200^Soffer.*honor.*prestige.*boost.*pvp.*mount^N201^Sbrb2game.*sale^N202^S~}wtsemeraldnightmare.*heroic.*pl.*tonight.*8.*fastrun.*highquality^N203^Selitegamerboosting[%.,]de.*skype^N204^Swts.*nightmare.*mythic.*loot.*dungeon.*pvp.*glory^N205^Sjuststarted.*legion.*gearup.*karazhan.*nightmare.*dungeon.*more^N206^S%d+k.*giveaway.*guild.*selling.*karazhan.*mount.*mythic.*dungeon.*nightmare.*raid^N207^Sl[o0][o0]tcl[o0]ud.*b[o0][o0][s5]t^N208^Swtskara.*fasttimerun.*guarantee.*mount^N209^Swtsarena.*boost.*2%.?200.*2%.?400.*gladiator.*info^N210^Swts.*nightmare.*mythic.*master.*loot.*quickraids.*everyday.*write^N211^S2.*2%.4.*glad.*le?ve?ling.*100110.*info$^N212^S2.*2%.4.*glad.*coach.*100110.*info$^N213^Sarena.*2%.4.*2.*glad.*teammates.*push^N214^Sb[o0][o0]st.*2%.4.*2.*glad.*livestream.*info$^N215^Sb[o0][o0]st.*2%.4.*2.*glad.*selfplay.*info$^N216^Sarena.*2%.4.*2.*glad.*livestream.*info$^N217^Swtsemeraldnightmarelootraids.*heroic.*mythic.*dungeons.*wisp$^N218^Swts.*mythic.*boosting.*loot.*keystone.*dungeon.*glory^N219^Sselling.*professional.*team.*mount.*loot^N220^S~}wtslegiondungeons.*mythic,karazhan$^N221^Swts.*valor.*lootrun.*mythic.*mount.*prestige^N222^Shello.*2200.*glad.*le?ve?ling.*info^N223^Skarazhanmount.*nightmareruns.*spotsleft.*contact.*details$^N224^Strial.*karazhanmount.*nightmareruns.*spotsleft.*contact.*details$^N225^Swts.*heroic.*raid.*fast.*quality.*discount.*selfplay^N226^S~}wts.*emeraldnightmare.*masterloottoday.*cheapandfast.*whisperme$^N227^Swtsrbg.*wins.*mount.*carry.*reins^N228^S~}wts.*viciousmounts.*saddle.*star.*getrightnow^N229^Swts.*today.*nightmare.*lootrun.*masterloot.*bestprice^N230^Swts.*valor.*lootrun.*mount.*mythic.*glory^N231^S~}wtsgamingservices.*pve/pvp.*write.*info^N232^S~}wtsenandtov.*mythic.*heroic.*boosting.*loot.*karazhan.*dungeonsboost^N233^Sgold.*g4game[%.,]c[o0]m^N234^Sgold.*g[o0]ldce[o0][%.,]c[o0]m^N235^S~}onespotleft.*nightmare.*mythicboost.*clear.*loot.*amazingprice.*raidstarts^N236^Strial.*valor.*nightmare.*myth.*karazhan.*powerleveling.*muchmor^N237^S~}wts.*nightmare.*mythicboost.*clear.*loot.*amazingprice.*raidstarts^N238^S.+%d+.+p[%.,@]*r[%.,@]*e[%.,@]*s[%.,@]*t[%.,@]*i[%.,@]*g[%.,@]*e[%.,@]*w[%.,@]*o[%.,@]*w[%.,][cf]^N239^Sp[%.,@]*r[%.,@]*e[%.,@]*s[%.,@]*t[%.,@]*i[%.,@]*g[%.,@]*e[%.,@]*w[%.,@]*o[%.,@]*w[%.,].+%d+.*^N240^Sskype.*vf3399^N241^Swtskarazhanwithmount.*mythicdungeons.*valor.*nightmare^N242^Sloot.*mount.*mythic.*dungeons.*ask^N243^Ssale.*mount.*loot.*mythic.*dungeons^N244^Swts.*mythic.*lootrun.*master.*fast.*cheap.*ready.*info^N245^Sselling.*nightmare.*heroic.*masterloot.*boost.*server.*info^N246^Swts.*xavius.*boost.*completed500.*curve.*%d+.*me.*info^N247^S~}wtsenmythiclootruntonight.*goldpossible.*w^N248^S~}wts.*keystoneconqueror.*karazhan.*fast,smoothandfair.*whisp^N249^S~}wtsen.*tov.*boost.*mythic.*karazhan.*mount.*info^N250^S~}wtstoday.*nightmaremythic.*master.*fastcheap.*info^N251^S~}=*wts=*today.*nightmaremythic.*master.*bestprice$^N252^Swts.*lootrun.*myth.*mount.*offers.*live^N253^Swtsfast.*smooth.*karazhan.*mount.*valor.*nightmare.*wisp^N254^Swts.*nightmare.*heroic.*ml.*quality.*discount.*come.*items^N255^Swts.*heroic.*raid.*tonight.*come.*items.*quality.*discount^N256^Swts.*nightmare.*valor.*le?ve?ling.*best.*info^N257^Srbg.*mount.*bop.*accshare^N258^Swts.*rbgs.*mounts.*saddle.*accshare^N259^S~}wts.*nightmare.*mythic.*gear.*gua?rantee.*amazing.*price.*details^N260^S~}wtsmount.*karazhan.*timerun.*quality.*service^N261^Swts.*mythic.*dungeon.*loot.*items.*le?ve?ling.*hours.*info^N262^Swts.*mythicplus.*timer.*loot.*gift.*write^N263^Swts.*heroic.*master.*loot.*mythic.*items.*guarantee.*info^N264^Swts.*today.*raid.*nightmare.*mythic.*heroic.*loot.*guarantee.*items^N265^S~}wtskarazhad?nrunwithmount.*startin%d+.*wformoreinfo$^N266^S~}wts.*nightmaremythic7/7ml.*to[dn].*fastcheap.*meformoreinfo^N267^S~}wtsnow.*nightmaremythic.*withmlfastcheap.*readytostartin%d+minute^N268^S~}wtstodaymythic.*higher.*hurry.*beforereset.*weeklychest.*write.*info^N269^Swts.*earnmount.*rank.*viciousmount.*selling.*accshare^N270^Swtsartifactpower.*mount.*saddle.*accshare^N271^Ssellingrbg.*honou?r.*mount.*accountshare^N272^Srbg.*mount.*prestige.*acco?u?n?t?share^N273^Stelegram.*amirangaming^N274^S~}wts.*tonight.*nightmare.*mythic.*masterloot.*guarantee.*cheap.*price^N275^Sstrongandskilledteam.*helpyouwithmythicdungeon.*upto%d+fastandeasy^N276^Sexperiencedteamoffriends.*helpyouwithmythicdungeon.*upto%d+inshorttime^N277^S~}wtsap.*update.*weap.*viciousmount.*accshare^N278^Sprestigewow[%.,@][cf].....................................^N279^Shelpyou.*skype.*warstre^N280^Swtsmythic.*runs.*difficulty.*karazhan.*mount.*selfplay.*runseveryday.*info^N281^S~}want.*level110.*within.*maybekarazhanmount.*mythic.*prestigelevels.*wisp^N282^S~}topguildinvit.*daily.*mythicdungeon.*kara.*raid.*brokenlyepic.*4hours.*msg^N283^Swww[%.,@]*prestigewow.....................................^N284^Sok4gold.*skype^N285^S微信.*549965838^N286^Sqq.*1505381907^N287^S微信.*1505381907^N288^Sqq.*1513941814^N289^Sqq.*593837031^N290^S100110.*q228102174^N291^Sgold.*eddie8806^N292^S100110.*苏拉玛任务.*星空龙^N293^S微信.*17788955341^N294^Sqq.*1433535628^N295^S低层三.*q1292706134^N296^S微信.*sesegold^N297^S%d+.*万金.*支付宝^N298^Sqq.*2278048179^N299^S金.*778587316^N300^S100110.*送坐骑.*tiger^N301^S100110.*币.*幽灵虎^N302^S~}marine.*在秒回^N303^S881.*安全便宜快速.*ip^N304^S特价出售黄金.*稀有坐骑^N305^S200万手工金币.*paypal^N306^Sqq.*153874069^N307^Sqq.*3450345^N308^S练级.*bearwow[,.]com^N309^S特价.*tiger.*稀有坐骑^N310^S出售特价金.*%d+for%d+k.*100110^N311^S拿任意橙.*神器三槽.*110^N312^S100110.*神器.*金^N313^Sqq.*100845995^N314^S个人品渣子.*profoundsea^N315^Sstyle.*快速练级.*50lvl^N316^S15版本和新春.*10^N317^S无限拾取套餐特价.*金币25^N318^S低价出售翡翠包团.*金25^N319^S低层刷橙装和高层拿低保.*大小幽灵虎等稀有坐骑^N320^S金币大量库存.*飞机头等坐骑^N321^S~}marine.*老牌华人实力公会^N322^S~}marine.*幻化^N323^S~}marine便宜金子^N324^S守望先锋上分.*2000.*3000.*前私密谈^N325^S金币大量库存.*欢迎咨询^N326^S~}style.*光龙无敌火鹰等热卖^N327^S圣诞节金币特价.*大小幽灵虎等坐骑^N328^S层箱子无限刷橙.*试炼包团^N329^S20for10w.*刷箱子^N330^S20=10w.*刷箱子^N331^S20刀?=10w.*另有黑市坐骑^N332^S清世界任务.*金%d+刀%d+万^N333^S无限拾取套餐特价.*金币二十万^N334^S热售翡翠梦境包团.*金币^N335^S工作室手工任务练级.*龙无敌火鹰等热卖^N336^S圣诞节大甩卖金币.*金子大甩卖^N337^S神器三槽.*金%d+刀%d+万^N338^S圣诞节金币大促销.*送坐骑^N339^S纯手工任务升级.*金%d+刀十万^N340^S喜迎7.15版本和新年.*%d+^N341^S卡拉赞全通打龙.*来就开来就开.*有需要的赶紧^N342^S公会专业队伍出售.*%d+usd^N343^S圣诞节大甩卖金币.*幽灵虎现货秒发金子^N344^Smaxlvl[%.,]net.*пpoдaжa^N345^Sцeн[ae].*lootkeeper[%.,]com^N346^Sdving[%.,]ru.*уcлуги^N347^Sнизkиeцeны.*getloot[%.,]ru^N348^Swowmart[%.,]ru.*зoлoto^N349^Srpggold[%.,]ru.*зoлoto^N350^Srpggold[%.,]ru.*гoлд^N351^Soro.*tutiendawow.*barato^N352^Sosboosting[%.,]com.*tarifs.*remise^N353^Swallgaming.*loot.*keystone^N354^Spvp.*wallgaming[%.,]com^N355^S~}sælgerguldfor%d+^N356^S~}sælgerg[ou]ld.*mobilepay^N357^Stilbud.*sælger%d+k.*mobilepay^N358^Ssælgerguld.*skype^N359^Ssælgerguld.*priser^N360^Ssælgerlidtguld.*mobilepay^N361^Ssælgerg.*%d+kr?pr^N362^Ssælgerguld.*info^N363^Snogen.*skalkobeg.*info^N364^Ssælgerguldviamp^N365^Ssælgerguldviamobile?pay^N366^Snogleg.*sælgerovermobilepay^N367^Ssælger%d+kguld.*mobile^N368^S~}sælgerguld.*skrivtilmig^N369^Smanglerdugold.*kroner.*mobilepay^N370^Ssælgerg.*mobilepay^N371^Ssaljerguld.*detail.*stock^N372^S~}saljerguldviaswish^N373^S~}saljergviaswish^N374^S~}saljerguldsnabbtviaswish^N375^S~}koperw?o?w?guldviaswish^N376^S~}kopergviaswish^N377^S~}guldfinns.*viaswish^N378^S~}saljerwowguld.*viaswish^N379^S~}saljer%d+kguldfor.*viaswish^N380^S~}saljerguld,swish^N381^Sguldkvar.*viaswish^N382^S~}guldviaswish^N383^S~}guld%d+k.*kr.*skype^N384^S~}saljerviaswish^N385^S~}gfinnsswish$^N386^S~}gfinnsbilligt$^N387^S~}gfinns@swish^N388^S~}%d+kfinns.*@swish^N389^S~}nagonsomsaljergu?l?d?viaswish^N390^S~}behoverdug@swish^N391^S~}gfinnsatt?kopa.*swish^N392^Sspelpengar@swish^N393^S~}guldfinns.*kopa.*swish$^N394^S~}gsaljsbilligt.*swish^N395^Sguldsalje[rs]viaswish^N396^S~}saljerwowguldgenomswish^N397^S~}saljerguldpaswish^N398^S~}wtbg[ou]ldviaswish^N399^S~}[vw]illkop[as]guldviaswish^N400^S~}billigtguldviaswish^N401^S~}guldsaljesbilligtswish^N402^S~}saljerg%.?$^N403^Sbesten.*skype.*sarmael.*coaching^N404^Smmoprof.*loot.*gold^N405^Smythic.*coaching.*mmoprof^N406^Slootrun.*selfplay.*piloted.*gunstig^N407^Srocketgaming.*mount.*skype^N408^Swts.*alptraum.*mythisch.*boost.*boost.*glory^t^^")
end


local repTbl = {
	--Symbol & space removal
	["[%*%-<>%(%)\"!%?`'_%+#%%%^&;:~{} ]"]="",
	["¨"]="", ["”"]="", ["“"]="", ["▄"]="", ["▀"]="", ["█"]="", ["▓"]="", ["▲"]="", ["◄"]="", ["►"]="", ["▼"]="",
	["░"]="", ["♥"]="", ["♫"]="", ["●"]="", ["■"]="", ["☼"]="", ["¤"]="", ["☺"]="", ["↑"]="", ["«"]="", ["»"]="",
	["▌"]="", ["√"]="", ["《"]="", ["》"]="", ["²"]="", ["´"]="",

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
local Spam = function(msg)
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

	local report = points > 3 or boostingPoints > 3
	return report
end

--[[ Chat Scanning ]]--
local Ambiguate, BNGetGameAccountInfoByGUID, gsub, lower, next, type, tremove = Ambiguate, BNGetGameAccountInfoByGUID, gsub, string.lower, next, type, tremove
local IsCharacterFriend, IsGuildMember, UnitInRaid, UnitInParty, CanComplainChat = IsCharacterFriend, IsGuildMember, UnitInRaid, UnitInParty, CanComplainChat
local blockedLineId, chatLines, chatPlayers, pl = 0, {}, {}, UnitLevel("player")
local spamCollector, spamLogger, prevShow = {}, {}, 0
local btn, reportFrame
local function IsFriendly(name, flag, lineId, guid)
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
	if event == "CHAT_MSG_WHISPER" and pl < 60 then return end

	local trimmedPlayer = Ambiguate(player, "none")
	if IsFriendly(trimmedPlayer, flag, lineId, guid) then return end

	local debug = msg --Save original message format
	msg = Cleanse(msg)

	--20 line text buffer, this checks the current line, and blocks it if it's the same as one of the previous 20
	if event == "CHAT_MSG_CHANNEL" then
		for i=1, #chatLines do
			if chatLines[i] == msg and chatPlayers[i] == guid then --If message same as one in previous 20 and from the same person...
				blockedLineId = lineId
				--
				if spamCollector[guid] and Spam(msg) then -- Reduce the chances of a spam report expiring (line id is too old) by refreshing it
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

	if Spam(msg) then
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

_G.BadBoyIsFriendly = IsFriendly
_G.BadBoyCleanse = Cleanse
