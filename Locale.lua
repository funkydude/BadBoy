
local _, L = ...

L.spamBlocked = "Spam blocked, click to report!"
L.clickToReport = "|cffeda55fClick|r to report, |cffeda55fAlt-Click|r to dismiss."
L.spamTooltip = "Show spam in button tooltip"
L.noAnimate = "Disable button pulse animation"

local loc = GetLocale()
if loc == "frFR" then
	L.spamBlocked = "Spam bloqué, cliquez pour signaler !"
	L.spamTooltip = "Affichier le spam dans une infobulle"
	L.noAnimate = "Désactiver l'animation d'impulsion du bouton."
	--L.clickToReport = "|cffeda55fClick|r to report, |cffeda55fAlt-Click|r to dismiss."
elseif loc == "deDE" then
	L.spamBlocked = "Spam geblockt, zum Melden klicken"
	--L.spamTooltip = "Show spam in button tooltip"
	--L.noAnimate = "Disable button pulse animation"
	--L.clickToReport = "|cffeda55fClick|r to report, |cffeda55fAlt-Click|r to dismiss."
elseif loc == "zhTW" then
	L.spamBlocked = "垃圾訊息已被阻擋, 點擊以舉報 !"
	--L.spamTooltip = "Show spam in button tooltip"
	--L.noAnimate = "Disable button pulse animation"
	--L.clickToReport = "|cffeda55fClick|r to report, |cffeda55fAlt-Click|r to dismiss."
elseif loc == "zhCN" then
	L.spamBlocked = "垃圾信息已被拦截，点击举报！"
	--L.spamTooltip = "Show spam in button tooltip"
	--L.noAnimate = "Disable button pulse animation"
	--L.clickToReport = "|cffeda55fClick|r to report, |cffeda55fAlt-Click|r to dismiss."
elseif loc == "esES" or loc == "esMX" then
	L.spamBlocked = "Spam bloqueado, haz clic para reportarlo."
	--L.spamTooltip = "Show spam in button tooltip"
	--L.noAnimate = "Disable button pulse animation"
	--L.clickToReport = "|cffeda55fClick|r to report, |cffeda55fAlt-Click|r to dismiss."
elseif loc == "ruRU" then
	L.spamBlocked = "Спам заблокирован. Нажмите, чтобы сообщить!"
	--L.spamTooltip = "Show spam in button tooltip"
	--L.noAnimate = "Disable button pulse animation"
	--L.clickToReport = "|cffeda55fClick|r to report, |cffeda55fAlt-Click|r to dismiss."
elseif loc == "koKR" then
	--L.spamBlocked = "Spam blocked, click to report!"
	--L.spamTooltip = "Show spam in button tooltip"
	--L.noAnimate = "Disable button pulse animation"
	--L.clickToReport = "|cffeda55fClick|r to report, |cffeda55fAlt-Click|r to dismiss."
elseif loc == "ptBR" then
	L.spamBlocked = "Spam bloqueado, clique para denunciar!"
	--L.spamTooltip = "Show spam in button tooltip"
	--L.noAnimate = "Disable button pulse animation"
	--L.clickToReport = "|cffeda55fClick|r to report, |cffeda55fAlt-Click|r to dismiss."
elseif loc == "itIT" then
	L.spamBlocked = "Spam bloccata, clic qui per riportare!"
	--L.spamTooltip = "Show spam in button tooltip"
	--L.noAnimate = "Disable button pulse animation"
	--L.clickToReport = "|cffeda55fClick|r to report, |cffeda55fAlt-Click|r to dismiss."
end
