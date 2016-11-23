
local _, L = ...

L.spamBlocked = "BadBoy: Spam blocked"
L.clickToReport = "|cffeda55fClick|r to report, |cffeda55fAlt-Click|r to dismiss."
L.spamTooltip = "Show spam in button tooltip"
L.noAnimate = "Disable button pulse animation"
L.bigButton = "Make the report button bigger"

local loc = GetLocale()
if loc == "frFR" then
	L.spamBlocked = "BadBoy : Spam bloqué"
	L.spamTooltip = "Afficher le spam dans une infobulle"
	L.noAnimate = "Désactiver l'animation d'impulsion du bouton."
	L.clickToReport = "|cffeda55fClic|r pour signaler, |cffeda55fAlt-Clic|r pour faire disparaître."
	L.bigButton = "Rendre le bouton de signalement plus gros"
elseif loc == "deDE" then
	L.spamBlocked = "BadBoy: Spam geblockt"
	--L.spamTooltip = "Show spam in button tooltip"
	--L.noAnimate = "Disable button pulse animation"
	--L.clickToReport = "|cffeda55fClick|r to report, |cffeda55fAlt-Click|r to dismiss."
	--L.bigButton = "Make the report button bigger"
elseif loc == "zhTW" then
	L.spamBlocked = "BadBoy: 垃圾訊息已被阻擋"
	--L.spamTooltip = "Show spam in button tooltip"
	--L.noAnimate = "Disable button pulse animation"
	--L.clickToReport = "|cffeda55fClick|r to report, |cffeda55fAlt-Click|r to dismiss."
	--L.bigButton = "Make the report button bigger"
elseif loc == "zhCN" then
	L.spamBlocked = "BadBoy: 垃圾信息已被拦截"
	--L.spamTooltip = "Show spam in button tooltip"
	--L.noAnimate = "Disable button pulse animation"
	--L.clickToReport = "|cffeda55fClick|r to report, |cffeda55fAlt-Click|r to dismiss."
	--L.bigButton = "Make the report button bigger"
elseif loc == "esES" or loc == "esMX" then
	L.spamBlocked = "BadBoy: Spam bloqueado"
	--L.spamTooltip = "Show spam in button tooltip"
	--L.noAnimate = "Disable button pulse animation"
	--L.clickToReport = "|cffeda55fClick|r to report, |cffeda55fAlt-Click|r to dismiss."
	--L.bigButton = "Make the report button bigger"
elseif loc == "ruRU" then
	L.spamBlocked = "BadBoy: Спам заблокирован"
	--L.spamTooltip = "Show spam in button tooltip"
	--L.noAnimate = "Disable button pulse animation"
	--L.clickToReport = "|cffeda55fClick|r to report, |cffeda55fAlt-Click|r to dismiss."
	--L.bigButton = "Make the report button bigger"
elseif loc == "koKR" then
	--L.spamBlocked = "BadBoy: Spam blocked"
	--L.spamTooltip = "Show spam in button tooltip"
	--L.noAnimate = "Disable button pulse animation"
	--L.clickToReport = "|cffeda55fClick|r to report, |cffeda55fAlt-Click|r to dismiss."
	--L.bigButton = "Make the report button bigger"
elseif loc == "ptBR" then
	L.spamBlocked = "BadBoy: Spam bloqueado"
	--L.spamTooltip = "Show spam in button tooltip"
	--L.noAnimate = "Disable button pulse animation"
	--L.clickToReport = "|cffeda55fClick|r to report, |cffeda55fAlt-Click|r to dismiss."
	--L.bigButton = "Make the report button bigger"
elseif loc == "itIT" then
	L.spamBlocked = "BadBoy: Spam bloccata"
	--L.spamTooltip = "Show spam in button tooltip"
	--L.noAnimate = "Disable button pulse animation"
	--L.clickToReport = "|cffeda55fClick|r to report, |cffeda55fAlt-Click|r to dismiss."
	--L.bigButton = "Make the report button bigger"
end
