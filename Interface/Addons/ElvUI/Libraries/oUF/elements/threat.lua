--[[ Element: Threat Icon

 Handles updating and toggles visibility of current threat level icon.

 Widget

 Threat - A Texture used to display the current threat level.

 Notes

 This element updates by changing colors of the texture.

 The default threat icon will be used if the UI widget is a texture and doesn't
 have a texture or color defined.

 Examples

   -- Position and size
   local Threat = self:CreateTexture(nil, 'OVERLAY')
   Threat:SetSize(16, 16)
   Threat:SetPoint('TOPRIGHT', self)
   
   -- Register it with oUF
   self.Threat = Threat

 Hooks

 Override(self) - Used to completely override the internal update function.
                  Removing the table key entry will make the element fall-back
                  to its internal function again.
]]

local parent, ns = ...
local oUF = ns.oUF

local Update = function(self, event, unit)
	if(unit ~= self.unit) or not unit or not IsLoggedIn() then return end
	
	local threat = self.Threat
	if(threat.PreUpdate) then threat:PreUpdate(unit) end

	local status = UnitThreatSituation(unit)

	local r, g, b
	if(status and status > 0) then
		r, g, b = GetThreatStatusColor(status)
		
		if threat:IsObjectType"Texture" then
			threat:SetVertexColor(r, g, b)
		end
		threat:Show()
	else
		threat:Hide()
	end

	if(threat.PostUpdate) then
		return threat:PostUpdate(unit, status, r, g, b)
	end
end

local Path = function(self, ...)
	return (self.Threat.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local Enable = function(self)
	local threat = self.Threat
	if(threat) then
		threat.__owner = self
		threat.ForceUpdate = ForceUpdate

		self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", Path)
		self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", Path)

		if(threat:IsObjectType"Texture" and not threat:GetTexture()) then
			threat:SetTexture[[Interface\Minimap\ObjectIcons]]
			threat:SetTexCoord(6/8, 7/8, 1/8, 2/8)
		end
		
		return true
	end
end

local Disable = function(self)
	local threat = self.Threat
	if(threat) then
		threat:Hide()
		self:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE", Path)
		self:UnregisterEvent("UNIT_THREAT_LIST_UPDATE", Path)
		threat:Hide()
	end
end

oUF:AddElement('Threat', Path, Enable, Disable)
