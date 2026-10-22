
local _, S = ...
local repTbl = S.repTbl

--[[ Chat Scanning ]]--
local Ambiguate, GetGameAccountInfoByGUID, strfind, gsub, lower, next, type, tremove = Ambiguate, C_BattleNet.GetGameAccountInfoByGUID, string.find, string.gsub, string.lower, next, type, table.remove
local IsFriend, IsGuildMember, IsGUIDInGroup, SetCVar, GetCVarBool = C_FriendList.IsFriend, IsGuildMember, C_PartyInfo.IsGUIDInGroup, C_CVar.SetCVar, C_CVar.GetCVarBool
local CanReportPlayer, OpenReportPlayerDialog, PlayerLocation = C_ReportSystem.CanReportPlayer, C_ReportSystem.OpenReportPlayerDialog, PlayerLocation
local spamCollector, spamLogger, prevShow, enableBubble = {}, {}, 0, false
local blockedLineId, et, chatLines, chatPlayers = 0, 7, {}, {}
local btn, reportFrame
local function IsFriendly(guid, flag)
	if not guid then return true end -- LocalDefense automated prints
	if not guid:find("^Player") then -- Bad addons
		local msg = "BadBoy: Unexpected GUID requested by an addon: ".. guid
		print(msg)
		geterrorhandler()(msg)
		return true
	end
	local isBnetFriend = GetGameAccountInfoByGUID(guid)
	if isBnetFriend or IsGuildMember(guid) or IsFriend(guid) or IsGUIDInGroup(guid) or flag == "GM" or flag == "DEV" then
		return true
	end
end
local function Cleanse(msg)
	msg = gsub(msg, "|c[^%[]+%[([^%]]+)%]|h|r", "%1") -- Speed up processing messages with links by removing them
	msg = lower(msg) --Lower all text, remove capitals
	for k,v in next, repTbl do
		msg = gsub(msg, k, v)
	end
	return msg
end
local issecretvalue = issecretvalue
local eventFunc = function(_, event, msg, player, _, _, _, flag, channelId, _, _, _, lineId, guid)
	-- Re-enable chat bubbles if they were disabled in the previous event.
	if enableBubble then
		enableBubble = false
		SetCVar("chatBubbles", 1)
	end

	blockedLineId = 0
	if issecretvalue(msg) then return end
	if event == "CHAT_MSG_CHANNEL" and (channelId == 0 or type(channelId) ~= "number") then return end --Only scan official custom channels (gen/trade)

	local trimmedPlayer = Ambiguate(player, "none")
	if IsFriendly(guid, flag) then return end

	local debug = msg --Save original message format
	msg = Cleanse(msg)

	--20 line text buffer, this checks the current line, and blocks it if it's the same as one of the previous 20
	if event == "CHAT_MSG_CHANNEL" then
		local cleanestMsg = gsub(msg, "[@,./\\=]", "") -- Anything purposely not removed by Cleanse()
		for i=1, #chatLines do
			if chatLines[i] == cleanestMsg and chatPlayers[i] == guid then --If message same as one in previous 20 and from the same person...
				blockedLineId = lineId
				-- Reduce the chances of a spam report expiring (line id is too old) by refreshing it
				if spamCollector[guid] and S.is(msg) then
					local loc = PlayerLocation:CreateFromChatLineID(lineId)
					spamCollector[guid] = loc
					if BADBOY_OPTIONS.tipSpam then
						spamLogger[guid] = debug
					end
				end
				--
				return
			end
			if i == 20 then tremove(chatLines, 1) tremove(chatPlayers, 1) end --Don't let the DB grow larger than 20
		end
		chatLines[#chatLines+1] = cleanestMsg
		chatPlayers[#chatPlayers+1] = guid
	end
	--End text buffer

	if S.is(msg) then
		if event == "CHAT_MSG_SAY" or event == "CHAT_MSG_YELL" then
			-- Awful way of disabling chat bubbles when spam is detected.
			-- Chat bubbles are processed internally by the game client AFTER all the addon event handlers are fired.
			if GetCVarBool("chatBubbles") then
				enableBubble = true
				SetCVar("chatBubbles", 0)
			end
		end
		if not BADBOY_OPTIONS.freqButton then
			for i = 1, #S[et] do
				if strfind(msg, S[et][i]) then
					blockedLineId = lineId
					return
				end
			end
		end
		if BadBoyLog then
			BadBoyLog("BadBoy", event, trimmedPlayer, debug)
		end
		if not BADBOY_BLACKLIST[guid] and not C_InstanceEncounter.IsEncounterInProgress() then
			local loc = PlayerLocation:CreateFromChatLineID(lineId)
			spamCollector[guid] = loc
			if BADBOY_OPTIONS.tipSpam then
				spamLogger[guid] = debug
				if btn:IsShown() and reportFrame:IsMouseOver() then
					reportFrame:GetScript("OnLeave")(reportFrame) -- Add more spam to tooltip if shown
					reportFrame:GetScript("OnEnter")(reportFrame)
				end
			end

			local t = GetTime()
			if t-prevShow > (BADBOY_OPTIONS.freqBtn and 30 or 90) then
				prevShow = t
				--btn:Show()
			end
		end

		blockedLineId = lineId
		return
	elseif next(spamCollector) then
		local t = GetTime()
		if t-prevShow > (BADBOY_OPTIONS.freqBtn and 30 or 90) then
			prevShow = t
			--btn:Show()
		end
	end
end
local filterFunc = function(_, _, _, _, _, _, _, _, _, _, _, _, lineId)
	if blockedLineId == lineId then
		return true
	end
end

do
	--temp
	local xpcall = xpcall
	local dummy = function() end
	--end temp
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
	if scale.SetFromScale then -- XXX Dragonflight compat
		scale:SetFromScale(0.25,0.25)
		scale:SetToScale(1,1)
	else
		scale:SetScaleFrom(0.25,0.25)
		scale:SetScaleTo(1,1)
	end
	scale:SetDuration(0.4)
	local scale2 = animGroup:CreateAnimation("Scale")
	scale2:SetOrder(2)
	if scale.SetFromScale then -- XXX Dragonflight compat
		scale2:SetFromScale(1,1)
		scale2:SetToScale(0.25,0.25)
	else
		scale2:SetScaleFrom(1,1)
		scale2:SetScaleTo(0.25,0.25)
	end
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
			local go, pass = xpcall(CanReportPlayer, dummy, v)
			if go and pass then
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
	reportFrame:SetScript("OnClick", function(self)
		if IsAltKeyDown() then -- Dismiss
			prevShow = GetTime() -- Refresh throttle so we don't risk showing again straight after reporting
			self:GetParent():Hide()
			spamCollector, spamLogger = {}, {}
		else -- Report
			prevShow = GetTime() -- Refresh throttle so we don't risk showing again straight after reporting
			self:GetParent():Hide()

			local systemMsg = {GetFramesRegisteredForEvent("REPORT_PLAYER_RESULT")} -- Don't show the "Complaint Registered" message
			local calendarError = {GetFramesRegisteredForEvent("CALENDAR_UPDATE_ERROR")} -- Remove calendar error popup (Blizz bug)
			for i = 1, #systemMsg do
				systemMsg[i]:UnregisterEvent("REPORT_PLAYER_RESULT")
			end
			for i = 1, #calendarError do
				calendarError[i]:UnregisterEvent("CALENDAR_UPDATE_ERROR")
			end

			for k, v in next, spamCollector do
				local go, pass = xpcall(CanReportPlayer, dummy, v)
				if go and pass then
					BADBOY_BLACKLIST[k] = true
					if OpenReportPlayerDialog then
						OpenReportPlayerDialog("spam", "Spammer blocked by BadBoy", v)
						if not BADBOY_OPTIONS.temp82Msg then
							BADBOY_OPTIONS.temp82Msg = true
							print("|cFF33FF99BadBoy:|r This is a temporary message to inform you that as of patch 8.2 I am now forced to show you a popup to report spammers. This is a Blizz decision. I am very sorry :(")
							print("|cFF33FF99BadBoy:|r Clicking 'Report Player' on the popup will prevent this popup showing again for this specific spammer, but there may be multiple depending on how busy your server is.")
						end
					end
				end
				spamCollector[k] = nil
				spamLogger[k] = nil
				if BADBOY_BLACKLIST[k] then
					break -- Only open 1 dialog
				end
			end

			for i = 1, #systemMsg do
				-- Compensate for people taking a while to click accept
				C_Timer.After(5, function() systemMsg[i]:RegisterEvent("REPORT_PLAYER_RESULT") end)
			end
			for i = 1, #calendarError do
				-- There's a delay before the event fires
				C_Timer.After(5, function() calendarError[i]:RegisterEvent("CALENDAR_UPDATE_ERROR") end)
			end
		end
	end)
	local tt = CreateFrame("GameTooltip", "bbtt", UIParent, "GameTooltipTemplate")
	reportFrame:SetScript("OnEnter", function(self)
		tt:SetOwner(self, "ANCHOR_CURSOR")
		tt:AddLine(S.spamBlocked, 1, 1, 1)
		tt:AddLine(S.clickToReport, 1, 1, 1)
		if next(spamLogger) then
			tt:AddLine(" ", 0.5, 0.5, 1)
			for _, v in next, spamLogger do
				tt:AddLine(v, 0.2, 1, 0)
			end
		end
		tt:Show()
	end)
	reportFrame:SetScript("OnLeave", function() tt:Hide() end)
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
	local AddMessageEventFilter = ChatFrameUtil.AddMessageEventFilter
	for i = 1, #tbl do
		local event = tbl[i]
		local frames = {GetFramesRegisteredForEvent(event)}
		for j = 1, #frames do
			local frame = frames[j]
			if not f.IsForbidden(frame) then
				f.UnregisterEvent(frame, event)
			end
		end
		f:RegisterEvent(event)
		AddMessageEventFilter(event, filterFunc)
		for j = 1, #frames do
			local frame = frames[j]
			if not f.IsForbidden(frame) then
				f.RegisterEvent(frame, event)
			end
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
			local dateTbl = date("*t")
			local day = dateTbl.day
			if BADBOY_BLACKLIST.dayFromCal ~= day then
				BADBOY_BLACKLIST = {dayFromCal = day} -- Can't use ADDON_LOADED as date function isn't always ready on very first login.
			end
			SetCVar("spamFilter", 1)
			frame:UnregisterEvent(event)
			BADBOY_OPTIONS.tmp = nil
			BADBOY_OPTIONS.tmpm = nil
			BADBOY_OPTIONS.tmpl = nil
			BADBOY_OPTIONS.freqButton = nil

			-- Chat bubble restore
			frame:SetScript("OnEvent", function()
				if enableBubble then
					enableBubble = false
					SetCVar("chatBubbles", 1)
				end
			end)
			-- Hopefully we never end up in a situation where we've permanently disabled chat bubbles for the user.
			frame:RegisterEvent("PLAYER_LOGOUT")
			frame:RegisterEvent("CHAT_MSG_MONSTER_SAY")
			frame:RegisterEvent("CHAT_MSG_MONSTER_YELL")
		end
	end)
end

_G.BadBoyIsFriendly = IsFriendly
_G.BadBoyCleanse = Cleanse
