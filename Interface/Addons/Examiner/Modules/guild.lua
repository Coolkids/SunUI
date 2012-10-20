local ex = Examiner;

-- Module
local mod = ex:CreateModule("Guild","Guild Details");
mod.help = "Basic Guild Details";
mod:CreatePage(false);
mod:HasButton(true);
mod.canCache = true;

local page = mod.page;
local banner = {};
local bannerCache;

--------------------------------------------------------------------------------------------------------
--                                           Module Scripts                                           --
--------------------------------------------------------------------------------------------------------

-- OnInspectReady
function mod:OnInspectReady(unit,guid)
	-- local bkgR, bkgG, bkgB, borderR, borderG, borderB, emblemR, emblemG, emblemB, emblemFilename = GetGuildLogoInfo(ex.unit);
	banner[1], banner[2], banner[3], banner[4], banner[5], banner[6], banner[7], banner[8], banner[9], banner[10] = GetGuildLogoInfo(ex.unit);
	self:HasData(ex.info.guildLevel);	-- MoP: Changed this from guildID to guildLevel, as that is no longer available as 1st return in GetInspectGuildInfo()
	self:UpdateGuildInfo();
end

-- OnCache
function mod:OnCache(entry)
	if (self:CanCache()) then
		entry.GuildBanner = CopyTable(banner);
	end
end

-- OnCacheLoaded
function mod:OnCacheLoaded(entry,unit)
	bannerCache = entry.GuildBanner;
	self:HasData(ex.info.guildLevel);
	self:UpdateGuildInfo();
end

-- OnClearInspect
function mod:OnClearInspect()
	wipe(banner);
	bannerCache = nil;
	self:HasData(nil);
	self:UpdateGuildInfo();
end

--------------------------------------------------------------------------------------------------------
--                                                Code                                                --
--------------------------------------------------------------------------------------------------------

-- Get Max XP for Level, No function to query max guild xp for a certain level, so we use this formula -- Az: This is not 100% correct, but almost!
function mod:GetGuildXPMax(level)
	return (16580000 + 1660000 * (level - 1));
end

-- Update Widgets
function mod:UpdateGuildInfo()
	local page = self.page;
	local info = ex.info;
	if (not ex.info.guildLevel) then
		page.guild:SetText();
		page.info:SetText();
		page.status:SetValue(0);
		page.statusText:SetText();
		SetDoubleGuildTabardTextures(nil,mod.page.leftIcon,mod.page.rightIcon,mod.page.banner,mod.page.bannerBorder,banner);	-- banner table should be empty here, so we draw a grey banner
	else
		local guildXPMax = self:GetGuildXPMax(info.guildLevel);

		page.guild:SetText(info.guild);
		page.info:SetFormattedText("%s %s - %s %s",LEVEL,info.guildLevel,info.guildMembers,MEMBERS);

		page.status:SetMinMaxValues(0,guildXPMax);
		page.status:SetValue(info.guildXP);
		page.statusText:SetFormattedText("%dk / %dk (%.0f%%)",info.guildXP / 1000,guildXPMax / 1000,info.guildXP / guildXPMax * 100);

		local bannerData = (ex.isCacheEntry and bannerCache or banner);
		SetDoubleGuildTabardTextures(nil,mod.page.leftIcon,mod.page.rightIcon,mod.page.banner,mod.page.bannerBorder,bannerData);
	end
end

--------------------------------------------------------------------------------------------------------
--                                               Widgets                                              --
--------------------------------------------------------------------------------------------------------

local logoScale = 1.2;

-- FontStrings
page.guild = page:CreateFontString(nil,"ARTWORK");
page.guild:SetPoint("CENTER",0,-54);
page.guild:SetFont(GameFontNormal:GetFont(),18,"OUTLINE");
page.guild:SetTextColor(1,1,1);

page.info = page:CreateFontString(nil,"ARTWORK");
page.info:SetPoint("TOP",page.guild,"BOTTOM");
page.info:SetFont(GameFontNormal:GetFont(),12,"OUTLINE");
page.info:SetTextColor(1,1,0);

-- Status
page.status = CreateFrame("StatusBar",nil,page);
page.status:SetHeight(20);
page.status:SetPoint("BOTTOMLEFT",20,20);
page.status:SetPoint("BOTTOMRIGHT",-20,20);
page.status:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
page.status:SetStatusBarColor(0.2,1,0.2);

page.statusBG = page:CreateTexture(nil,"BACKGROUND");
page.statusBG:SetHeight(20);
page.statusBG:SetPoint("BOTTOMLEFT",20,20);
page.statusBG:SetPoint("BOTTOMRIGHT",-20,20);
page.statusBG:SetTexture(0,0,0);

page.statusText = page.status:CreateFontString(nil,"ARTWORK","GameFontHighlight");
page.statusText:SetPoint("CENTER");
page.statusText:SetFont(GameFontNormal:GetFont(),12,"OUTLINE");

-- Banner
page.banner = page:CreateTexture(nil,"BACKGROUND",nil,1);
page.banner:SetWidth(118 * logoScale);
page.banner:SetHeight(144 * logoScale);
page.banner:SetPoint("TOP",0,-6);
page.banner:SetTexture("Interface\\GuildFrame\\GuildInspect-Parts");
page.banner:SetTexCoord(0.23632813,0.46679688,0.70117188,0.98242188);

page.bannerBorder = page:CreateTexture(nil,"BACKGROUND",nil,2);
page.bannerBorder:SetWidth(118 * logoScale);
page.bannerBorder:SetHeight(144 * logoScale);
page.bannerBorder:SetPoint("TOPLEFT",page.banner);
page.bannerBorder:SetTexture("Interface\\GuildFrame\\GuildInspect-Parts");
page.bannerBorder:SetTexCoord(0.00195313,0.23242188,0.70117188,0.98242188);

-- Banner Icons
page.leftIcon = page:CreateTexture(nil,"ARTWORK");
page.leftIcon:SetWidth(50 * logoScale);
page.leftIcon:SetHeight(125 * logoScale);
page.leftIcon:SetPoint("CENTER",page.banner,-25 * logoScale,0);
page.leftIcon:SetTexCoord(1,0,0,1);

page.rightIcon = page:CreateTexture(nil,"ARTWORK");
page.rightIcon:SetWidth(50 * logoScale);
page.rightIcon:SetHeight(125 * logoScale);
page.rightIcon:SetPoint("LEFT",page.leftIcon,"RIGHT",-1,0);