
-- GLOBALS: BADBOY_BLACKLIST, BADBOY_OPTIONS, BadBoyLog, ChatFrame1, GetTime, print, ReportPlayer, CalendarGetDate, SetCVar
-- GLOBALS: GameTooltip, C_Timer, IsEncounterInProgress, GameTooltip_Hide
local L
local commonList, boostingList, boostingWhiteList, whiteList, sites, instantReportList
do
	local _
	_, L = ...

	local as = LibStub("AceSerializer-3.0")
	_, commonList = as:Deserialize("^1^T^N1^Sbonus^N2^Sbuy^N3^Scheap^N4^Scode^N5^Scoupon^N6^Scustomer^N7^Sdeliver^N8^Sdiscount^N9^Sexpress^N10^Sg[0o]ld^N11^Slowest^N12^Smount^N13^Sorder^N14^Spowerle?ve?l^N15^Sprice^N16^Spromoti[on][gn]^N17^Sreduced^N18^Srocket^N19^Ssa[fl]e^N20^Sserver^N21^Sservice^N22^Sstock^N23^Sstore^N24^Strusted^N25^Swell?come^N26^S%d+k[\\/=]%d+euro^N27^S%d+%$[\\/=]%d+g^N28^Slivraison^N29^Smoinscher^N30^Sprix^N31^Scommande^N32^Sbilligster^N33^Slieferung^N34^Spreis^N35^Swillkommen^N36^Sbarato^N37^Sgratuito^N38^Srapid[oe]^N39^Sseguro^N40^Sservicio^t^^")
	_, boostingList = as:Deserialize("^1^T^N1^Spaypal^N2^Sskype^N3^Sb[o0][o0]st^N4^Sarena^N5^Srbg^N6^Sgladiator^N7^Sservice^N8^Scheap^N9^Sfast^N10^Ssafe^N11^Sprice^N12^Saccount^N13^Srating^N14^Slegal^N15^Sguarantee^N16^Sm[o0]unt^N17^Ssale^N18^Sseason^N19^Sprofessional^N20^Sexperience^N21^Scustomer^N22^Sdiscount^N23^Sselfplay^N24^Scoaching^N25^Smythic^N26^Sleveling^N27^Saccshar[ei]^N28^Ssecure^N29^Sdelivery^N30^Sstore^N31^Spri?est[ie]ge^N32^Squality^N33^Spil[o0]ted^N34^Sartifactpower^N35^Sunlock^N36^Squantity^t^^")
	_, boostingWhiteList = as:Deserialize("^1^T^N1^Smembers^N2^Sguild^N3^Ssocial^N4^S|hspell^N5^S%d+k[/\\]?dungeon^N6^S%d+k[/\\]?each^N7^Sonlyacceptinggold^N8^Sgoldonly^N9^Sgoldprices^N10^Sforgold^N11^S%d+kperrun^N12^Stonight^N13^Sgametime^N14^Sservertime^N15^Sentrance^N16^S%.battle%.net/^N17^Srecrui?t^N18^Sask^N19^Sappl[iy]^N20^Senjin%.com^N21^Sguildlaunch%.com^N22^Sgamerlaunch%.com^N23^Scorplaunch%.com^N24^Swowlaunch%.com^N25^Swowstead%.com^N26^Sguildwork.com^N27^Sguildportal%.com^N28^Sguildomatic%.com^N29^Sguildhosting.org^N30^S%.wix%.com^N31^Sshivtr%.com^N32^Sown3d%.tv^N33^Sustream%.tv^N34^Stwitch%.tv^t^^")
	_, whiteList = as:Deserialize("^1^T^N1^S%.battle%.net/^N2^Srecrui?t^N3^Sdkp^N4^Slooking^N5^Slf[gm]^N6^S|cff^N7^Sraid^N8^Sscam^N9^Sroleplay^N10^Sphysical^N11^Sappl[iy]^N12^Senjin%.com^N13^Sguildlaunch%.com^N14^Sgamerlaunch%.com^N15^Scorplaunch%.com^N16^Swowlaunch%.com^N17^Swowstead%.com^N18^Sguildwork.com^N19^Sguildportal%.com^N20^Sguildomatic%.com^N21^Sguildhosting.org^N22^S%.wix%.com^N23^Sshivtr%.com^N24^Sown3d%.tv^N25^Sustream%.tv^N26^Stwitch%.tv^N27^Ssocial^N28^Sfortunecard^N29^Shouse^N30^Sjoin^N31^Scommunity^N32^Sguild^N33^Sprogres^N34^Stransmor?g^N35^Sarena^N36^Sboost^N37^Splayers^N38^Sportal^N39^Stown^N40^Ssynonym^N41^S[235]v[235]^N42^Ssucht^N43^Sgilde^N44^Srekryt^N45^Ssoker^N46^Skilta^N47^Setsii^N48^Ssosyal^N49^Sдкп^N50^Speкpуt^N51^Sнoвoбpaн^N52^Sлфг^N53^Speйд^t^^")
	_, sites = as:Deserialize("^1^T^N1^Sprestigewow[%.,]c[0o]m^N2^Sfarm4gold[%.,]com^N3^Sdving[%.,]net^N4^Sspeedruncharacter[%.,]net^N5^Sboosthive[%.,]eu^N6^Sleprestore[%.,]com^N7^S1proboost[%.,]com^N8^Shordebank[%.,]com^N9^Sjustboost[%.,]net^N10^Spvpok[%.,]c[0o]m^N11^Sboostila[%.,]com^N12^Spewpewshop[%.,]pro^N13^Sperfectway[%.,]one^N14^Sdemonboost[%.,]com^N15^Sbestboost[%.,]club^N16^Sbestboost[%.,]com^N17^Stopboost[%.,]pro^N18^Sgamesales[%.,]pro^N19^Smythicstore[%.,]com^t^^")
	_, dedicatedList = as:Deserialize("^1^T^N1^S%d+.*d[ou][ub]ble.*%d+.*trip^N2^Scasino.*%d+x2.*%d+x3^N3^Scasino.*%d+.*double.*%d+.*tripp?le^N4^Scasino.*whisper.*info^N5^Sd[ou][ub]ble.*%d+.*tripp?le^N6^Scasino.*bet.*%d+^N7^Sroll.*%d+.*roll.*%d+.*bet^N8^Scasino.*roll.*double^N9^Scasino.*roll.*%d+.*roll.*%d+^N10^Sdouble.*tripp?le.*casino^N11^Scasino.*legit.*safe.*casino^N12^Sluck.*roll.*%d+k.*minutes.*pst^N13^Sroll.*win.*double.*min.*max^N14^Scasino.*/w.*%d+.*roll^N15^Swt[bst]rs3?gold.*wowgold^N16^Swt[bs]wowgold.*rsgold^N17^Swt[bs]wowgold.*rscoint?s^N18^Swt[bs]runescapegold^N19^Sexchangingrsgold^N20^Sgoldforrunescapegold^N21^Sbuying?runescape[ag]^N22^Swt[bs]runescapeaccount^N23^Swt[bs]runescapepure^N24^Swt[bs].*runescapemoney.*%d+k^N25^S~}wt[bs]rsaccount^N26^S~}wt[bs]%d+rsaccount^N27^S~}wt[bs]a?n?awesomersaccount^N28^Srunescapegoldforwowgold^N29^S~}buyingrs3stuff^N30^S~}wt[bst]somecsgoskin^N31^S~}wt[bst]cs%.?goskin^N32^S~}wt[bst]csgokey^N33^S~}wt[bst]csgoacc^N34^S~}wt[bst]csgokni[fv]e^N35^S~}wt[bst]csgoitem^N36^S~}wt[bst]csgocase^N37^S~}wt[bst]anycsgoskin^N38^S~}buyingcs%.?g[0o]skin^N39^S~}buyingcheapcsgoskin^N40^S~}buyingcsgokey^N41^S~}buyingcsgokni[fv]e^N42^S~}sellingcsgoskin^N43^S~}sellingsomecsgocase^N44^S~}sellingcsgocase^N45^S~}sellingcsgoitem^N46^S~}wt[bst]csskins^N47^S~}wt[bst]keysincsgo^N48^Swanttobuy[/\\]sellcsgoitem^N49^Swanttosell[/\\]buycsgoitem^N50^Swowgoldforcsgokey^N51^S~}wt[bst]csgocamo^N52^S~}wt[bst]cheapcsgoskin^N53^S~}wt[bst]csgocdkee?y^N54^S~}tradingcsgo.*gold^N55^S~}wt[bst]csgocheap^N56^S~}wt[bst]goldforcsgo^N57^S~}wt[bst]mygoldforcsgoskins^N58^S~}wt[bst]mywowgold.*csgoskin^N59^S~}sellinggolds?forcsgo^N60^S~}wt[bst]csgosteamgift^N61^S~}wtsstarcraft.*cdkey.*gold^N62^S~}sellingdota2^N63^S~}wt[bst]dota2^N64^S~}buyingdotaitems^N65^S~}buyingdota2^N66^S~}wt[bst]alldota2^N67^S~}wtssteamaccount^N68^S~}sellingborderlands2^N69^S~}wtssteamwalletcode^N70^S~}wt[bs]lolacc$^N71^S~}wt[bs]%d?x?leagueoflegends?account^N72^S~}wt[bst]m?y?lolaccount^N73^S~}sellingloleuw?acc.*info^N74^S~}wt[bs].*leagueoflegends.*points.*pay^N75^Swts.*leagueoflegends.*acc.*info^N76^Ssellingm?y?leagueoflegends^N77^S~}wt[bs]lolacc.*cheap^N78^S~}wt[bs]lolacc.*skins^N79^S~}wt[bst]mygold%d*leagueoflegends^N80^S~}sellingwowgoldforleagueoflegends^N81^S~}wt[bs]lolacc.*gold^N82^Sselling.*accounts?forgold^N83^Swtsnonemergeacc.*lvl?%d+char^N84^Slvl?%d+char%.?allclass.*info^N85^Slvl?%d+char.*fast.*g[o0]ld^N86^S%d+lvloldaccounts?tosell^N87^Swtswowaccount.*epic^N88^S~}wanttotradeaccount^N89^S~}wttacc.*epic.*mount.*/w^N90^S~}wttacc?ount.*gear.*char^N91^S~}wt[st]wowaccount^N92^S~}wt[bs]mopcode^N93^S~}wttaccountfor.*youget.*tier^N94^S~}wt[st]accountwith^N95^S~}wt[bst]legionkey^N96^S~}wt[bst]legioncdkey^N97^Ssell.*brazzersaccount.*info^N98^S~}wtsbrazzersaccount^N99^S~}wttrade%d+kgold.*diablo^N100^S~}wttwowgold.*diablo^N101^S~}wtbd3forgold^N102^S~}sellingdiablo3^N103^S~}sellingd3account^N104^S~}wtscheapfastd3g^N105^S~}wt[bs]d3key^N106^S~}wts.*%d+day.*diablo.*account^N107^Stradediablo3?goldforwowgold^N108^S~}selling.*gamecard.*diablo^N109^S~}wt[bs]d3account^N110^S~}wtsd3.*transfer.*item^N111^S~}wt[bs]diablo3^N112^S~}wt[bst]wowgold.*d3gold^N113^Swowgoldfory?o?u?r?d3gold^N114^Swowgold.*fordiablo3?gold^N115^Stradediablo3?gold.*wowgold^N116^S~}wt[bs]diablogold^N117^Strading.*fordiablo3?gold^N118^Sdiablogoldforwowgold^N119^S~}wt[bst].*d3gold.*wowgold^N120^S~}wtt.*mygold.*diablo3gold^N121^Swowgoldforyourdiablo3?gold^N122^Swts.*diablo3goldfor%d+^N123^S~}wtscheapgold^N124^S~}wtscheapandfastgold^N125^S~}wtbgold.*gametime^N126^S~}wtbgold.*mount^N127^S~}wt[bs]gametime^N128^S~}wt[bs]prepaidcard^N129^S~}wt[bs]gamecard^N130^S~}wt[bs]gamecode^N131^S~}wt[bs]prepaidgamecard^N132^S~}wt[bs]%d+day.*gamecard^N133^S~}wt[bs]%d+month.*gametime^N134^S~}wt[bs][36]0days?prepaidgametime^N135^S~}wts%d+days?gametime^N136^S~}wts%d+days?gamecard^N137^S~}wts%d+kfor%d+eu^N138^Swts%d+kgoldfor%d+eu^t^^")
	_, dynamicList = as:Deserialize("^1^T^N1^Stitaniumbay.*extra^N2^Stitaniumbay.*livraison^N3^Stitaniumbay.*obtenez^N4^Stitaniumbay.*minut[eo]^N5^Stitaniumbay.*gold^N6^Stitaniumbay.*gratis^N7^Sskype.*findguys^N8^Swts.*help.*mythic.*dungeon.*gear.*info^N9^Swts.*le?ve?ling.*power.*farming.*info^N10^Swts.*spot.*heroic.*raid.*loot.*spec.*invite^N11^Swts.*help.*honor.*prestige.*season.*info^N12^Sselling.*glory.*fast.*stress.*ilvl.*info^N13^Sloot.*piloted.*today.*%d%d%d%d.*whisper^N14^Sloot.*piloted.*now.*discount.*whisper^N15^Sloot.*piloted.*%d%d%d%d.*price.*whisper^N16^Swts.*arena.*rbg.*rating.*loot.*info^N17^Swts.*dungeon.*fast.*prestige.*emerald.*info^N18^Swts.*fast.*dungeon.*rbg.*emerald.*info^N19^Swts.*fast.*dungeon.*pvp.*emerald.*info^N20^Swts.*character.*dungeon.*pvp.*emerald.*info^N21^Swts.*lift.*dungeon.*pvp.*emerald.*info^N22^Swts.*boost.*dungeon.*pvp.*emerald.*info^N23^Swts.*le?ve?ll?i?n?g?.*dungeon.*pvp.*emerald.*info^N24^Sselling.*rbg.*honor.*mount.*selfplay^N25^Sselling.*mount.*honor.*gear.*accshare.*^N26^Srbg.*artifact.*mount.*accshar^N27^Sheroic.*amazingprice.*strong.*group.*gua?rantee.*drop.*spot^N28^Swts.*tonight.*arena.*rbg.*mythic.*coaching^N29^Slegion.*gametime.*iranblizzard[%.,]com^N30^Sbank4dh.*skype^N31^Sbank4dh.*%d+k^N32^Strusted.*bank4dh^N33^Swts.*mythic.*powerle?ve?l.*glory.*info^N34^Smythic.*boostinglive.*faster^N35^Skoroboost.*everyday.*mythic^N36^Sdoyouwant.*level110.*12h.*noproblem.*msgme.*info^N37^Srbg.*artifact.*honor.*mount.*carry^N38^S~}wtspowerleveling.*fast^N39^Sfast.*leveling.*honor.*в[o0][o0]st^N40^S~}wtsmythickarazhandungeons[,.]*whispme^N41^S~}wtskarazhanboost[,.]mythic.*mythicdungeons?boost.*info^N42^S~}wtskarazhan[,.]mythic.*mythic+dungeon$^N43^S~}wtsboostkarazhan[,.]mythic[,.]mythicdungeon^N44^S~}wtskarazhan.*,mythic.*mythicdungeons?boost$^N45^Srbg.*boost.*2200.*yourself.*account.*sharing.*info^N46^Srbg.*honor.*priestige.*mount.*selfplay^N47^Spowerle?ve?l.*yourspuregame[,.]com^N48^Sxperiencedparty.*runs.*walkthrough.*mythic.*glory.*karazhan^N49^Swh?isp.*skype.*igor.*price^N50^Selitistgaming[,.]com.*mount^N51^Sjuststarted.*leveling.*twink.*gear.*dungeon.*more^N52^Swts.*saddle.*carry.*hour.*start.*info^N53^Sgetgearup.*karazhan.*nightmare.*dungeons.*runs.*more^N54^Swts.*mythic.*master.*loot.*mythic.*details.*private^N55^Swts.*nightmare.*boosting.*loot.*mythic.*glory^N56^Sskype.*landroshop^N57^Swtskarazhan.*timerun.*mount.*mythic.*dungeonboost^N58^Ssaddle.*conquestcapped[%.,]com^N59^S~}wts.*good.*fast.*powerle?ve?l^N60^Sservice.*mythic.*raid.*pay.*price^N61^Swts.*karazhan.*mount.*nightmare.*hc.*dungeon.*run.*more^N62^Soffer.*honor.*prestige.*boost.*pvp.*mount^N63^Sbrb2game.*sale^N64^S~}wtsemeraldnightmare.*heroic.*pl.*tonight.*8.*fastrun.*highquality^N65^Selitegamerboosting[%.,]de.*skype^N66^Swts.*nightmare.*mythic.*loot.*dungeon.*pvp.*glory^N67^Sjuststarted.*legion.*gearup.*karazhan.*nightmare.*dungeon.*more^N68^S%d+k.*giveaway.*guild.*selling.*karazhan.*mount.*mythic.*dungeon.*nightmare.*raid^N69^Sl[o0][o0]tcl[o0]ud.*b[o0][o0][s5]t^N70^Swtskara.*fasttimerun.*guarantee.*mount^N71^Swtsarena.*boost.*2%.?200.*2%.?400.*gladiator.*info^N72^Swts.*nightmare.*mythic.*master.*loot.*quickraids.*everyday.*write^N73^S2.*2%.4.*glad.*le?ve?ling.*100110.*info$^N74^S2.*2%.4.*glad.*coach.*100110.*info$^N75^Sarena.*2%.4.*2.*glad.*teammates.*push^N76^Sb[o0][o0]st.*2%.4.*2.*glad.*livestream.*info$^N77^Sb[o0][o0]st.*2%.4.*2.*glad.*selfplay.*info$^N78^Sarena.*2%.4.*2.*glad.*livestream.*info$^N79^Swtsemeraldnightmarelootraids.*heroic.*mythic.*dungeons.*wisp$^N80^Swts.*mythic.*boosting.*loot.*keystone.*dungeon.*glory^N81^Sselling.*professional.*team.*mount.*loot^N82^S~}wtslegiondungeons.*mythic,karazhan$^N83^Swts.*valor.*lootrun.*mythic.*mount.*prestige^N84^Shello.*2200.*glad.*le?ve?ling.*info^N85^Skarazhanmount.*nightmareruns.*spotsleft.*contact.*details$^N86^Strial.*karazhanmount.*nightmareruns.*spotsleft.*contact.*details$^N87^Swts.*heroic.*raid.*fast.*quality.*discount.*selfplay^N88^S~}wts.*emeraldnightmare.*masterloottoday.*cheapandfast.*whisperme$^N89^Swtsrbg.*wins.*mount.*carry.*reins^N90^S~}wts.*viciousmounts.*saddle.*star.*getrightnow^N91^Swts.*today.*nightmare.*lootrun.*masterloot.*bestprice^N92^Swts.*valor.*lootrun.*mount.*mythic.*glory^N93^S~}wtsgamingservices.*pve/pvp.*write.*info^N94^S~}wtsenandtov.*mythic.*heroic.*boosting.*loot.*karazhan.*dungeonsboost^N95^Sgold.*g4game[%.,]c[o0]m^N96^Sgold.*g[o0]ldce[o0][%.,]c[o0]m^N97^S~}onespotleft.*nightmare.*mythicboost.*clear.*loot.*amazingprice.*raidstarts^N98^Strial.*valor.*nightmare.*myth.*karazhan.*powerleveling.*muchmor^N99^S~}wts.*nightmare.*mythicboost.*clear.*loot.*amazingprice.*raidstarts^N100^S.+%d+.+p[%.,@/\\=]*r[%.,@/\\=]*e[%.,@/\\=]*s[%.,@/\\=]*t[%.,@/\\=]*i[%.,@/\\=]*g[%.,@/\\=]*e[%.,@/\\=]*w[%.,@/\\=]*o[%.,@/\\=]*w[%.,][cf]^N101^Sp[%.,@/\\=]*r[%.,@/\\=]*e[%.,@/\\=]*s[%.,@/\\=]*t[%.,@/\\=]*i[%.,@/\\=]*g[%.,@/\\=]*e[%.,@/\\=]*w[%.,@/\\=]*o[%.,@/\\=]*w[%.,].+%d+.*^N102^Sskype.*vf3399^N103^Swtskarazhanwithmount.*mythicdungeons.*valor.*nightmare^N104^Sloot.*mount.*mythic.*dungeons.*ask^N105^Ssale.*mount.*loot.*mythic.*dungeons^N106^Swts.*mythic.*lootrun.*master.*fast.*cheap.*ready.*info^N107^Sselling.*nightmare.*heroic.*masterloot.*boost.*server.*info^N108^Swts.*xavius.*boost.*completed500.*curve.*%d+.*me.*info^N109^S~}wtsenmythiclootruntonight.*goldpossible.*w^N110^S~}wts.*keystoneconqueror.*karazhan.*fast,smoothandfair.*whisp^N111^S~}wtsen.*tov.*boost.*mythic.*karazhan.*mount.*info^N112^S~}wtstoday.*nightmaremythic.*master.*fastcheap.*info^N113^S~}=*wts=*today.*nightmaremythic.*master.*bestprice$^N114^Swts.*lootrun.*myth.*mount.*offers.*live^N115^Swtsfast.*smooth.*karazhan.*mount.*valor.*nightmare.*wisp^N116^Swts.*nightmare.*heroic.*ml.*quality.*discount.*come.*items^N117^Swts.*heroic.*raid.*tonight.*come.*items.*quality.*discount^N118^Swts.*nightmare.*valor.*le?ve?ling.*best.*info^N119^Srbg.*mount.*bop.*accshare^N120^Swts.*rbgs.*mounts.*saddle.*accshare^N121^S~}wts.*nightmare.*mythic.*gear.*gua?rantee.*amazing.*price.*details^N122^S~}wtsmount.*karazhan.*timerun.*quality.*service^N123^Swts.*mythic.*dungeon.*loot.*items.*le?ve?ling.*hours.*info^N124^Swts.*mythicplus.*timer.*loot.*gift.*write^N125^Swts.*heroic.*master.*loot.*mythic.*items.*guarantee.*info^N126^Swts.*today.*raid.*nightmare.*mythic.*heroic.*loot.*guarantee.*items^N127^S~}wtskarazhad?nrunwithmount.*startin%d+.*wformoreinfo$^N128^S~}wts.*nightmare.*heroicwithml.*raidto[nd].*fast.*quality.*discount^N129^S~}wts.*nightmare.*heroic.*mythic.*highquality.*service.*come.*loot.*info^N130^S~}wts.*nightmaremythic7/7ml.*to[dn].*fastcheap.*meformoreinfo^N131^S~}wtsnow.*nightmaremythic.*withmlfastcheap.*readytostartin%d+minute^N132^S~}wtstodaymythic.*higher.*hurry.*beforereset.*weeklychest.*write.*info^N133^Swts.*earnmount.*rank.*viciousmount.*selling.*accshare^N134^Swtsartifactpower.*mount.*saddle.*accshare^N135^Ssellingrbg.*honou?r.*mount.*accountshare^N136^Srbg.*mount.*prestige.*acco?u?n?t?share^N137^Stelegram.*amirangaming^N138^S~}wts.*tonight.*nightmare.*mythic.*masterloot.*guarantee.*cheap.*price^N139^Sstrongandskilledteam.*helpyouwithmythicdungeon.*upto%d+fastandeasy^N140^Sexperiencedteamoffriends.*helpyouwithmythicdungeon.*upto%d+inshorttime^N141^S~}wtsap.*update.*weap.*viciousmount.*accshare^N142^Sprestigewow[%.,@/\\=][cf].....................................^N143^Shelpyou.*skype.*warstre^N144^Swtsmythic.*runs.*difficulty.*karazhan.*mount.*selfplay.*runseveryday.*info^N145^S~}want.*level110.*within.*maybekarazhanmount.*mythic.*prestigelevels.*wisp^N146^Sbestguildsoffering.*mythic.*dungeons.*kara.*tov.*raids.*broken.*info^N147^S~}topguildinvit.*daily.*mythicdungeon.*kara.*raid.*brokenlyepic.*4hours.*msg^N148^S~}wtsartifactpower.*gethigherweaponle?ve?l.*viciousmount.*saddle^N149^Swww[%.,@/\\=]*prestigewow.....................................^N150^Sskype.*guiguilol02^N151^Sboost.*skype.*onkils^N152^Sskype.*telura1996^N153^Sselling.*glory.*legion.*hero.*manasaber.*prowler.*mount.*ile?ve?l.*require.*info^N154^Swtsspots.*en.*trial.*valor.*normal.*heroic.*mythic.*loot.*getinvite^N155^S~}wtscheapfastkara.*nightmare.*lootraid.*mythic.*dungeon.*wisp.*everyday^N156^Sok4gold.*skype^N157^S微信.*549965838^N158^Sqq.*1505381907^N159^S微信.*1505381907^N160^Sqq.*1513941814^N161^Sqq.*593837031^N162^S100110.*q228102174^N163^Sgold.*eddie8806^N164^S100110.*苏拉玛任务.*星空龙^N165^S微信.*17788955341^N166^Sqq.*1433535628^N167^S低层三.*q1292706134^N168^S微信.*sesegold^N169^S%d+.*万金.*支付宝^N170^Sqq.*2278048179^N171^S金.*778587316^N172^S100110.*送坐骑.*tiger^N173^S100110.*币.*幽灵虎^N174^S~}marine.*在秒回^N175^S881.*安全便宜快速.*ip^N176^S特价出售黄金.*稀有坐骑^N177^S200万手工金币.*paypal^N178^Sqq.*153874069^N179^Sqq.*3450345^N180^S练级.*bearwow[,.]com^N181^S特价.*tiger.*稀有坐骑^N182^S出售特价金.*%d+for%d+k.*100110^N183^S拿任意橙.*神器三槽.*110^N184^S100110.*神器.*金^N185^Sqq.*100845995^N186^S个人品渣子.*profoundsea^N187^Sstyle.*快速练级.*50lvl^N188^S15版本和新春.*10^N189^S无限拾取套餐特价.*金币25^N190^S低价出售翡翠包团.*金25^N191^S低层刷橙装和高层拿低保.*大小幽灵虎等稀有坐骑^N192^S金币大量库存.*飞机头等坐骑^N193^S~}marine.*老牌华人实力公会^N194^S~}marine.*幻化^N195^S~}marine便宜金子^N196^S守望先锋上分.*2000.*3000.*前私密谈^N197^S金币大量库存.*欢迎咨询^N198^S~}style.*光龙无敌火鹰等热卖^N199^S圣诞节金币特价.*大小幽灵虎等坐骑^N200^S层箱子无限刷橙.*试炼包团^N201^S20for10w.*刷箱子^N202^S20=+10w.*刷箱子^N203^S20刀?=+10w.*另有黑市坐骑^N204^S清世界任务.*金%d+刀%d+万^N205^S无限拾取套餐特价.*金币二十万^N206^S热售翡翠梦境包团.*金币^N207^S工作室手工任务练级.*龙无敌火鹰等热卖^N208^S圣诞节大甩卖金币.*金子大甩卖^N209^S神器三槽.*金%d+刀%d+万^N210^S圣诞节金币大促销.*送坐骑^N211^S纯手工任务升级.*金%d+刀十万^N212^Sn110.*无敌.*飞机头等坐骑^N213^S喜迎7.15版本和新年.*%d+^N214^S卡拉赞.*超级特价.*来就开来就开^N215^S公会专业队伍出售.*%d+usd^N216^S圣诞节大甩卖金币.*幽灵虎现货秒发金子^N217^S买一送一.*超级特价.*有需要的赶紧^N218^S大力促销.*%d+rmb=%d+.*qq^N219^S%d+rmb=%d+.*微信^N220^Sqq.*2247682512^N221^Sskype.*nazhang1983^N222^S橙装.*大秘境低保.*翡翠副本包团.*星光/无敌飞机头^N223^Spvp.*%d+.*级解锁外观送邪气鞍座.*星光^N224^S大秘境低层无限刷箱子.*刷橙装^N225^S翡翠包团最低价.*20刀?=+10w^N226^S元旦.*圣诞节大甩卖.*大秘境刷箱子^N227^S大小幽灵虎等稀有坐骑.*%d%d刀?=+10^N228^S送坐骑.*金15刀10w^N229^S大小幽灵虎稀有坐骑.*金币%d%d刀十万^N230^S包团毕业热销中.*卡拉赞坐骑.*需要的联系^N231^Smaxlvl[%.,]net.*пpoдaжa^N232^Sцeн[ae].*lootkeeper[%.,]com^N233^Sdving[%.,]ru.*уcлуги^N234^Sнизkиeцeны.*getloot[%.,]ru^N235^Swowmart[%.,]ru.*зoлoto^N236^Srpggold[%.,]ru.*зoлoto^N237^Srpggold[%.,]ru.*гoлд^N238^Sзoлoto.*mmoah[%.,]ru^N239^Szolotowow[%.,]ru.*зoлoto^N240^Sпomoжem.*nightmoney[%.,]ru^N241^Sпpoдaжa.*coinsstore[%.,]ru^N242^S~}гapaнtии,ckидkи,дoctвka5mинуt$^N243^Soro.*tutiendawow.*barato^N244^Sosboosting[%.,]com.*tarifs.*remise^N245^Swallgaming.*loot.*keystone^N246^Spvp.*wallgaming[%.,]com^N247^S~}sælgerguldfor%d+^N248^S~}sælgerg[ou]ld.*mobilepay^N249^Stilbud.*sælger%d+k.*mobilepay^N250^Ssælgerguld.*skype^N251^Ssælgerguld.*priser^N252^Ssælgerlidtguld.*mobilepay^N253^Ssælgerg.*%d+kr?pr^N254^Ssælgerguld.*info^N255^Snogen.*skalkobeg.*info^N256^Ssælgerguldviamp^N257^Ssælgerguldviamobile?pay^N258^Snogleg.*sælgerovermobilepay^N259^Ssælger%d+kguld.*mobile^N260^S~}sælgerguld.*skrivtilmig^N261^Smanglerdugold.*kroner.*mobilepay^N262^Ssælgerg.*mobilepay^N263^Ssaljerguld.*detail.*stock^N264^S~}saljerguldviaswish^N265^S~}saljergviaswish^N266^S~}saljerguldsnabbtviaswish^N267^S~}koperw?o?w?guldviaswish^N268^S~}kopergviaswish^N269^S~}guldfinns.*viaswish^N270^S~}saljerwowguld.*viaswish^N271^S~}saljer%d+kguldfor.*viaswish^N272^S~}saljerguld,swish^N273^Sguldkvar.*viaswish^N274^S~}guldviaswish^N275^S~}guld%d+k.*kr.*skype^N276^S~}saljerviaswish^N277^S~}gfinnsswish$^N278^S~}gfinnsbilligt$^N279^S~}gfinns@swish^N280^S~}%d+kfinns.*@swish^N281^S~}nagonsomsaljergu?l?d?viaswish^N282^S~}behoverdug@swish^N283^S~}gfinnsatt?kopa.*swish^N284^Sspelpengar@swish^N285^S~}guldfinns.*kopa.*swish$^N286^S~}gsaljsbilligt.*swish^N287^Sguldsalje[rs]viaswish^N288^S~}saljerwowguldgenomswish^N289^S~}saljerguldpaswish^N290^S~}wtbg[ou]ldviaswish^N291^S~}[vw]illkop[as]guldviaswish^N292^S~}[vw]illkop[as]guldmedswish^N293^S~}billigtguldviaswish^N294^S~}guldsaljesbilligtswish^N295^S~}saljerg%.?$^N296^S~}gfinnsviaswish^N297^S~}guldfinnsattkopabilligt^N298^S~}koperguldforpengar^N299^Sbesten.*skype.*sarmael.*coaching^N300^Smmoprof.*loot.*gold^N301^Smythic.*coaching.*mmoprof^N302^Slootrun.*selfplay.*piloted.*gunstig^N303^Srocketgaming.*mount.*skype^N304^Swts.*alptraum.*mythisch.*boost.*boost.*glory^t^^")
end


local repTbl = {
	--Symbol & space removal
	["[%*%-<>%(%)\"!%?`'_%+#%%%^&;:~{} ]"]="",
	["¨"]="", ["”"]="", ["“"]="", ["▄"]="", ["▀"]="", ["█"]="", ["▓"]="", ["▲"]="", ["◄"]="", ["►"]="", ["▼"]="",
	["░"]="", ["♥"]="", ["♫"]="", ["●"]="", ["■"]="", ["☼"]="", ["¤"]="", ["☺"]="", ["↑"]="", ["«"]="", ["»"]="",
	["▌"]="", ["□"]="", ["√"]="", ["《"]="", ["》"]="", ["²"]="", ["´"]="", ["★"]="",

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
	["•"]=".", ["，"]=",", ["º"]="o", ["☻"]="o", ["®"]="r",
}

local strfind = string.find
local Spam = function(msg)
	for i=1, #dedicatedList do
		if strfind(msg, dedicatedList[i]) then
			return true
		end
	end
	for i=1, #dynamicList do
		if strfind(msg, dynamicList[i]) then
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
	elseif next(spamCollector) then
		local t = GetTime()
		if t-prevShow > 90 then
			prevShow = t
			btn:Show()
		end
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
