--[[   ____    ______      
      /\  _`\ /\__  _\   __
 __  _\ \ \/\_\/_/\ \/ /_\ \___ 
/\ \/'\\ \ \/_/_ \ \ \/\___  __\
\/>  </ \ \ \L\ \ \ \ \/__/\_\_/
 /\_/\_\ \ \____/  \ \_\  \/_/
 \//\/_/  \/___/    \/_/
 
 [=====================================]
 [  Author: Dandraffbal-Stormreaver US ]
 [  xCT+ Version 4.x.x                 ]
 [  ©2015. All Rights Reserved.        ]
 [====================================]]

local build = select(4, GetBuildInfo())

-- this file handles updating the frame settings and anything that changes the UI frames themselves
local ADDON_NAME, addon = ...

local LSM = LibStub("LibSharedMedia-3.0");

-- Setup up values
local ssub, sformat, sgsub, pairs, tonumber, tostring, math, unpack, print, type, mfloor, random, table_insert, format, _G, select
	= string.sub, string.format, string.gsub, pairs, tonumber, tostring, math, unpack, print, type, math.floor, math.random, table.insert, string.format, _G, select

-- Start the Random Machine!	
random(time()); random(); random(time())

-- Shorten my handle
local x = addon.engine

-- Store my frames
x.frames = { }

-- Static frame lookup
local frameIndex = {
	[1] = "general",
	[2] = "outgoing",
	[3] = "critical",
	[4] = "damage",
	[5] = "healing",
	[6] = "power",
	[7] = "procs",
	[8] = "loot",
	--[9] = "class",	-- this is not used by redirection
}

-- Static Title Lookup
local frameTitles = {
	["general"]		= "General",					-- COMBAT_TEXT_LABEL,
	["outgoing"]	= "Outgoing",					-- SCORE_DAMAGE_DONE.." / "..SCORE_HEALING_DONE,
	["critical"]	= "Outgoing (Criticals)",		-- TEXT_MODE_A_STRING_RESULT_CRITICAL:gsub("%(", ""):gsub("%)", ""), -- "(Critical)" --> "Critical"
	["damage"]		= "Damage (Incoming)",			-- DAMAGE,
	["healing"]		= "Healing (Incoming)",			-- SHOW_COMBAT_HEALING,
	["power"]		= "Class Power",				-- COMBAT_TEXT_SHOW_ENERGIZE_TEXT,
	["class"]		= "Combo",						-- COMBAT_TEXT_SHOW_COMBO_POINTS_TEXT,
	["procs"]		= "Special Effects (Procs)",	-- COMBAT_TEXT_SHOW_REACTIVES_TEXT,
	["loot"]		= "Loot & Money",				-- LOOT,
}

local function autoClearFrame_OnUpdate(self, elasped)
	if not self.last then self.last = 0 end
	self.last = self.last + elasped
	
	if self.last > 4 then
		x:Clear(self.name)
		self:SetScript("OnUpdate", nil)
		self.f.timer = nil
	end
end

-- Function to allow users to scroll a frame with mouseover
local function Frame_OnMouseWheel(self, delta)
	if delta > 0 then
		self:ScrollUp()
	elseif delta < 0 then
		self:ScrollDown()
	end
end

local function Frame_SendTestMessage_OnUpdate(self, e)
	if self.frameName == "class" then
		x:AddMessage(self.frameName, "0", self.settings.fontColor or {1,1,0})
		
		if not self.timer then
			self.timer = CreateFrame("FRAME")
			self.timer.name = self.frameName
			self.timer.f = self
			self.timer:SetScript("OnUpdate", autoClearFrame_OnUpdate)
		else
			self.timer.last = 0
		end
	else
		x:AddMessage(self.frameName, self.frameName.." test message", self.settings.fontColor or {1,1,1})
	end
	
	if x.testing then
		self.lastUpdate = 0
		self:SetScript("OnUpdate", x.TestMoreUpdate)
	else
		self:SetScript("OnUpdate", nil)
	end
end

-- =====================================================
-- AddOn:UpdateFrames(
--		specificFrame,	[string] - (Optional) the framename
--	)
--		If you specify a specificFrame then only that
--	frame will be updated, otherwise all the frames will
--	be updated.
-- =====================================================
function x:UpdateFrames(specificFrame)

	-- Update Head Numbers and FCT Font Settings
	if build < 70000 then
		if not specificFrame then x:UpdateBlizzardFCT() end
	end
	
	-- Update the frames
	for framename, settings in pairs(x.db.profile.frames) do
		if specificFrame and specificFrame == framename or not specificFrame then
			local f = nil

			-- Create the frame (or retrieve it)
			if x.frames[framename] then
				f = x.frames[framename]
			else
				f = CreateFrame("ScrollingMessageFrame", "xCT_Plus"..framename.."Frame", UIParent)
				f:SetSpacing(2)
				f:ClearAllPoints()
				f:SetMovable(true)
				f:SetResizable(true)
				f:SetMinResize(64, 32)
				f:SetMaxResize(768, 768)
				f:SetClampedToScreen(true)
				f:SetShadowColor(0, 0, 0, 0)
				
				f.sizing = CreateFrame("Frame", "xCT_Plus"..framename.."SizingFrame", f)
				f.sizing.parent = f
				f.sizing:SetHeight(16)
				f.sizing:SetWidth(16)
				f.sizing:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -1, 1)
				f.sizing:Hide()
				
				f.moving = CreateFrame("Frame", "xCT_Plus"..framename.."MovingFrame", f)
				f.moving.parent = f
				f.moving:SetPoint("TOPLEFT", f, "TOPLEFT", 1, -1)
				f.moving:SetPoint("TOPRIGHT", f, "TOPRIGHT", -1, -21)
				f.moving:SetHeight(20)
				f.moving:Hide()

				x.frames[framename] = f
			end
			
			f.frameName = framename
			f.settings = settings

			-- Frame Strata
			if x.configuring then
				f:SetFrameStrata("FULLSCREEN_DIALOG")
			else
				f:SetFrameStrata(ssub(x.db.profile.frameSettings.frameStrata, 2))
			end
			
			-- Set the position
			f:SetWidth(settings.Width)
			f:SetHeight(settings.Height)
			
			f:SetPoint("CENTER", settings.X, settings.Y)
			f:SetClampRectInsets(0, 0, settings.fontSize, 0)

			-- Frame Alpha
			f:SetAlpha(settings.alpha / 100)
			
			-- Insert Direction
			if settings.insertText then
				f:SetInsertMode(settings.insertText)
			end
			
			-- Font Template
			f:SetFont(LSM:Fetch("font", settings.font), settings.fontSize, ssub(settings.fontOutline, 2))
			
			if settings.fontJustify then
				f:SetJustifyH(settings.fontJustify)
			end
			
			-- Special Cases
			if framename == "class" then
				f:SetMaxLines(1)
				f:SetFading(false)
			else
				-- scrolling
				if settings.enableScrollable then
					f:SetMaxLines(settings.scrollableLines)
					if not settings.scrollableInCombat then
						if InCombatLockdown() then
							x:DisableFrameScrolling( framename )
						else
							x:EnableFrameScrolling( framename )
						end
					else
						x:EnableFrameScrolling( framename )
					end
				else
					f:SetMaxLines(settings.Height / settings.fontSize)
					x:DisableFrameScrolling( framename )
				end
			end

			-- fading
			if settings.enableCustomFade then
				f:SetFading(settings.enableFade)
				f:SetFadeDuration(settings.fadeTime)
				f:SetTimeVisible(settings.visibilityTime)
			else
				f:SetFading(true)
				f:SetTimeVisible(3)
			end

			-- Send a Test message
			if specificFrame then
				f:SetScript("OnUpdate", Frame_SendTestMessage_OnUpdate)
			end

		end
	end
end

function x:EnableFrameScrolling( framename )
  local f = x.frames[framename]
  local settings = x.db.profile.frames[framename]
  f:EnableMouseWheel(true)
  f:SetScript("OnMouseWheel", Frame_OnMouseWheel)
end

function x:DisableFrameScrolling( framename )
  local f = x.frames[framename]
  local settings = x.db.profile.frames[framename]
  f:EnableMouseWheel(false)
  f:SetScript("OnMouseWheel", nil)
end

-- =====================================================
-- AddOn:Clear(
--		specificFrame,	[string] - (Optional) the framename
--	)
--		If you specify a specificFrame then only that
--	frame will be cleared of its text, otherwise all
--	the frames will be cleared.
-- =====================================================
function x:Clear(specificFrame)
	if not specificFrame then
		for framename, settings in pairs(x.db.profile.frames) do
			local frame = x.frames[framename]
			frame:Clear()
		end
	else
		local frame = x.frames[specificFrame]
		frame:Clear()
	end
end

-- =====================================================
-- AddOn:Abbreviate(
--		amount,				 [int] - the amount to abbreviate
--		frameName*,	[string] - the name of the frame
--			whose settings we need to check.
--	)
--
--		* = Optional
--
--		Abbreviates the specified amount.	Will also
--	check the current settings profile if a name
--	frame is specified.
-- =====================================================
function x:Abbreviate(amount, frameName)
	local message = tostring(amount)
	if frameName and self.db.profile.frames[frameName] and self.db.profile.frames[frameName].megaDamage then
		if self.db.profile.spells.formatAbbreviate then
			if (amount >= 1000000) then
				if self.db.profile.megaDamage.decimalPoint then
					message = tostring(mfloor((amount + 50000) / 100000) / 10) .. self.db.profile.megaDamage.millionSymbol
				else
					message = tostring(mfloor((amount + 500000) / 1000000)) .. self.db.profile.megaDamage.millionSymbol
				end
			elseif (amount >= 1000) then
				if self.db.profile.megaDamage.decimalPoint then
					message = tostring(mfloor((amount + 50) / 100) / 10) .. self.db.profile.megaDamage.thousandSymbol
				else
					message = tostring(mfloor((amount + 500) / 1000)) .. self.db.profile.megaDamage.thousandSymbol
				end
			end
		else
			local k
			while true do
				message, k = sgsub(message, '^(-?%d+)(%d%d%d)', '%1,%2')
				if (k==0) then break end
			end
		end
	end
	return message
end

-- =====================================================
-- AddOn:AddMessage(
--		framename,	[string] - the framename
--		message,	[string] - the pre-formatted message to be sent
--		colorname,	[string or table] - the name of the color OR a
--										table containing the color
--										e.g. colorname={1,2,3} --r=1,b=2,g=3
--	)
--		Sends a message to the framename specified.
-- =====================================================
function x:AddMessage(framename, message, colorname)
	local frame = x.frames[framename]
	local frameOptions = x.db.profile.frames[framename]
	
	-- Make sure we have a valid frame
	if not frameOptions then print("xct+ frame name not found:", framename) return end
	
	local secondFrameName = frameIndex[frameOptions.secondaryFrame]
	local secondFrame = x.frames[secondFrameName]
	local secondFrameOptions = x.db.profile.frames[secondFrameName]
	
	if frame then
		-- Load the color
		local r, g, b = 1, 1, 1
		if type(colorname) == "table" then
			r, g, b = unpack(colorname)
		else
			if not x.colors[colorname] then
				if x.LookupColorByName(colorname) then
					r, g, b = unpack( x.LookupColorByName(colorname) )
				else
					print("FRAME:", framename,"  xct+ says there is no color named:", colorname)
				end
			else
				r, g, b = unpack(x.colors[colorname])
			end
		end
		
		-- make sure the frame is enabled
		if frameOptions.enabledFrame then
			-- check for forced color
			if frameOptions.customColor then
				r, g, b = unpack(frameOptions.fontColor or {1, 1, 1})
			end
			frame:AddMessage(message, r, g, b)
		elseif secondFrame and secondFrameOptions.enabledFrame then 
			if secondFrameOptions.customColor then			-- check for forced color
				r, g, b = unpack(secondFrameOptions.fontColor or {1, 1, 1})
			end
			secondFrame:AddMessage(message, r, g, b)
		end
	end
end

local spamHeap, spamStack = {}, {}
local spam_format = "%s%s x%s"

-- =====================================================
-- AddOn:AddSpamMessage(
--		framename,		[string]              - the framename
--		mergeID,		[number or string]      - idenitity items to merge, if number
--												then it HAS TO BE the valid spell ID
--		message,		[number or string]      - the pre-formatted message to be sent,
--												if its not a number, then only the
--												first 'message' value that is sent
--												this mergeID will be used.
--		colorname,		[string or table]     - the name of the color OR a table
--												containing the color (e.g.
--												colorname={1,2,3} -- r=1, b=2, g=3)
--	)
--		Sends a message to the framename specified.
-- =====================================================
function x:AddSpamMessage(framename, mergeID, message, colorname, interval)
	
	-- Check for a Secondary Spell ID
	local secondarySpellID = addon.merge2h[mergeID]
	if secondarySpellID then
		mergeID = secondarySpellID
	end

	local heap, stack = spamHeap[framename], spamStack[framename]
	if heap[mergeID] then
		heap[mergeID].color = colorname
		table_insert(heap[mergeID].entries, message)
	else
		heap[mergeID] = {
			-- last update
			last = 0,

			-- how often to update
			update = interval or (x.db.profile.spells.merge[mergeID] and x.db.profile.spells.merge[mergeID].interval or 3),
			
			-- entries to merge
			entries = {
					message,
				},

			-- color
			color = colorname,
		}
		table_insert(stack, mergeID)
	end
end

--[================================================================[
             _____ _______                           ____  
            / ____|__   __|                         |___ \ 
      __  _| |       | |_| |_      __   _____ _ __    __) |
      \ \/ / |       | |_   _|     \ \ / / _ \ '__|  |__ < 
       >  <| |____   | | |_|        \ V /  __/ |_    ___) |
      /_/\_\\_____|  |_|             \_/ \___|_(_)  |____/ 

   ___ _ __   __ _ _ __ ___    _ __ ___   ___ _ __ __ _  ___ _ __ 
  / __| '_ \ / _` | '_ ` _ \  | '_ ` _ \ / _ \ '__/ _` |/ _ \ '__|
  \__ \ |_) | (_| | | | | | | | | | | | |  __/ | | (_| |  __/ |   
  |___/ .__/ \__,_|_| |_| |_| |_| |_| |_|\___|_|  \__, |\___|_|   
      | |                                          __/ |          
      |_|                                         |___/           

	This is the new spam merger.	Here is how it works:
	
	-- On Each Update
		+ Go to the current frame (one frame at a time)
		
			- Go to the current spell entry for this frame
				+ if spell entry says its time to update, then update
				+ else do nothing
				
			- Get the next spell entry ready for the next time it hits this frame
			
		+ Get the next frame ready for the next update
		
		+ Wait for next Update
	
			As you can see, I only update one frame per OnUpdate AND only
		one merge entry gets updated for every frame.	Which means, I will
		do a maximum of one thing per OnUpdate (and a minimum of nothing).
		I am hoping that the spell merger will be mostly invisible.
		
		
	 -- TODO:	The only thing that I need to figure out is: is the spell
		merger updating fast enough, or will it feel slugish when there are
		a lot of items to merge.
		
			My best guess is that it does not matter :)

  ]================================================================]

do
	for _, frameName in pairs(frameIndex) do
		spamHeap[frameName] = {}
		spamStack[frameName] = {}
	end

	local index = 1
	local frames = {}
	local now = 0
	
	function x.OnSpamUpdate(self, elapsed)
		if not x.db then return end
	
		-- Update 'now'
		now = now + elapsed
		
		-- Check to see if we are out of bounds
		if index > #frameIndex then index = 1 end
		if not frames[frameIndex[index]] then
			frames[frameIndex[index]] = 1
		end
		
		local heap, stack, settings, idIndex =
			spamHeap[frameIndex[index]],			-- the heap contains merge entries
			spamStack[frameIndex[index]],			-- the stack contains lookup values
			x.db.profile.frames[frameIndex[index]],	-- this frame's settings
			frames[frameIndex[index]]				-- this frame's last entry index
		
		-- If the frame is not enabled, then dont even worry about it
		if not settings.enabledFrame and settings.secondaryFrame == 0 then
			index = index + 1	-- heh, still need to iterate to the next frame :P
			return
		end
		
		-- Check to see if we are out of bounds
		if idIndex > #stack then
			idIndex = 1
		end
		
		-- This item contains a lot of information about what we need to merge
		local item = heap[stack[idIndex]]
		
		--if item then print(item.last, "+", item.update, "<", now) end
		if item and item.last + item.update <= now and #item.entries > 0 then
			item.last = now
			
			-- Add up all the entries
			local total = 0
			for _, amount in pairs(item.entries) do
				if not tonumber(amount) then total = amount; break end
				total = total + amount	-- Add all the amounts
			end
			
			-- total as a string
			local message = tostring(total)
			
			-- Abbreviate the merged total
			if tonumber(total) then
				message = x:Abbreviate(tonumber(total), frameIndex[index])
			end
			
			--local format_mergeCount = "%s |cffFFFFFFx%s|r"
			local strColor = "ffffff"

			-- Add critical Prefix and Postfix
			if frameIndex[index] == "critical" then
				message = format("%s%s%s", x.db.profile.frames["critical"].critPrefix, message, x.db.profile.frames["critical"].critPostfix)
				
			-- Show healer name (colored)
			elseif frameIndex[index] == "healing" then
				--format_mergeCount = "%s |cffFFFF00x%s|r"
				local strColor = "ffff00"
				if x.db.profile.frames["healing"].showFriendlyHealers then
					local healerName = stack[idIndex]
					if x.db.profile.frames["healing"].enableClassNames then
						local _, class = UnitClass(healerName)
						if (class) then
							healerName = sformat("|c%s%s|r", RAID_CLASS_COLORS[class].colorStr, healerName)
						end
					end
					if x.db.profile.frames["healing"].fontJustify == "LEFT" then
						message = sformat("+%s %s", message, healerName)
					else
						message = sformat("%s +%s", healerName, message)
					end
				else
					message = sformat("+%s", message)
				end
			end
			
			-- Add merge count
			--if #item.entries > 1 then
			--	message = sformat(format_mergeCount, message, #item.entries)
			--end
			--stack[idIndex], settings.iconsSize, settings.fontJustify

			-- Add Icons
			if frameIndex[index] ~= "healing" and frameIndex[index] ~= "general" then
				message = x:GetSpellTextureFormatted( stack[idIndex],
				                                  message,
				                                  settings.iconsEnabled and settings.iconsSize or -1,
				                                  settings.fontJustify,
				                                  strColor,
				                                  true, -- Merge Override = true
				                                  #item.entries )
			else
				if #item.entries > 1 then
					message = sformat("%s |cff%sx%s|r", message, strColor, #item.entries)
				end
			end
		
			x:AddMessage(frameIndex[index], message, item.color)
			
			-- Clear all the old entries, we dont need them anymore
			for k in pairs(item.entries) do
				item.entries[k] = nil
			end
		end
		
		frames[frameIndex[index]] = idIndex + 1
		index = index + 1
	end
	
	x.merge = CreateFrame("FRAME")
	x.merge:SetScript("OnUpdate", x.OnSpamUpdate)
end

local function Frame_Sizing_OnUpdate(self, e)
	self.parent.width:SetText(mfloor(self.parent:GetWidth()+.5))
	self.parent.height:SetText(mfloor(self.parent:GetHeight()+.5))
end

local function Frame_Moving_OnUpdate(self, e)
	-- Calculate get the center of the screen from the left/top
	local posX = mfloor(mfloor(self.parent:GetLeft()-GetScreenWidth()/2+.5))
	local posY = mfloor(mfloor(self.parent:GetTop()-GetScreenHeight()/2+.5))
	
	-- Set the position of the frame
	self.parent.position:SetText(sformat("%d, %d", posX, posY))
end

local function Frame_Sizing_OnMouseDown(self, button)
	if button == "LeftButton" then
		self.parent:StartSizing()
		self:SetScript("OnUpdate", Frame_Sizing_OnUpdate)
		self.isMoving = true
	end
end

local function Frame_Sizing_OnMouseUp(self, button)
	if button == "LeftButton" and self.isMoving then
		self.parent:StopMovingOrSizing()
		self:SetScript("OnUpdate", nil)
		self.isMoving = false
	end
end

local function Frame_Moving_OnMouseDown(self, button)
	if button == "LeftButton" then
		self.parent:StartMoving()
		self:SetScript("OnUpdate", Frame_Moving_OnUpdate)
		self.isMoving = true
	end
end

local function Frame_Moving_OnMouseUp(self, button)
	if button == "LeftButton" and self.isMoving then
		self.parent:StopMovingOrSizing()
		self:SetScript("OnUpdate", nil)
		self.isMoving = false
	end
end

local function Frame_MouseEnter(self)
	if x.db.profile.frameSettings.showPositions then
		if self.width then
			self.width:Show()
			self.height:Show()
			self.position:Show()
		else
			self.parent.width:Show()
			self.parent.height:Show()
			self.parent.position:Show()
		end
	end
end

local function Frame_MouseLeave(self)
	if self.width then
		self.width:Hide()
		self.height:Hide()
		self.position:Hide()
	else
		self.parent.width:Hide()
		self.parent.height:Hide()
		self.parent.position:Hide()
	end
end

-- Starts the "config mode" so that you can move the frames
function x.StartConfigMode()
	x.configuring = true

	for framename, settings in pairs(x.db.profile.frames) do
		if settings.enabledFrame then
			local f = x.frames[framename]
			f:SetBackdrop( {
					bgFile	 	= "Interface/Tooltips/UI-Tooltip-Background",
					edgeFile 	= "Interface/Tooltips/UI-Tooltip-Border",
					tile		= false,
					tileSize 	= 0,
					edgeSize 	= 2,
					insets 		= { left = 0, right = 0, top = 0, bottom = 0 }
				} )
			
			f:SetBackdropColor(.1, .1, .1, .8)
			f:SetBackdropBorderColor(.1, .1, .1, .5)
		
			-- Show the sizing and moving frames
			f.sizing:Show()
			f.moving:Show()
		
			-- Frame Title
			f.title = f:CreateFontString(nil, "OVERLAY")
			f.title:SetPoint("BOTTOM", f, "TOP", 0, -16)
			f.title:SetFont(LSM:Fetch("font", "Homespun (xCT+)"), 16, "MONOCHROMEOUTLINE")
			f.title:SetText(frameTitles[framename])
			
			-- Size Text
			f.width = f:CreateFontString(nil, "OVERLAY")
			f.width:SetTextColor(.47, .55, .87, 1)
			f.width:SetPoint("TOP", f, "BOTTOM", 0, 0)
			f.width:SetFont(LSM:Fetch("font", "Homespun (xCT+)"), 25, "MONOCHROMEOUTLINE")
			f.width:SetText(mfloor(f:GetWidth()+.5))
			f.width:Hide()
			
			f.height = f:CreateFontString(nil, "OVERLAY")
			f.height:SetTextColor(.47, .55, .87, 1)
			f.height:SetPoint("LEFT", f, "RIGHT", 3, 0)
			f.height:SetFont(LSM:Fetch("font", "Homespun (xCT+)"), 25, "MONOCHROMEOUTLINE")
			f.height:SetText(mfloor(f:GetHeight()+.5))
			f.height:Hide()

			-- Calculate get the center of the screen from the left/top
			local posX = mfloor(mfloor(f:GetLeft()-GetScreenWidth()/2+.5))
			local posY = mfloor(mfloor(f:GetTop()-GetScreenHeight()/2+.5))			
			
			-- Position Text
			f.position = f:CreateFontString(nil, "OVERLAY")
			f.position:SetTextColor(1, 1, 0, 1)
			f.position:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 4)
			f.position:SetFont(LSM:Fetch("font", "Homespun (xCT+)"), 25, "MONOCHROMEOUTLINE")
			f.position:SetText(sformat("%d, %d", posX, posY))
			f.position:Hide()
			
			f.moving.d = f:CreateTexture(nil, "OVERLAY")
			f.moving.d:SetPoint("TOPLEFT", f, "TOPLEFT", 1, -1)
			f.moving.d:SetPoint("TOPRIGHT", f, "TOPRIGHT", -1, -19)
			f.moving.d:SetHeight(20)
			f.moving.d:SetVertexColor(.3, .3, .3)
			f.moving.d:SetTexture("Interface\\BUTTONS\\WHITE8X8.blp")
			f.moving.d:SetAlpha(.6)
		
			f.sizing.d = f.sizing:CreateTexture("ARTWORK")
			f.sizing.d:SetHeight(16)
			f.sizing.d:SetWidth(16)
			f.sizing.d:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -1, 1)
			f.sizing.d:SetVertexColor(.3, .3, .3)
			f.sizing.d:SetTexture("Interface\\BUTTONS\\WHITE8X8.blp")
			f.sizing.d:SetAlpha(.6)
			
			-- Frame Settings
			f:SetScript("OnEnter", Frame_MouseEnter)
			f:SetScript("OnLeave", Frame_MouseLeave)
			
			-- Moving Settings
			f.moving:EnableMouse(true)
			f.moving:RegisterForDrag("LeftButton")
			f.moving:SetScript("OnMouseDown", Frame_Moving_OnMouseDown)
			f.moving:SetScript("OnMouseUp", Frame_Moving_OnMouseUp)
			f.moving:SetScript("OnEnter", Frame_MouseEnter)
			f.moving:SetScript("OnLeave", Frame_MouseLeave)
			
			-- Resizing Settings
			f.sizing:EnableMouse(true)
			f.sizing:RegisterForDrag("LeftButton")
			f.sizing:SetScript("OnMouseDown", Frame_Sizing_OnMouseDown)
			f.sizing:SetScript("OnMouseUp", Frame_Sizing_OnMouseUp)
			f.sizing:SetScript("OnEnter", Frame_MouseEnter)
			f.sizing:SetScript("OnLeave", Frame_MouseLeave)
			
			-- TODO: Add option to adjust the number of lines for memory purposes
			-- TODO: Show Alignment Grid
			
			if framename == "class" then
				f.sizing.d:Hide()
				f.sizing:Hide()
			end
			
			f:SetFrameStrata("FULLSCREEN_DIALOG")
			
		end
	end
end

function x.EndConfigMode()
	x.configuring = false
	if x.AlignGrid then x.AlignGrid:Hide() end
	
	for framename, settings in pairs(x.db.profile.frames) do
		local f = x.frames[framename]
		
		f:SetBackdrop(nil)
		
		-- Remove Scripts
		f:SetScript("OnEnter", nil)
		f:SetScript("OnLeave", nil)
		
		f.moving:SetScript("OnMouseDown", nil)
		f.moving:SetScript("OnMouseUp", nil)
		f.moving:SetScript("OnEnter", nil)
		f.moving:SetScript("OnLeave", nil)
		
		f.sizing:SetScript("OnMouseDown", nil)
		f.sizing:SetScript("OnMouseUp", nil)
		f.sizing:SetScript("OnEnter", nil)
		f.sizing:SetScript("OnLeave", nil)
		
		-- Clean up visual items
		if f.title then
			f.title:Hide()
			f.title = nil
		end
		
		if f.moving.d then
			f.moving.d:Hide()
			f.moving.d = nil
		end
		
		if f.sizing.d then
			f.sizing.d:Hide()
			f.sizing.d = nil
		end
		
		if f.position then
			f.position:Hide()
			f.position = nil
		end
		
		if f.width then
			f.width:Hide()
			f.width = nil
		end
		
		if f.height then
			f.height:Hide()
			f.height = nil
		end
		
		f:EnableMouse(false)
		
		-- Hide the sizing frame
		f.sizing:EnableMouse(false)
		f.sizing:Hide()
		
		-- Hide the moving frame
		f.moving:EnableMouse(false)
		f.moving:Hide()
		
		-- Set the Frame Strata
		f:SetFrameStrata(ssub(x.db.profile.frameSettings.frameStrata, 2))
	end
	
	collectgarbage()
end

function x.ToggleConfigMode()
	if x.configuring then
		return
	else
		-- Close the Options Dialog if it is Open
		-- Because this could be called fromt he UI, we need to wait
		x:HideConfigTool(true)

		-- Thanks Elv :)
		GameTooltip:Hide() -- Just in case you're mouseovered something and it closes.
		
		StaticPopup_Show("XCT_PLUS_CONFIGURING")
		
		if x.db.profile.frameSettings.showGrid then
			if not x.AlignGrid then
				x:LoadAlignmentGrid()
			end
			x.AlignGrid:Show()
		end

		x.StartConfigMode()
	end
end

function x:SaveAllFrames()
	for framename, settings in pairs(x.db.profile.frames) do
		local frame = x.frames[framename]
	
		local width = frame:GetWidth()
		local height = frame:GetHeight()
		
		settings.Width = mfloor(width + .5)
		settings.Height = mfloor(height + .5)
		
		-- Calculate the center of the screen
		local ResX, ResY = GetScreenWidth(), GetScreenHeight()
		local midX, midY = ResX / 2, ResY / 2
		
		-- Calculate the Top/Left of a frame relative to the center
		local left, top = mfloor(frame:GetLeft() - midX + .5), mfloor(frame:GetTop() - midY + .5)
		
		-- Calculate get the center of the screen from the left/top
		settings.X = mfloor(left + (width / 2) + .5)
		settings.Y = mfloor(top - (height / 2) + .5)
	end
end

local damageColorLookup = { [1] = 1, [2] = 2, [3] = 4, [4] = 8, [5] = 16, [6] = 32, [7] = 64, }

-- Gets a random spell icon that is NOT an engineering cog wheel
local function GetRandomSpellID()
	local icon, spellID
	repeat
		spellID = random(100, 80000)
		icon = select(3, GetSpellInfo(spellID))
	until icon and icon ~= "Interface\\Icons\\Trade_Engineering"
	return spellID
end

function x.TestMoreUpdate(self, elapsed)
	if InCombatLockdown() then
		self:SetScript("OnUpdate", nil)
	else
		self.lastUpdate = self.lastUpdate + elapsed
	
		if not self.nextUpdate then
			self.nextUpdate = random(80, 600) / 1000
		end
		
		if self.nextUpdate < self.lastUpdate then
			self.nextUpdate = nil
			self.lastUpdate = 0
			
			if self == x.frames["general"] and random(3) % 3 == 0 then
				local output = "general"
				if not x.db.profile.frames[output].enabledFrame then
					x:Clear(output)
					if x.db.profile.frames[output].secondaryFrame ~= 0 then output = frameIndex[x.db.profile.frames[output].secondaryFrame] else return end
				end
				x:AddMessage(output, COMBAT_TEXT_LABEL, {random(255) / 255, random(255) / 255, random(255) / 255})
			elseif self == x.frames["outgoing"] then
				local output = "outgoing"
				if not x.db.profile.frames[output].enabledFrame then
					x:Clear(output)
					if x.db.profile.frames[output].secondaryFrame ~= 0 then output = frameIndex[x.db.profile.frames[output].secondaryFrame] else return end
				end
				local message = x:Abbreviate(random(60000), "outgoing")
				local merged, multistriked = false, 0
				if random(5) % 5 == 0 and (x.db.profile.spells.mergeDontMergeCriticals or x.db.profile.spells.mergeCriticalsWithOutgoing or x.db.profile.spells.mergeCriticalsByThemselves) then
					multistriked = random(17)+1
					merged = true
				end
				message = x:GetSpellTextureFormatted( x.db.profile.frames["outgoing"].iconsEnabled and GetRandomSpellID() or -1, message, x.db.profile.frames["outgoing"].iconsSize, x.db.profile.frames["outgoing"].fontJustify, nil, merged, multistriked )
				x:AddMessage(output, message, x.damagecolor[damageColorLookup[math.random(7)]])
			elseif self == x.frames["critical"] and random(2) % 2 == 0 then
				local output = "critical"
				if not x.db.profile.frames[output].enabledFrame then
					x:Clear(output)
					if x.db.profile.frames[output].secondaryFrame ~= 0 then output = frameIndex[x.db.profile.frames[output].secondaryFrame] else return end
				end
				local message = x.db.profile.frames.critical.critPrefix .. x:Abbreviate(random(60000), "critical") .. x.db.profile.frames.critical.critPostfix
				local merged, multistriked = false, 0
				if (random(5) % 5 == 0) and (x.db.profile.spells.mergeCriticalsWithOutgoing or x.db.profile.spells.mergeCriticalsByThemselves) then
					multistriked = random(17)+1
					merged = true
				end
				message = x:GetSpellTextureFormatted( x.db.profile.frames["critical"].iconsEnabled and GetRandomSpellID() or -1, message, x.db.profile.frames["critical"].iconsSize, x.db.profile.frames["critical"].fontJustify, nil, merged, multistriked )
				x:AddMessage(output, message, x.damagecolor[damageColorLookup[math.random(7)]])
			elseif self == x.frames["damage"] and random(2) % 2 == 0 then
				local output = "damage"
				if not x.db.profile.frames[output].enabledFrame then
					x:Clear(output)
					if x.db.profile.frames[output].secondaryFrame ~= 0 then output = frameIndex[x.db.profile.frames[output].secondaryFrame] else return end
				end
				x:AddMessage(output, "-"..x:Abbreviate(random(100000), "damage"), {1, random(100) / 255, random(100) / 255})
			elseif self == x.frames["healing"] and random(2) % 2 == 0 then
				local output = "healing"
				if not x.db.profile.frames[output].enabledFrame then
					x:Clear(output)
					if x.db.profile.frames[output].secondaryFrame ~= 0 then output = frameIndex[x.db.profile.frames[output].secondaryFrame] else return end
				end
				if COMBAT_TEXT_SHOW_FRIENDLY_NAMES == "1" then
					local message = UnitName("player")
					local realm = ""
					if x.db.profile.frames["healing"].enableRealmNames then realm = "-"..GetRealmName() end
					if x.db.profile.frames["healing"].enableClassNames then
						message = sformat("|c%s%s%s|r", RAID_CLASS_COLORS[select(2,UnitClass("player"))].colorStr, message, realm)
					end
					if x.db.profile.spells.mergeHealing and random(2) % 2 == 0 then
						message = sformat("%s |cffFFFF00x%s|r", message, random(17)+1)
					end
					x:AddMessage(output, "+"..x:Abbreviate(random(90000),"healing") .. " "..message, {.1, ((random(3) + 1) * 63) / 255, .1})
				else
					x:AddMessage(output, "+"..x:Abbreviate(random(90000),"healing"), {.1, ((random(3) + 1) * 63) / 255, .1})
				end
			elseif self == x.frames["power"] and random(4) % 4 == 0 then
				local output = "power"
				if not x.db.profile.frames[output].enabledFrame then
					x:Clear(output)
					if x.db.profile.frames[output].secondaryFrame ~= 0 then output = frameIndex[x.db.profile.frames[output].secondaryFrame] else return end
				end
				local _, powerToken = UnitPowerType("player")
				x:AddMessage(output, "+"..x:Abbreviate(random(5000),"power").." ".._G[powerToken], { PowerBarColor[powerToken].r, PowerBarColor[powerToken].g, PowerBarColor[powerToken].b })
			elseif self == x.frames["class"] and random(4) % 4 == 0 then
				if not x.db.profile.frames["class"].enabledFrame then x:Clear("class") return end
				if not self.testCombo then
					self.testCombo = 0
				end
				self.testCombo = self.testCombo + 1
				if self.testCombo > 8 then
					self.testCombo = 1
				end
				x:AddMessage("class", tostring(self.testCombo), {1, .82, 0})
			elseif self == x.frames["procs"] and random(8) % 8 == 0 then
				local output = "procs"
				if not x.db.profile.frames[output].enabledFrame then
					x:Clear(output)
					if x.db.profile.frames[output].secondaryFrame ~= 0 then output = frameIndex[x.db.profile.frames[output].secondaryFrame] else return end
				end
				x:AddMessage(output, ERR_SPELL_COOLDOWN, {1, 1, 0})
			elseif self == x.frames["loot"] and random(8) % 8 == 0 then
				local output = "loot"
				if not x.db.profile.frames[output].enabledFrame then
					x:Clear(output)
					if x.db.profile.frames[output].secondaryFrame ~= 0 then output = frameIndex[x.db.profile.frames[output].secondaryFrame] else return end
				end
				if x.db.profile.frames[output].colorBlindMoney then
					local g, s, c, message = random(100) % 10 ~= 0 and random(100) or nil, random(100) % 10 ~= 0 and random(100) or nil, random(100) % 10 ~= 0 and random(100) or nil, ""
					if g then message = tostring(g).."|cffFFD700g|r" end
					if s then if g then message = message .. " " .. tostring(s).."|cffC0C0C0s|r" else message = message .. tostring(s).."|cffC0C0C0s|r" end end
					if c then if s or g then message = message .. " " .. tostring(c).."|cffB87333c|r" else message = message .. tostring(c).."|cffB87333c|r" end end
					if not g and not s and not c then return end
					x:AddMessage(output, MONEY .. ": " .. message, {1, 1, 0})
				else
					x:AddMessage(output, MONEY .. ": " .. GetCoinTextureString(random(1000000)), {1, 1, 0})
				end
			end
		end
	end
end

function x.ToggleTestMode(hidePopup)
	if x.configuring then
		return
	else
		if x.testing then
			x.EndTestMode()
		else
			x.testing = true
			
			-- Start the Test more
			for framename, settings in pairs(x.db.profile.frames) do
				local frame = x.frames[framename]
				frame.nextUpdate = nil
				frame.lastUpdate = 0
				frame:SetScript("OnUpdate", x.TestMoreUpdate)
			end
			
			-- Test more Popup
			-- Because this could be called fromt he UI, we need to wait
			x:HideConfigTool(true)

			if type(hidePopup) == "boolean" and hidePopup then
				return
			else
				StaticPopup_Show("XCT_PLUS_TESTMODE")
			end
		end
	end
end

function x.EndTestMode()
	x.testing = false

	-- Stop the Test more
	for framename, settings in pairs(x.db.profile.frames) do
		local frame = x.frames[framename]
		frame:SetScript("OnUpdate", nil)
		frame:Clear()
	end

	StaticPopup_Hide("XCT_PLUS_TESTMODE")
end

function x.RestoreAllDefaults()
	LibStub("AceConfigDialog-3.0"):Close(ADDON_NAME)
	GameTooltip:Hide()
	StaticPopup_Show("XCT_PLUS_RESET_SETTINGS")
end

-- Popups
StaticPopupDialogs["XCT_PLUS_CONFIGURING"] = {
	text			= "Configuring xCT+\nType: |cffFF0000/xct lock|r to save changes",
	timeout			= 0,
	whileDead		= 1,
	
	button1			= SAVE_CHANGES,
	button2			= CANCEL,
	OnAccept		= function() x:SaveAllFrames(); x.EndConfigMode(); x:ShowConfigTool() end,
	OnCancel		= function() x:UpdateFrames(); x.EndConfigMode(); x:ShowConfigTool() end,
	hideOnEscape	= false,
	
	-- Taint work around
	preferredIndex	= 3,
}

StaticPopupDialogs["XCT_PLUS_TESTMODE"] = {
	text			= "xCT+ Test Mode",
	timeout			= 0,
	whileDead		= 1,
	
	button1			= "Stop",
	OnAccept		= function() x.EndTestMode(); x:ShowConfigTool() end,
	hideOnEscape	= true,
	
	-- Taint work around
	preferredIndex	= 3,
}

StaticPopupDialogs["XCT_PLUS_RESET_SETTINGS"] = {
	text			= "Are your certain you want to erase |cffFF0000ALL|r your xCT+ settings?",
	timeout			= 0,
	whileDead		= 1,
	
	button1			= "|cffFF0000ERASE ALL!!|r",
	button2			= CANCEL,
	OnAccept		= function() xCTSavedDB = nil; ReloadUI() end,
	OnCancel		= function() x:ShowConfigTool() end,
	hideOnEscape	= true,
	
	-- Taint work around
	preferredIndex	= 3,
}

StaticPopupDialogs["XCT_PLUS_HIDE_IN_COMBAT"] = {
	text			= "|cffFFFF00Disable the|r |cff798BDDHide Config in Combat|r|cffFFFF00 feature?|r\n\n\n|cffFF0000WARNING:|r By disabling this protection you risk |cffFF8000tainting|r your UI. In some cases, you will need to type: '|cff798BDD/reload|r' in order to change |cff10FF40glyphs|r or |cff10FF40talents|r and to place |cff10FF40world markers|r.\n",
	timeout			= 0,
	whileDead		= 1,
	
	button1			= CONTINUE,
	button2			= REVERT,
	OnAccept		= x.noop,
	OnCancel		= function() x.db.profile.hideConfig = true; x:RefreshConfig() end,
	
	-- Taint work around
	preferredIndex	= 3,
}

StaticPopupDialogs["XCT_PLUS_DB_CLEANUP_1"] = {
	text			  = "|cff798BDDxCT+ Spring Cleaning|r\n\nHello, |cffFFFF00xCT|r|cffFF0000+|r needed to cleanup some |cffFF0000old or removed spell entries|r from the spam merger. |cffFFFF00Those settings needed to be reset|r. The rest of your profile settings |cff22FF44remains the same|r.\n\nSorry for this inconvenience.\n\n",
	timeout			= 0,
	whileDead		= 1,
	
	button1			= OKAY.."!",
  button2			= "Don't Show Again",
	hideOnEscape	= true,
	
  OnCancel		= function() x.db.global.dontShowDBCleaning = true end,
  
	-- Taint work around
	preferredIndex	= 3,
}

StaticPopupDialogs["XCT_PLUS_FORCE_CVAR_UPDATE"] = {
	text			= "|cff798BDDxCT+|r performed an action that requires it to update some |cffFFFF00Combat Text|r related |cffFF8000CVars|r. It is |cff20DD40highly recommened|r you reload your UI before changing any more settings.",
	timeout			= 0,
	whileDead		= 1,
	
	button1			= "Later",
	button2			= "Reload UI Now",
	OnAccept		= x.noop,
	OnCancel		= ReloadUI,
	
	-- Taint work around
	preferredIndex	= 3,
}

StaticPopupDialogs["XCT_PLUS_SUGGEST_MULTISTRIKE_OFF"] = {
	text            = ""

}
