﻿local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local UIFrameFadeOut = UIFrameFadeOut
local UIFrameFadeIn = UIFrameFadeIn
local InCombatLockdown = InCombatLockdown

local function OnUpdate(self)
	if self.parent:GetAlpha() == 0 then
		if InCombatLockdown() and self.lock then return end
		self:Hide()
		self.hiding = false
		self.parent:hide()
	end
end

local function to_hide(self)
	if self.hiding == true then return end
	if self:GetAlpha() == 0 then self:hide() return end
	UIFrameFadeOut(self,self.time,self.state_alpha,0)
	self.hiding = true
	self.pl_watch_frame:Show()
end

local function to_show(self)
	if self:IsShown() and not(self.hiding) then return end
	if self.showing then return end
	self.hiding = false
	self.pl_watch_frame:Hide()
	UIFrameFadeIn(self,self.time,0,self.state_alpha)
end

function S.make_plav(self,time,lock,alpha)
	if self.pl_watch_frame then return end
	self.pl_watch_frame = CreateFrame("Frame",nil,self)
	self.pl_watch_frame:Hide()
	self.pl_watch_frame.lock = lock
	self.pl_watch_frame.parent = self
	self.state_alpha = alpha or self:GetAlpha()
	self.hide = self.Hide
	self.time = time
	self.Hide = to_hide
	self.show = to_show
	self.pl_watch_frame:SetScript("OnUpdate",OnUpdate)
end

local function smooth(mode,x,y,z)
	return mode == true and 1 or max((10 + abs(x - y)) / (88.88888 * z), .2) * 1.1
end

function S.simple_move(self,t)
	self.pos = self.pos + t * self.speed * smooth(self.smode,self.limit,self.pos,.5)
	self:SetPoint(self.point_1,self.parent,self.point_2,self.hor and self.pos or self.alt or 0,not(self.hor) and self.pos or self.alt or 0)
	if self.pos * self.mod >= self.limit * self.mod then
		self:SetPoint(self.point_1,self.parent,self.point_2,self.hor and self.limit or self.alt or  0,not(self.hor) and self.limit or self.alt or 0)
		self.pos = self.limit
		self:SetScript("OnUpdate",nil)
		if self.finish_hide then
			self:Hide()
		end
		if self.finish_function then
			self:finish_function()
		end
	end
end

function S.simple_width(self,t)
	self.wpos = self.wpos + t * self.wspeed * smooth(self.smode,self.wlimit,self.wpos,1)
	self:SetWidth(self.wpos)
	if self.wpos * self.wmod >= self.wlimit * self.wmod then
		self:SetWidth(self.wlimit)
		self.wpos = self.wlimit
		self:SetScript("OnUpdate",nil)
		if self.wfinish_hide then
			self:Hide()
		end
		if self.finish_function then
			self:finish_function()
		end
	end
end

function S.simple_height(self,t)
	self.hpos = self.hpos + t * self.hspeed * smooth(self.smode,self.hlimit,self.hpos,1)
	self:SetHeight(self.hpos)
	if self.hpos * self.hmod >= self.hlimit * self.hmod then
		self:SetHeight(self.hlimit)
		self.hpos = self.hlimit
		self:SetScript("OnUpdate",nil)
		if self.hfinish_hide then
			self:Hide()
		end
		if self.finish_function then
			self:finish_function()
		end
	end
end

function S:Slide(frame, direction, length, speed)
	local p1, rel, p2, x, y = frame:GetPoint()
	frame.mod = ( direction == "LEFT" or direction == "DOWN" ) and -1 or 1
	frame.hor = ( direction == "LEFT" or direction == "RIGHT" ) and true or false
	frame.pos = frame.hor and x or y
	frame.alt = frame.hor and y or x
	frame.limit = ( frame.hor and x or y ) + frame.mod * length
	frame.speed = frame.mod * speed
	frame.point_1 = p1
	frame.point_2 = p2
	frame:SetScript("OnUpdate",S.simple_move)
end

function S:SetUpAnimGroup(object, type, ...)
	if not type then type = "Flash" end

	if type == "Flash" then
		object.anim = object:CreateAnimationGroup("Flash")
		object.anim.fadein = object.anim:CreateAnimation("ALPHA", "FadeIn")
		object.anim.fadein:SetChange(1)
		object.anim.fadein:SetOrder(2)

		object.anim.fadeout = object.anim:CreateAnimation("ALPHA", "FadeOut")
		object.anim.fadeout:SetChange(-1)
		object.anim.fadeout:SetOrder(1)
	elseif type == 'FlashLoop' then
		object.anim = object:CreateAnimationGroup("Flash")
		object.anim.fadein = object.anim:CreateAnimation("ALPHA", "FadeIn")
		object.anim.fadein:SetChange(1)
		object.anim.fadein:SetOrder(2)

		object.anim.fadeout = object.anim:CreateAnimation("ALPHA", "FadeOut")
		object.anim.fadeout:SetChange(-1)
		object.anim.fadeout:SetOrder(1)	

		object.anim:SetScript("OnFinished", function(self, requested)
			if(not requested) then
				object.anim:Play()
			end
		end)	
	elseif type == 'Shake' then
		object.shake = object:CreateAnimationGroup("Shake")
		object.shake:SetLooping("REPEAT")
		object.shake.path = object.shake:CreateAnimation("Path")
		object.shake.path[1] = object.shake.path:CreateControlPoint()
		object.shake.path[2] = object.shake.path:CreateControlPoint()
		object.shake.path[3] = object.shake.path:CreateControlPoint()
		object.shake.path[4] = object.shake.path:CreateControlPoint()
		object.shake.path[5] = object.shake.path:CreateControlPoint()
		object.shake.path[6] = object.shake.path:CreateControlPoint()

		object.shake.path:SetDuration(0.7)		
		object.shake.path[1]:SetOffset(random(-9, 7), random(-7, 12))
		object.shake.path[1]:SetOrder(1)
		object.shake.path[2]:SetOffset(random(-5, 9), random(-9, 5))
		object.shake.path[2]:SetOrder(2)
		object.shake.path[3]:SetOffset(random(-5, 7), random(-7, 5))
		object.shake.path[3]:SetOrder(3)
		object.shake.path[4]:SetOffset(random(-9, 9), random(-9, 9))
		object.shake.path[4]:SetOrder(4)
		object.shake.path[5]:SetOffset(random(-5, 7), random(-7, 5))
		object.shake.path[5]:SetOrder(5)
		object.shake.path[6]:SetOffset(random(-9, 7), random(-9, 5))
		object.shake.path[6]:SetOrder(6)
	elseif type == 'Shake_Horizontal' then
		object.shakeh = object:CreateAnimationGroup("ShakeH")
		object.shakeh:SetLooping("REPEAT")
		object.shakeh.path = object.shakeh:CreateAnimation("Path")
		object.shakeh.path[1] = object.shakeh.path:CreateControlPoint()
		object.shakeh.path[2] = object.shakeh.path:CreateControlPoint()
		object.shakeh.path[3] = object.shakeh.path:CreateControlPoint()
		object.shakeh.path[4] = object.shakeh.path:CreateControlPoint()
		object.shakeh.path[5] = object.shakeh.path:CreateControlPoint()
		object.shakeh.path[6] = object.shakeh.path:CreateControlPoint()
		
		object.shakeh.path:SetDuration(2)		
		object.shakeh.path[1]:SetOffset(-5, 0)
		object.shakeh.path[1]:SetOrder(1)
		object.shakeh.path[2]:SetOffset(5, 0)
		object.shakeh.path[2]:SetOrder(2)
		object.shakeh.path[3]:SetOffset(-2, 0)
		object.shakeh.path[3]:SetOrder(3)
		object.shakeh.path[4]:SetOffset(5, 0)
		object.shakeh.path[4]:SetOrder(4)
		object.shakeh.path[5]:SetOffset(-2, 0)
		object.shakeh.path[5]:SetOrder(5)
		object.shakeh.path[6]:SetOffset(5, 0)
		object.shakeh.path[6]:SetOrder(6)	
	else
		local x, y, duration, customName = ...
		if not customName then
			customName = "anim"
		end
		object[customName] = object:CreateAnimationGroup("Move_In")
		object[customName].in1 = object[customName]:CreateAnimation("Translation")
		object[customName].in1:SetDuration(0)
		object[customName].in1:SetOrder(1)
		object[customName].in2 = object[customName]:CreateAnimation("Translation")
		object[customName].in2:SetDuration(duration)
		object[customName].in2:SetOrder(2)
		object[customName].in2:SetSmoothing("OUT")
		object[customName].out1 = object:CreateAnimationGroup("Move_Out")
		object[customName].out2 = object[customName].out1:CreateAnimation("Translation")
		object[customName].out2:SetDuration(duration)
		object[customName].out2:SetOrder(1)
		object[customName].out2:SetSmoothing("IN")
		object[customName].in1:SetOffset(S:Scale(x), S:Scale(y))
		object[customName].in2:SetOffset(S:Scale(-x), S:Scale(-y))
		object[customName].out2:SetOffset(S:Scale(x), S:Scale(y))
		object[customName].out1:SetScript("OnFinished", function() object:Hide() end)
	end
end

function S:Flash(object, duration, loop)
	if not object.anim then
		S:SetUpAnimGroup(object, loop and "FlashLoop" or 'Flash')
	end

	if not object.anim.playing then
		object.anim.fadein:SetDuration(duration)
		object.anim.fadeout:SetDuration(duration)
		object.anim:Play()
		object.anim.playing = true
	end
end

function S:StopFlash(object)
	if object.anim then
		object.anim:Finish()
	end
end

local frameFadeManager = CreateFrame("FRAME")
local FADEFRAMES = {}

function S:UIFrameFade_OnUpdate(elapsed)
	local index = 1
	local frame, fadeInfo
	while FADEFRAMES[index] do
		frame = FADEFRAMES[index]
		fadeInfo = FADEFRAMES[index].fadeInfo
		-- Reset the timer if there isn't one, this is just an internal counter
		if ( not fadeInfo.fadeTimer ) then
			fadeInfo.fadeTimer = 0
		end
		fadeInfo.fadeTimer = fadeInfo.fadeTimer + elapsed

		-- If the fadeTimer is less then the desired fade time then set the alpha otherwise hold the fade state, call the finished function, or just finish the fade
		if ( fadeInfo.fadeTimer < fadeInfo.timeToFade ) then
			if ( fadeInfo.mode == "IN" ) then
				frame:SetAlpha((fadeInfo.fadeTimer / fadeInfo.timeToFade) * (fadeInfo.endAlpha - fadeInfo.startAlpha) + fadeInfo.startAlpha)
			elseif ( fadeInfo.mode == "OUT" ) then
				frame:SetAlpha(((fadeInfo.timeToFade - fadeInfo.fadeTimer) / fadeInfo.timeToFade) * (fadeInfo.startAlpha - fadeInfo.endAlpha)  + fadeInfo.endAlpha)
			end
		else
			frame:SetAlpha(fadeInfo.endAlpha)
			-- If there is a fadeHoldTime then wait until its passed to continue on
			if ( fadeInfo.fadeHoldTime and fadeInfo.fadeHoldTime > 0  ) then
				fadeInfo.fadeHoldTime = fadeInfo.fadeHoldTime - elapsed
			else
				-- Complete the fade and call the finished function if there is one
				S:UIFrameFadeRemoveFrame(frame)
				if ( fadeInfo.finishedFunc ) then
					fadeInfo.finishedFunc(fadeInfo.finishedArg1, fadeInfo.finishedArg2, fadeInfo.finishedArg3, fadeInfo.finishedArg4)
					fadeInfo.finishedFunc = nil
				end
			end
		end

		index = index + 1
	end

	if ( #FADEFRAMES == 0 ) then
		frameFadeManager:SetScript("OnUpdate", nil)
	end
end

-- Generic fade function
function S:UIFrameFade(frame, fadeInfo)
	if (not frame) then
		return
	end
	if ( not fadeInfo.mode ) then
		fadeInfo.mode = "IN"
	end
	local alpha
	if ( fadeInfo.mode == "IN" ) then
		if ( not fadeInfo.startAlpha ) then
			fadeInfo.startAlpha = 0
		end
		if ( not fadeInfo.endAlpha ) then
			fadeInfo.endAlpha = 1.0
		end
		alpha = 0
	elseif ( fadeInfo.mode == "OUT" ) then
		if ( not fadeInfo.startAlpha ) then
			fadeInfo.startAlpha = 1.0
		end
		if ( not fadeInfo.endAlpha ) then
			fadeInfo.endAlpha = 0
		end
		alpha = 1.0
	end
	frame:SetAlpha(fadeInfo.startAlpha)

	frame.fadeInfo = fadeInfo
	if not frame:IsProtected() then
		frame:Show()
	end

	local index = 1
	while FADEFRAMES[index] do
		-- If frame is already set to fade then return
		if ( FADEFRAMES[index] == frame ) then
			return
		end
		index = index + 1
	end
	tinsert(FADEFRAMES, frame)
	frameFadeManager:SetScript("OnUpdate", S.UIFrameFade_OnUpdate)
end

-- Convenience function to do a simple fade in
function S:UIFrameFadeIn(frame, timeToFade, startAlpha, endAlpha)
	local fadeInfo = {}
	fadeInfo.mode = "IN"
	fadeInfo.timeToFade = timeToFade
	fadeInfo.startAlpha = startAlpha
	fadeInfo.endAlpha = endAlpha
	S:UIFrameFade(frame, fadeInfo)
end

-- Convenience function to do a simple fade out
function S:UIFrameFadeOut(frame, timeToFade, startAlpha, endAlpha)
	local fadeInfo = {}
	fadeInfo.mode = "OUT"
	fadeInfo.timeToFade = timeToFade
	fadeInfo.startAlpha = startAlpha
	fadeInfo.endAlpha = endAlpha
	S:UIFrameFade(frame, fadeInfo)
end

function S:tDeleteItem(table, item)
	local index = 1
	while table[index] do
		if ( item == table[index] ) then
			tremove(table, index)
		else
			index = index + 1
		end
	end
end

function S:UIFrameFadeRemoveFrame(frame)
	S:tDeleteItem(FADEFRAMES, frame)
end

local smoothing = {}
local function Smooth(self, value)
	if value ~= self:GetValue() or value == 0 then
		smoothing[self] = value
	else
		smoothing[self] = nil
	end
end

function S:SmoothBar(bar)
	if not bar.SetValue_ then
		bar.SetValue_ = bar.SetValue
		bar.SetValue = Smooth
	end
end

local SmoothUpdate = CreateFrame("Frame")
SmoothUpdate:SetScript("OnUpdate", function()
	local limit = 30/GetFramerate()
	local speed = 1/8

	for bar, value in pairs(smoothing) do
		local cur = bar:GetValue()
		local new = cur + math.min((value-cur)*speed, math.max(value-cur, limit))
		if new ~= new then
			new = value
		end
		bar:SetValue_(new)
		if (cur == value or math.abs(new - value) < 1) then
			bar:SetValue_(value)
			smoothing[bar] = nil
		end
	end
end)

-- Banner show/hide animations

local interval = 0.1

function S:ShowAnima(f)
	if type(f) == "string" then
		f = _G[f]
		if _G[f] == nil then
			error(f.." frame is null")
			return
		end
	else
		if type(f) ~= "table" then
			error(f.."not a frame or frame name")
			return
		end
	end
	if f:IsShown() then
		f:Hide()
	end 
	if f:GetAlpha() > 0.11 then
		f:SetAlpha(0.1)
	end
	if f:GetScale() > 0.11 then
		f:SetScale(0.1)
	end
	
	f.bannerShown = true
	f:Show()
	local scale
	f:SetScript("OnUpdate", function(self)
		scale = self:GetScale() + interval
		self:SetScale(scale)
		self:SetAlpha(scale)
		if scale >= 1 then
			self:SetScale(1)
			self:SetScript("OnUpdate", nil)
		end
	end)

end

function S:HideAnima(f)
	if type(f) == "string" then
		f = _G[f]
		if _G[f] == nil then
			error(f.." frame is null")
			return
		end
	else
		if type(f) ~= "table" then
			error(f.."not a frame or frame name")
			return
		end
	end
	local scale
	f:SetScript("OnUpdate", function(self)
		scale = self:GetScale() - interval
		if scale <= 0.1 then
			self:SetScript("OnUpdate", nil)
			self:Hide()
			f.bannerShown = false
			return
		end
		self:SetScale(scale)
		self:SetAlpha(scale)
	end)
end