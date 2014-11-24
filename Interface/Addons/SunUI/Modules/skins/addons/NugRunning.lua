local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local A = S:GetModule("Skins")

--(\d+)(\s*,.+name\s*=\s*)\"[^"]+\"替换\1\2GetSpellInfo\(\1\)
local function Skin()
	NugRunningConfig.nameFont = { font = S["media"].font, size = S["media"].fontsize, alpha = 0.5 }
	NugRunningConfig.timeFont = { font = S["media"].font, size = S["media"].fontsize, alpha = 1 }
	NugRunningConfig.stackFont = { font = S["media"].font, size = S["media"].fontsize }
	NugRunningConfig.dotpowerFont = { font = S["media"].font, size = S["media"].fontsize-1,  alpha = 1  }
	
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
	
	local NugRunning = NugRunning
	local TimerBar = NugRunning and NugRunning.TimerBar

	-- Creates timerbar
	local _ConstructTimerBar = NugRunning.ConstructTimerBar
	function NugRunning.ConstructTimerBar(w, h)
		local f = _ConstructTimerBar(w, h)

		f:SetBackdrop(nil)

		local ic = f.icon:GetParent()
		ic:CreateShadow()

		f.bar:CreateShadow()

		f.bar:SetStatusBarTexture(S["media"].normal)
		f.bar:GetStatusBarTexture():SetDrawLayer("ARTWORK")
		f.bar.bg:SetTexture(S["media"].normal)
		f.bar.bg:SetAlpha(0.5)
		A:CreateMark(f.bar)

		f.timeText:SetFont(S["media"].font, S["media"].fontsize, "THINOUTLINE")
		f.timeText:SetShadowOffset(S.mult, -S.mult)
		f.spellText:SetFont(S["media"].font, S["media"].fontsize, "THINOUTLINE")
		f.spellText:SetShadowOffset(S.mult, -S.mult)
		f.stacktext:SetFont(S["media"].font, S["media"].fontsize, "THINOUTLINE")
		f.stacktext:SetShadowOffset(S.mult, -S.mult)

		TimerBar.Resize(f, w, h)

		return f
	end

	-- Resizes timerbar
	local _Resize = TimerBar.VScale
	function TimerBar.Resize(f, w, h)
		_Resize(f, w, h)

		local ic = f.icon:GetParent()
		ic:ClearAllPoints()
		ic:SetPoint("TOPLEFT", f, 1, -1)
		ic:SetPoint("BOTTOMLEFT", f, 1, 0)
		
		f.bar:ClearAllPoints()
		f.bar:SetPoint("TOPRIGHT", f, -1, -1)
		f.bar:SetPoint("BOTTOMRIGHT", f, -1, 0)
		f.bar:SetPoint("LEFT", ic, "RIGHT", 5, 0)
		
		f.timeText:SetJustifyH("RIGHT")
		f.timeText:ClearAllPoints()
		f.timeText:SetPoint("RIGHT", 1, 0)

		f.spellText:SetJustifyH("LEFT")
		f.spellText:ClearAllPoints()
		f.spellText:SetPoint("LEFT", 2, 0)
		f.spellText:SetWidth(f.bar:GetWidth() - 10)
	end
	
end

A:RegisterSkin("NugRunning", Skin)
