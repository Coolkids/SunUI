local S, L, DB, _, C = unpack(select(2, ...))
local _
local function Hook_FriendsList_Update()
	local friendOffset = HybridScrollFrame_GetOffset(FriendsFrameFriendsScrollFrame);
	if not friendOffset then
		return;
	end
	if friendOffset < 0 then
		friendOffset = 0;
	end

	local numBNetTotal, numBNetOnline = BNGetNumFriends();
	if numBNetOnline > 0 then
		for i=1, numBNetOnline, 1 do
			local _, realName, _, _, toonName, toonID, client, _, _, _, _, _, _, _, _ = BNGetFriendInfo(i);
			if client == BNET_CLIENT_WOW then
				local _, _, _, realmName, _, _, _, class, _, zoneName, level, _ = BNGetToonInfo(toonID);
				for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
				if GetLocale() ~= "enUS" then
					for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do if class == v then class = k end end
				end
				local classc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
				if not classc then
					return;
				end
				local nameString = _G["FriendsFrameFriendsScrollFrameButton"..(i-friendOffset).."Name"];
				if nameString then
					nameString:SetText(realName.." ("..toonName..", L"..level..")");
					nameString:SetTextColor(classc.r, classc.g, classc.b);
				end
				if CanCooperateWithToon(toonID) ~= true then
					local nameString = _G["FriendsFrameFriendsScrollFrameButton"..(i-friendOffset).."Info"];
					if nameString then
						nameString:SetText(zoneName.." ("..realmName..")");
					end
				end
			end
		end
	end

	local numberOfFriends, onlineFriends = GetNumFriends();
	if onlineFriends > 0 then
		for i=1, onlineFriends, 1 do
			j = i + numBNetOnline;
			local name, level, class, area, connected, status, note, RAF = GetFriendInfo(i);
			for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
			if GetLocale() ~= "enUS" then
				for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do if class == v then class = k end end
			end
			local classc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
			if not classc then
				return;
			end
			if connected then
				local nameString = _G["FriendsFrameFriendsScrollFrameButton"..(j-friendOffset).."Name"];
				if nameString and name then
					nameString:SetText(name..", L"..level);
					nameString:SetTextColor(classc.r, classc.g, classc.b);
				end
			end
		end
	end
end;
hooksecurefunc("FriendsList_Update", Hook_FriendsList_Update);
hooksecurefunc("HybridScrollFrame_Update", Hook_FriendsList_Update);