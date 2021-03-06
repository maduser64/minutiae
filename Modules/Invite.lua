﻿MinutiaeInvite = Minutiae:NewModule("MinutiaeInvite", "AceConsole-3.0", "AceEvent-3.0")

function MinutiaeInvite:OnEnable()
	self:RegisterEvent("PARTY_INVITE_REQUEST")
	if not Minutiae.db.global.invite then
		self:Disable()
	end
end

function MinutiaeInvite:OnDisable()
	self:UnregisterEvent("PARTY_INVITE_REQUEST")
end

function MinutiaeInvite:GROUP_ROSTER_UPDATE()
	for i=1, STATICPOPUP_NUMDIALOGS do
		local frame = _G["StaticPopup"..i]
		if frame:IsVisible() and (frame.which == "PARTY_INVITE" or frame.which == "PARTY_INVITE_XREALM") then
			frame.inviteAccepted = 1
			StaticPopup_Hide(frame.which)
			break
		end
	end
	self:UnregisterEvent("GROUP_ROSTER_UPDATE")
end

function MinutiaeInvite:AcceptPartyInvite()
	self:RegisterEvent("GROUP_ROSTER_UPDATE")	
	AcceptGroup()
end

function MinutiaeInvite:PARTY_INVITE_REQUEST(_, arg)
	for i=1, GetNumFriends() do
		if GetFriendInfo(i) == arg then
			self:AcceptPartyInvite()
			return
		end
	end

	local realm = gsub(GetRealmName(), " ", "");
	for i = 1, select(2, BNGetNumFriends()) do
		for j = 1, BNGetNumFriendGameAccounts(i) do
			local _, toonName, client, realmName = BNGetFriendGameAccountInfo(i, j);
			if client == "WoW" then
				local fullName = toonName.."-"..realmName
				if (realmName == realm and toonName == arg) or fullName == arg then
					self:AcceptPartyInvite()
					return
				end
			end
		end
	end

	for i=1, GetNumGuildMembers() do
		if Ambiguate(GetGuildRosterInfo(i), "guild") == arg then
			self:AcceptPartyInvite()
			return
		end
	end
end