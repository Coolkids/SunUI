local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

--(\d+)(\s*,.+name\s*=\s*)\"[^"]+\"替换\1\2GetSpellInfo\(\1\)
local function Skin()
	NugRunningConfig.nameFont = { font = S["media"].font, S["media"].fontsize, alpha = 0.5 }
	NugRunningConfig.timeFont = { font = S["media"].font, S["media"].fontsize, alpha = 1 }
	NugRunningConfig.stackFont = { font = S["media"].font, S["media"].fontsize }
	NugRunningConfig.dotpowerFont = { font = S["media"].font, S["media"].fontsize-1,  alpha = 1  }
	
	NugRunningConfig.anchors = {
		main = {
			{ name = "player", gap = 4, alpha = 1 },
			{ name = "target", gap = 4, alpha = 1},
			{ name = "buffs", gap = 4, alpha = 1},
			{ name = "offtargets", gap = 4, alpha = .7},
		},
		secondary = {
			{ name = "procs", gap = 4, alpha = .8},
		},
	}
	-- Replace bar creation function
	ConstructTimerBar = function(width, height)
		local f = CreateFrame("Frame",nil,UIParent)
		f.prototype = "TimerBar"

		f:SetWidth(width-height)
		f:SetHeight(height+4)
		
		
		local ic = CreateFrame("Frame",nil,f)
		ic:SetPoint("BOTTOMRIGHT",f,"BOTTOMLEFT", -10, 0)
		ic:SetWidth(height+2)
		ic:SetHeight(height+2)
		ic:CreateShadow("Background")
		
		local ict = ic:CreateTexture(nil,"ARTWORK",0)
		ict:SetTexCoord(.07, .93, .07, .93)
		ict:SetAllPoints(ic)
		f.icon = ict
		
		f.stacktext = ic:CreateFontString(nil, "OVERLAY");
		f.stacktext:SetFont(S["media"].font, S["media"].fontsize, "OUTLINE")
		f.stacktext:SetJustifyH("RIGHT")
		f.stacktext:SetVertexColor(1,1,1)
		f.stacktext:SetPoint("LEFT", ic, "RIGHT",-9,-3)
		
		f.bar = CreateFrame("StatusBar",nil,f)
		f.bar:CreateShadow("Background")
		
		f.bar:SetFrameStrata("MEDIUM")
		f.bar:SetStatusBarTexture(S["media"].normal)
		f.bar:GetStatusBarTexture():SetDrawLayer("ARTWORK")
		f.bar:SetHeight(height/2)
		f.bar:SetWidth(width - height )
		f.bar:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",0,0)
		A:CreateMark(f.bar)
		
		f.bar.bg = f.bar:CreateTexture(nil, "BORDER")
		f.bar.bg:SetAllPoints(f.bar)
		--f.bar.bg:SetTexture(tex)
		
		f.timeText = f.bar:CreateFontString(nil, "OVERLAY", 2);
		f.timeText:SetFont(S["media"].font, S["media"].fontsize, "THINOUTLINE")
		f.timeText:SetJustifyH("LEFT")
		f.timeText:SetVertexColor(1,1,1)
		f.timeText:SetPoint("LEFT", f.bar, "LEFT",0,height/2)
			
		f.timeText.SetFormattedText = SetTimeText
		
		f.spellText = f.bar:CreateFontString(nil, "OVERLAY", 2);
		f.spellText:SetFont(S["media"].font, S["media"].fontsize, "THINOUTLINE")
		f.spellText:SetWidth(f.bar:GetWidth()*0.7)
		f.spellText:SetHeight(height/2+1)
		f.spellText:SetJustifyH("RIGHT")
		f.spellText:SetPoint("RIGHT", f.bar, "RIGHT",0,height/2)
		f.spellText.SetName = SpellTextUpdate
		
		local overlay = f.bar:CreateTexture(nil, "ARTWORK", nil, 3)
		overlay:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
		overlay:SetVertexColor(0,0,0, 0.2)
		overlay:Hide()
		f.overlay = overlay
		
		f.SetColor = TimerBarSetColor
		
		local powertext = f.bar:CreateFontString()
	    powertext:SetFont(S["media"].font, S["media"].fontsize, "THINOUTLINE")
		powertext:SetPoint("BOTTOMLEFT", f.bar, "BOTTOMRIGHT",2,0)
		powertext:SetShadowColor(0, 0, 0)
		powertext:SetShadowOffset(1, -1)
		
		local sbg = f.bar:CreateTexture(nil, "ARTWORK", nil, 5)
		sbg:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
		sbg:SetVertexColor(0,0,0, 0)
		sbg:SetAllPoints(powertext)
		powertext.bg = sbg
		f.status = powertext
		
		
		local at = ic:CreateTexture(nil,"OVERLAY")
		at:SetTexture([[Interface\SpellActivationOverlay\IconAlert]])
		at:SetTexCoord(0.00781250,0.50781250,0.27734375,0.52734375)
		at:SetWidth(height*1.8)
		at:SetHeight(height*1.8)
		at:SetPoint("CENTER",f.icon,"CENTER",0,0)
		at:SetAlpha(0)
		
		local sag = at:CreateAnimationGroup()
		local sa1 = sag:CreateAnimation("Alpha")
		sa1:SetChange(1)
		sa1:SetDuration(0.3)
		sa1:SetOrder(1)
		local sa2 = sag:CreateAnimation("Alpha")
		sa2:SetChange(-1)
		sa2:SetDuration(0.5)
		sa2:SetSmoothing("OUT")
		sa2:SetOrder(2)
		
		f.shine = sag
		f.shine.tex = at
		
		local aag = f:CreateAnimationGroup()
		local aa1 = aag:CreateAnimation("Scale")
		aa1:SetOrigin("BOTTOM",0,0)
		aa1:SetScale(1,0.1)
		aa1:SetDuration(0)
		aa1:SetOrder(1)
		local aa2 = aag:CreateAnimation("Scale")
		aa2:SetOrigin("BOTTOM",0,0)
		aa2:SetScale(1,10)
		aa2:SetDuration(0.15)
		aa2:SetOrder(2)
		
		local glow = f:CreateAnimationGroup()
		local ga1 = glow:CreateAnimation("Alpha")
		ga1:SetChange(-0.5)
		ga1:SetDuration(0.25)
		ga1:SetOrder(1)
		glow:SetLooping("BOUNCE")
		f.glow = glow
		
		f.animIn = aag
			 
		local m = CreateFrame("Frame",nil,self)
		m:SetParent(f)
		m:SetWidth(16)
		m:SetHeight(f:GetHeight()/2)
		m:SetFrameLevel(4)
		m:SetAlpha(1)
		
		local texture = m:CreateTexture(nil, "OVERLAY")
		texture:SetTexture("Interface\\AddOns\\SunUI\\media\\mark")
		texture:SetVertexColor(0,0,0,1)
		texture:SetAllPoints(m)
		m.texture = texture
		
		local spark = m:CreateTexture(nil, "OVERLAY")
		spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
		spark:SetAlpha(0)
		spark:SetWidth(20)
		spark:SetHeight(m:GetWidth()*4)
		spark:SetPoint("CENTER",m)
		spark:SetBlendMode('ADD')
		spark.mark = m
		spark.CatchUp = function(self)
			local markpoint = 
			self:SetPoint(self.mark:GetPoint())
		end
		m.spark = spark
		
		local ag = spark:CreateAnimationGroup()
		local a1 = ag:CreateAnimation("Alpha")
		a1:SetChange(1)
		a1:SetDuration(0.2)
		a1:SetOrder(1)
		local a2 = ag:CreateAnimation("Alpha")
		a2:SetChange(-1)
		a2:SetDuration(0.4)
		a2:SetOrder(2)
		
		m.shine = ag

		f.mark = m

		return f
	end
	NugRunning.ConstructTimerBar = ConstructTimerBar

	function NugRunning.TimerBar.SetPowerStatus(self, status, powerdiff)
		if status == "HIGH" then
			self.status:SetTextColor(.1,1,.1)
			self.status:SetText("+"..powerdiff)
			self.status:Show()
			self.status.bg:Hide()
		elseif status == "LOW" then
			self.status:SetTextColor(1,.1,.1)
			self.status:SetText(powerdiff)
			self.status:Show()
			self.status.bg:Hide()
		else
			self.status:Hide()
			self.status.bg:Hide()
		end
	end
	function NugRunning:DoNameplates()

		local next = next
		local table_remove = table.remove

		local makeicon = true

		local Nplates
		local plates = {}

		local oldTargetGUID
		local guidmap = {}

		local function OnHide(frame)
			local frame_guid = frame.guid
			if frame_guid then
				guidmap[frame_guid] = nil
				frame.guid = nil
				if frame_guid == oldTargetGUID then
					oldTargetGUID = nil
				end
			end
			for _, timer in ipairs(frame.timers) do
				timer:Hide()
			end
		end

		local function HookFrames(...)
			for index=1,select("#", ...) do
				local frame = select(index, ...)
				local region = frame:GetRegions()
				local fname = frame:GetName()
				if  not plates[frame] and
					fname and string.find(fname, "NamePlate")
				then
					local hp, cb = frame:GetChildren()
					local threat, hpborder, overlay, oldname, oldlevel, bossicon, raidicon, elite = frame:GetRegions()
					local _, cbborder, cbshield, cbicon = cb:GetRegions()
					frame.name = oldname
					frame.timers = {}
					-- frame.healthBar = healthBar
					-- frame.castBar = castBar
					plates[frame] = true
					frame:HookScript("OnHide", OnHide)
				end
			end
		end

		NugRunningNameplates = CreateFrame("Frame")
		NugRunningNameplates:SetScript('OnUpdate', function(self, elapsed)
			if(WorldFrame:GetNumChildren() ~= Nplates) then
				Nplates = WorldFrame:GetNumChildren()
				HookFrames(WorldFrame:GetChildren())
			end
			if UnitExists("target") then
				local targetGUID = UnitGUID("target")
				for frame in pairs(plates) do
					if frame:IsShown() and frame:GetAlpha() == 1 and
						(UnitName("target") == frame.name:GetText()) and
						targetGUID ~= oldTargetGUID then
							guidmap[targetGUID] =  frame
							frame.guid = targetGUID
							oldTargetGUID = targetGUID
							local guidTimers = NugRunning:GetTimersByDstGUID(targetGUID)
							NugRunningNameplates:UpdateNPTimers(frame, guidTimers)
							return
							-- frame.name:SetText(targetGUID)
					end
				end
			else
				oldTargetGUID = nil
			end
		end)

		local MiniOnUpdate = function(self, time)
			self._elapsed = self._elapsed + time
			if self._elapsed < 0.02 then return end
			self._elapsed = 0

			local endTime = self.endTime
			local beforeEnd = endTime - GetTime()

			self:SetValue(beforeEnd + self.startTime)
		end

		local backdrop = {
				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				tile = true, tileSize = 0,
				insets = {left = -1, right = -1, top = -1, bottom = -1},
			}

		function NugRunningNameplates:CreateNameplateTimer(frame)
			local f = CreateFrame("StatusBar", nil, frame)
			f:SetStatusBarTexture(S["media"].normal, "OVERLAY")
			f:SetWidth(70)
			local h = 7
			f:SetHeight(h)

			if makeicon then
				local icon = f:CreateTexture("ARTWORK")
				-- icon:SetTexCoord(.1, .9, .1, .9)
				-- icon:SetHeight(h); icon:SetWidth(h)
				icon:SetTexCoord(.1, .9, .1, .9)
				icon:SetHeight(h*2); icon:SetWidth(2*h)
				icon:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT",-5,0)
				-- backdrop.insets.left = -h -1
				local border = CreateFrame("Frame", nil, f)
				border:SetFrameLevel(1)
				border:SetPoint("TOPLEFT", icon, -1, 1)
				border:SetPoint("BOTTOMRIGHT", icon, 1, -1)
				border:CreateBorder()
				backdrop.insets.left = -(h*2) -1
				f.icon = icon
			end
			f:CreateShadow("Background")
			
			local bg = f:CreateTexture("BACKGROUND", nil, -5)
			bg:SetTexture(nil)
			bg:SetAllPoints(f)
			f.bg = bg

			f._elapsed = 0
			f:SetScript("OnUpdate", MiniOnUpdate)

			if not next(frame.timers) then
				f:SetPoint("BOTTOM", frame, "TOP", 0, 3)
			else
				local prev = frame.timers[#frame.timers]
				f:SetPoint("BOTTOM", prev, "TOP", 0,h)
			end
			table.insert(frame.timers, f)
			return f
		end

		function NugRunningNameplates:Update(targetTimers, guidTimers)
			local tGUID = UnitGUID("target")
			if tGUID then
				guidTimers[tGUID] = targetTimers
			end
			for guid, np in pairs(guidmap) do
				local nrunTimers = guidTimers[guid]
				self:UpdateNPTimers(np, nrunTimers)
			end
		end

		function NugRunningNameplates:UpdateNPTimers(np, nrunTimers)
			if nrunTimers then
				local i = 1
				while i <= #nrunTimers do
					local timer = nrunTimers[i]
					if not timer.opts.nameplates or timer.isGhost then
						table_remove(nrunTimers, i)
					else
						i = i + 1
					end
				end

				local max = math.max(#nrunTimers, #np.timers)
				for i=1, max do
					local npt = np.timers[i]
					local nrunt = nrunTimers[i]
					if not npt then npt = self:CreateNameplateTimer(np) end
					if not nrunt  then
						npt:Hide()
					else
						npt.startTime = nrunt.startTime
						npt.endTime = nrunt.endTime
						npt:SetMinMaxValues(nrunt.bar:GetMinMaxValues())
						local r,g,b = nrunt.bar:GetStatusBarColor()
						npt:SetStatusBarColor(r,g,b)
						npt.bg:SetVertexColor(r*.4,g*.4,b*.4)
						if npt.icon then
							npt.icon:SetTexture(nrunt.icon:GetTexture())
						end
						npt:Show()
					end

				end
			else
				for _, timer in ipairs(np.timers) do
					timer:Hide()
				end
			end
		end
	end
end

A:RegisterSkin("NugRunning", Skin)
