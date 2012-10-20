local ex = Examiner;

-- Module
local mod = ex:CreateModule(PVP,PLAYER_V_PLAYER);
mod.help = "Honor & Arena Details";
mod:CreatePage(true,PLAYER_V_PLAYER);
mod:HasButton(true);
mod.canCache = true;

-- Variables
local labels = {};
local arena = {};

-- Data Variables -- Honor & Arena Data
local hd, ad = {}, {};

--------------------------------------------------------------------------------------------------------
--                                           Module Scripts                                           --
--------------------------------------------------------------------------------------------------------

-- OnInitialize
function mod:OnInitialize()
	for i = 1, MAX_ARENA_TEAMS do
		ad[i] = {};
	end
end

-- OnInspect
function mod:OnInspect(unit)
	if (ex.isSelf) then
		self:LoadHonorNormal();
		self:LoadArenaTeamsNormal();
	end
	if (ex.canInspect) then
		ex:RequestHonorData();
	end
end

-- OnHonorReady
function mod:OnHonorReady()
	self:LoadHonorNormal();
	self:LoadArenaTeamsNormal();
end

-- OnCacheLoaded
function mod:OnCacheLoaded(entry,unit)
	if (entry.Honor) then
		self:HasData(true);
		-- Honor
		for name, value in next, entry.Honor do
			hd[name] = value;
		end
		self:UpdateHonor();
		-- Arena
		for i = 1, MAX_ARENA_TEAMS do
			if (entry["Arena"..i]) then
				local at = ad[i];
				for name, value in next, entry["Arena"..i] do
					at[name] = value;
				end
			end
		end
		self:ArenaTeamUpdate();
	end
end

-- OnCache
function mod:OnCache(entry)
	if (self:CanCache()) and (next(hd)) then
		entry.Honor = CopyTable(hd);
	 	for i = 1, MAX_ARENA_TEAMS do
	 		if (ad[i].teamName) then
		 		entry["Arena"..i] = CopyTable(ad[i]);
	 		end
		end
	end
end

-- OnClearInspect
function mod:OnClearInspect()
	self:HasData(nil);
	-- Header
	self.rankIcon:Hide();
	-- Clear Honor
	wipe(hd);
	for i = 4, 9 do
		labels[i]:SetText("---");
	end
	labels[9]:SetTextColor(1,1,0);
	-- Hide Arena Teams
	for i = 1, MAX_ARENA_TEAMS do
		wipe(ad[i]);
		arena[i]:Hide();
	end
end

--------------------------------------------------------------------------------------------------------
--                                       Arena Point Calculator                                       --
--------------------------------------------------------------------------------------------------------

-- http://www.arenajunkies.com/showthread.php?t=222736
-- (-6e-13*1500)^5+(7e-9*1500)^4-(4e-5*1500)^3+(0.0863*1500)^2-98.66*1500+43743

-- Calculate Arena Points -- Updated Formula for 2.2 -- Now always uses 1500 rating if rating is less than that
local function CalculateArenaPoints(teamRating,teamSize)
	local multiplier = (teamSize == 5 and 1) or (teamSize == 3 and 0.88) or (teamSize == 2 and 0.76)
	if (teamRating <= 1500) then
		return multiplier * (0.22 * 1500 + 14);
	else
		return multiplier * (1511.26 / (1 + 1639.28 * 2.71828 ^ (-0.00412 * teamRating)));
	end
end

-- Slash Command -- Arena Calculator
ex.slashHelp[#ex.slashHelp + 1] = " |2arena <rating>|r = Arena Point Calculator";
ex.slashFuncs["arena"] = function(cmd)
	cmd = tonumber(cmd);
	if (type(cmd) == "number") then
		AzMsg(format("|2Arena Point Calculation|r |1%d|r Rating |2=|r 2v2: |1%.1f|r, 3v3: |1%.1f|r, 5v5: |1%.1f|r.",cmd,CalculateArenaPoints(cmd,2),CalculateArenaPoints(cmd,3),CalculateArenaPoints(cmd,5)));
	end
end

--------------------------------------------------------------------------------------------------------
--                                             PvP Stuff                                              --
--------------------------------------------------------------------------------------------------------

-- Format Numbers
local function FormatNumbers(self,value,max)
	local color = (value == 0 and "|cffff8080" or "|cffffff80");
	if (max == 0) then
		self:SetFormattedText("%s0|r (%1$s0%%|r)",color);
	else
		self:SetFormattedText("%s%d|r (%s%.1f%%|r)",color,value,color,value / max * 100);
	end
end

-- Load Honor Normal
function mod:LoadHonorNormal()
	self:HasData(true);
	-- Query -- Az: Even if inspecting ourself, use inspect data as GetPVPYesterdayStats() is bugged as of (4.0.1 - 4.0.3a)
	if (not ex.isSelf) or (HasInspectHonorData()) then
		hd.todayHK, hd.todayHonor, hd.yesterdayHK, hd.yesterdayHonor, hd.lifetimeHK, hd.lifetimeRank = GetInspectHonorData();
	else
		hd.todayHK, hd.todayHonor = GetPVPSessionStats();
		hd.yesterdayHK, hd.yesterdayHonor = GetPVPYesterdayStats();
		hd.lifetimeHK, hd.lifetimeRank = GetPVPLifetimeStats();
	end
	-- Update
	self:UpdateHonor();
end

-- Honor Update
function mod:UpdateHonor()
	-- Show Rank
	if (hd.lifetimeRank ~= 0) then
		self.rankIcon.texture:SetTexture("Interface\\PvPRankBadges\\PvPRank"..format("%.2d",hd.lifetimeRank - 4));
		self.rankIcon.texture:SetTexCoord(0,1,0,1);
		self.rankIcon.tip = format("%s (Rank %d)",GetPVPRankInfo(hd.lifetimeRank,ex.unit),(hd.lifetimeRank - 4));
		self.rankIcon:Show();
	end
	-- Show Kills/Honor
	labels[4]:SetText(hd.todayHK);
	labels[5]:SetText(hd.yesterdayHK);
	labels[6]:SetText(hd.lifetimeHK);
	labels[7]:SetText(hd.todayHonor);
	labels[8]:SetText(hd.yesterdayHonor);
	labels[9]:SetText("---");
	labels[9]:SetTextColor(1,1,0);
end

-- Load Arena Teams Normal
function mod:LoadArenaTeamsNormal()
	for i = 1, MAX_ARENA_TEAMS do
		local at = ad[i];
		if (ex.isSelf) then
			at.teamName, at.teamSize, at.teamRating, at.teamPlayed, at.teamWins, at.seasonTeamPlayed, at.seasonTeamWins, at.playerPlayed, at.seasonPlayerPlayed, at.teamRank, at.playerRating, at.backR, at.backG, at.backB, at.emblem, at.emblemR, at.emblemG, at.emblemB, at.border, at.borderR, at.borderG, at.borderB = GetArenaTeam(i);
			at.teamPlayed, at.teamWins, at.playerPlayed = at.seasonTeamPlayed, at.seasonTeamWins, at.seasonPlayerPlayed;
		else
			at.teamName, at.teamSize, at.teamRating, at.teamPlayed, at.teamWins, at.playerPlayed, at.playerRating, at.backR, at.backG, at.backB, at.emblem, at.emblemR, at.emblemG, at.emblemB, at.border, at.borderR, at.borderG, at.borderB = GetInspectArenaTeamData(i);
		end
	end
	self:ArenaTeamUpdate();
end

-- Arena Team Update
function mod:ArenaTeamUpdate()
	for i = 1, MAX_ARENA_TEAMS do
		local at = ad[i];
		if (at.teamName) then
			local index = (at.teamSize == 2 and 1) or (at.teamSize == 3 and 2) or (at.teamSize == 5 and 3);
			local f = arena[index];
			-- General
			f.name:SetText(at.teamName);
			f.rating:SetText(at.teamRating);
			-- Games/Played
			f.details[1].right:SetFormattedText("|cffffff80%d",at.teamPlayed);
			FormatNumbers(f.details[2].right,at.playerPlayed,at.teamPlayed);
			-- Wins/Loss
			FormatNumbers(f.details[3].right,at.teamWins,at.teamPlayed);
			FormatNumbers(f.details[4].right,at.teamPlayed - at.teamWins,at.teamPlayed);
			-- Estimated Points & Personal Rating
			f.details[5].right:SetFormattedText("|cffffff80%.1f",CalculateArenaPoints(at.teamRating,at.teamSize));
			f.details[6].right:SetFormattedText("|cffffff80%s",tostring(at.playerRating));
			-- Banner
			f.banner:SetTexture("Interface\\PVPFrame\\PVP-Banner-"..at.teamSize);
			f.banner:SetVertexColor(at.backR,at.backG,at.backB);
			f.emblem:SetVertexColor(at.emblemR,at.emblemG,at.emblemB);
			f.border:SetVertexColor(at.borderR,at.borderG,at.borderB);
			f.border:SetTexture(at.border ~= -1 and "Interface\\PVPFrame\\PVP-Banner-"..at.teamSize.."-Border-"..at.border or nil);
			f.emblem:SetTexture(at.emblem ~= -1 and "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-"..at.emblem or nil);
			-- Show Frame
			f:Show();
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Widget Creation                                          --
--------------------------------------------------------------------------------------------------------

-- Rank Icon
mod.rankIcon = CreateFrame("Frame",nil,mod.page);
mod.rankIcon:SetPoint("TOPLEFT",12,-12);
mod.rankIcon:SetWidth(18);
mod.rankIcon:SetHeight(18);
mod.rankIcon:EnableMouse(1);
mod.rankIcon:SetScript("OnEnter",function(self) GameTooltip:SetOwner(self,"ANCHOR_BOTTOMRIGHT"); GameTooltip:SetText(self.tip) end)
mod.rankIcon:SetScript("OnLeave",ex.HideGTT);
mod.rankIcon.texture = mod.rankIcon:CreateTexture(nil,"ARTWORK");
mod.rankIcon.texture:SetAllPoints();

-- Honor Labels
for i = 1, 9 do
	local l = mod.page:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
	l:SetWidth(70);

	if (i <= 3) then
		l:SetText(i == 1 and "Today" or i == 2 and "Yesterday" or "Lifetime");
		l:SetTextColor(0.5,0.75,1);
	else
		l:SetTextColor(1,1,0);
	end

	if ((i - 1) % 3 == 0) then
		l:SetPoint("TOP",-28,-36 - (i - 1) / 3 * 12);
	else
		l:SetPoint("LEFT",labels[i - 1],"RIGHT");
	end

	labels[i] = l;
end

-- Honor Label Side Headers
local t = mod.page:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
t:SetPoint("RIGHT",labels[4],"LEFT");
t:SetWidth(70);
t:SetJustifyH("LEFT");
t:SetText("Honor Kills");
t:SetTextColor(0.5,0.75,1);

t = mod.page:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
t:SetPoint("RIGHT",labels[7],"LEFT");
t:SetWidth(70);
t:SetJustifyH("LEFT");
t:SetText("Honor Points");
t:SetTextColor(0.5,0.75,1);

-- Detail Frame for Arena Frames
local function MakeDetailFrame(parent)
	local f = CreateFrame("Frame",nil,parent);
	f:SetWidth(118);
	f:SetHeight(12);

	f.left = f:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
	f.left:SetPoint("LEFT");

	f.right = f:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
	f.right:SetPoint("RIGHT");
	f.right:SetTextColor(0.5,0.75,1);

	return f;
end

-- Arena
local backdrop = { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 } };
local labelNames = { "Games", "Played", "Wins", "Losses", "Calculated Points", "PR" };
for i = 1, MAX_ARENA_TEAMS do
	local a = CreateFrame("Frame",nil,mod.page);
	a:SetWidth(304);
	a:SetHeight(82);
	a:SetBackdrop(backdrop);
	a:SetBackdropColor(0.1,0.22,0.35,1);
	a:SetBackdropBorderColor(0.7,0.7,0.8,1);

	a.banner = a:CreateTexture(nil,"BORDER");
	a.banner:SetPoint("TOPLEFT",6,-4);
	a.banner:SetWidth(45);
	a.banner:SetHeight(90);
	a.border = a:CreateTexture(nil,"ARTWORK");
	a.border:SetPoint("CENTER",a.banner);
	a.border:SetWidth(45);
	a.border:SetHeight(90);
	a.emblem = a:CreateTexture(nil,"OVERLAY");
	a.emblem:SetPoint("CENTER",a.border,-5,17);
	a.emblem:SetWidth(24);
	a.emblem:SetHeight(24);

	a.name = a:CreateFontString(nil,"ARTWORK","GameFontHighlight");
	a.name:SetPoint("TOPLEFT",50,-8)
	a.name:SetTextColor(0.5,0.75,1);

	a.rating = a:CreateFontString(nil,"ARTWORK","GameFontHighlight");
	a.rating:SetPoint("TOPRIGHT",-8,-8)
	a.rating:SetTextColor(0.5,0.75,1);

	a.size = a:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
	a.size:SetPoint("BOTTOMRIGHT",-8,8)
	a.size:SetFormattedText("%dv%1$d",floor(i + i / 2 + 0.5));

	a.details = {};
	for index, label in ipairs(labelNames) do
		local d = MakeDetailFrame(a);
		d.left:SetText(label);
		d.id = index;

		if (index % 2 == 1) then
			d:SetPoint("TOPLEFT",50,-29 - (index - 1) / 2 * 12 - (index == 5 and 6 or 0));
		else
			d:SetPoint("LEFT",a.details[index - 1],"RIGHT",8,0);
		end

		a.details[#a.details + 1] = d;
	end
	a.details[#a.details - 1]:SetWidth(130);
	a.details[#a.details]:SetWidth(50);

	if (i == 1) then
		a:SetPoint("TOPLEFT",8,-75);
	else
		a:SetPoint("TOP",arena[i - 1],"BOTTOM");
	end

	arena[i] = a;
end