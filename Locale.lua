
local _, L = ...

L.spamBlocked = "BadBoy: Spam blocked"
L.clickToReport = "|cffeda55fClick|r to report, |cffeda55fAlt-Click|r to dismiss."
L.spamTooltip = "Show spam in button tooltip"
L.noAnimate = "Disable button pulse animation"
L.frequentButton = "Show the button more frequently"
L.frequentButtonTip = "To reduce player annoyance the report button will not always show.\nEnable this to always show the button asking to report and show it faster."

local loc = GetLocale()
if loc == "frFR" then
	L.spamBlocked = "BadBoy : Spam bloqué"
	L.spamTooltip = "Afficher le spam dans une infobulle"
	L.noAnimate = "Désactiver l'animation d'impulsion du bouton."
	L.clickToReport = "|cffeda55fClic|r pour signaler, |cffeda55fAlt-Clic|r pour faire disparaître."
	L.frequentButton = "Afficher le bouton plus fréquemment"
	L.frequentButtonTip = "Pour réduire les désagréments, le bouton de rapport s'affichera de en temps en temps. Activez cette option pour toujours afficher le bouton demandant le rapport et l'afficher plus rapidement."
elseif loc == "deDE" then
	L.spamBlocked = "BadBoy: Spam geblockt"
	--L.spamTooltip = "Show spam in button tooltip"
	--L.noAnimate = "Disable button pulse animation"
	--L.clickToReport = "|cffeda55fClick|r to report, |cffeda55fAlt-Click|r to dismiss."
	--L.frequentButton = "Show the button more frequently"
	--L.frequentButtonTip = "To reduce player annoyance the report button will not always show.\nEnable this to always show the button asking to report and show it faster."
elseif loc == "zhTW" then
	L.spamBlocked = "BadBoy: 垃圾訊息已被阻擋"
	--L.spamTooltip = "Show spam in button tooltip"
	--L.noAnimate = "Disable button pulse animation"
	--L.clickToReport = "|cffeda55fClick|r to report, |cffeda55fAlt-Click|r to dismiss."
	--L.frequentButton = "Show the button more frequently"
	--L.frequentButtonTip = "To reduce player annoyance the report button will not always show.\nEnable this to always show the button asking to report and show it faster."
elseif loc == "zhCN" then
	L.spamBlocked = "BadBoy: 垃圾信息已被拦截"
	--L.spamTooltip = "Show spam in button tooltip"
	--L.noAnimate = "Disable button pulse animation"
	--L.clickToReport = "|cffeda55fClick|r to report, |cffeda55fAlt-Click|r to dismiss."
	--L.frequentButton = "Show the button more frequently"
	--L.frequentButtonTip = "To reduce player annoyance the report button will not always show.\nEnable this to always show the button asking to report and show it faster."
elseif loc == "esES" or loc == "esMX" then
	L.spamBlocked = "BadBoy: Spam bloqueado"
	L.spamTooltip = "Mostrar spam en la descripción emergente del botón"
	L.noAnimate = "Desactivar animación del botón"
	L.clickToReport = "|cffeda55fClick|r para reportar, |cffeda55fAlt-Click|r para descartar."
	L.frequentButton = "Mostrar el botón más a menudo"
	L.frequentButtonTip = "Para reducir las molestias al jugador, el botón de reporte no se muestra siempre.\nActive esto para mostrar siempre y de manera más rápida el botón de reporte."
elseif loc == "ruRU" then
	L.spamBlocked = "BadBoy: Спам заблокирован"
	L.spamTooltip = "Показывать спам во всплывающей подсказке кнопки"
	L.noAnimate = "Отключить анимацию импульса кнопки"
	L.clickToReport = "|cffeda55fЩелкните|r, чтобы пожаловаться, |cffeda55fAlt-щелчок|r, чтобы отклонить."
	L.frequentButton = "Показывать кнопку чаще"
	L.frequentButtonTip = "Чтобы уменьшить раздражение игроков, кнопка отчета будет отображаться не всегда.\nВключите эту опцию, чтобы всегда отображать кнопку с просьбой сообщить и показывать ее быстрее."
elseif loc == "koKR" then
	L.spamBlocked = "BadBoy: 스팸 차단"
	--L.spamTooltip = "Show spam in button tooltip"
	--L.noAnimate = "Disable button pulse animation"
	--L.clickToReport = "|cffeda55fClick|r to report, |cffeda55fAlt-Click|r to dismiss."
	--L.frequentButton = "Show the button more frequently"
	--L.frequentButtonTip = "To reduce player annoyance the report button will not always show.\nEnable this to always show the button asking to report and show it faster."
elseif loc == "ptBR" then
	L.spamBlocked = "BadBoy: Spam bloqueado"
	--L.spamTooltip = "Show spam in button tooltip"
	--L.noAnimate = "Disable button pulse animation"
	--L.clickToReport = "|cffeda55fClick|r to report, |cffeda55fAlt-Click|r to dismiss."
	--L.frequentButton = "Show the button more frequently"
	--L.frequentButtonTip = "To reduce player annoyance the report button will not always show.\nEnable this to always show the button asking to report and show it faster."
elseif loc == "itIT" then
	L.spamBlocked = "BadBoy: Spam bloccata"
	--L.spamTooltip = "Show spam in button tooltip"
	--L.noAnimate = "Disable button pulse animation"
	--L.clickToReport = "|cffeda55fClick|r to report, |cffeda55fAlt-Click|r to dismiss."
	--L.frequentButton = "Show the button more frequently"
	--L.frequentButtonTip = "To reduce player annoyance the report button will not always show.\nEnable this to always show the button asking to report and show it faster."
end
