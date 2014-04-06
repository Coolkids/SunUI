local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local IB = S:GetModule("InfoBar")

function IB:CreateMemory()
	local A = S:GetModule("Skins")
	local stat = CreateFrame("Frame", "InfoPanel3", TopInfoPanel or UIParent)
	stat:SetFrameStrata("BACKGROUND")
	stat:SetFrameLevel(3)
	stat:EnableMouse(true)

	stat.text = S:CreateFS(stat, nil, nil, IB.font)
	stat.text:SetPoint("LEFT", InfoPanel2 or InfoPanel1, "RIGHT", 20, 0)
	stat:SetAllPoints(stat.text)
	
	stat.icon = stat:CreateTexture(nil, "OVERLAY")
	stat.icon:SetSize(8, 8)
	stat.icon:SetPoint("RIGHT", stat, "LEFT", -5, 0)
	stat.icon:SetTexture(IB.backdrop)
	stat.icon:SetVertexColor(unpack(IB.InfoBarStatusColor[3]))
	A:CreateShadow(stat, stat.icon)
	
	local scriptProfile = GetCVar("scriptProfile") == "1"

    local maxMemorySize = 35
	local int, int2 = 6, 5
	local kiloByteString = "%d |cffffd700kb|r"
	local megaByteString = "%.2f |cffffd700mb|r"
	local enteredFrame = false

	stat.text:SetText(string.format(megaByteString, 0))

	local function formatMem(memory)
		local mult = 10^1
		if memory > 999 then
			local mem = ((memory/1024) * mult) / mult
			return string.format(megaByteString, mem)
		else
			local mem = (memory * mult) / mult
			return string.format(kiloByteString, mem)
		end
	end

	local memoryTable = {}
	local cpuTable = {}

	local function RebuildAddonList()
		local addOnCount = GetNumAddOns()
		if (addOnCount == #memoryTable) then return end
		memoryTable = {}
		cpuTable = {}
		for i = 1, addOnCount do
			memoryTable[i] = { i, select(2, GetAddOnInfo(i)), 0, IsAddOnLoaded(i) }
			cpuTable[i] = { i, select(2, GetAddOnInfo(i)), 0, IsAddOnLoaded(i) }
		end
	end

	local function UpdateMemory()
		UpdateAddOnMemoryUsage()
		local addOnMem = 0
		local totalMemory = 0
		for i = 1, #memoryTable do
			addOnMem = GetAddOnMemoryUsage(memoryTable[i][1])
			memoryTable[i][3] = addOnMem
			totalMemory = totalMemory + addOnMem
		end
		table.sort(memoryTable, function(a, b)
			if a and b then
				return a[3] > b[3]
			end
		end)
		return totalMemory
	end

	local function UpdateCPU()
		UpdateAddOnCPUUsage()
		local addOnCPU = 0
		local totalCPU = 0
		for i = 1, #cpuTable do
			addOnCPU = GetAddOnCPUUsage(cpuTable[i][1])
			cpuTable[i][3] = addOnCPU
			totalCPU = totalCPU + addOnCPU
		end
		table.sort(cpuTable, function(a, b)
			if a and b then
				return a[3] > b[3]
			end
		end)
		return totalCPU
	end

	local function OnEnter(self)
		enteredFrame = true
		GameTooltip:SetOwner(stat, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:ClearLines()
		GameTooltip:AddLine(L["内存"],0,.6,1)
		GameTooltip:AddLine(" ")
		
		if IsAltKeyDown() and scriptProfile then
			local totalCPU = UpdateCPU()
			GameTooltip:AddDoubleLine(L["总CPU使用"]..": ",  format("%dms", totalCPU), 0.69, 0.31, 0.31,0.84, 0.75, 0.65)
			GameTooltip:AddLine(" ")
			for i = 1, #cpuTable do
				if (cpuTable[i][4]) then
					local red = cpuTable[i][3] / totalCPU
					local green = 1 - red
					GameTooltip:AddDoubleLine(cpuTable[i][2], format("%dms", cpuTable[i][3]), 1, 1, 1, red, green + .5, 0)
				end
			end
		else
			local totalMemory = UpdateMemory()
			GameTooltip:AddDoubleLine(L["总内存使用"]..": ", formatMem(totalMemory), 0.69, 0.31, 0.31,0.84, 0.75, 0.65)
			GameTooltip:AddLine(" ")
			for i = 1, #memoryTable do
				if (memoryTable[i][4]) then
					local red = memoryTable[i][3] / totalMemory
					local green = 1 - red
					GameTooltip:AddDoubleLine(memoryTable[i][2], formatMem(memoryTable[i][3]), 1, 1, 1, red, green + .5, 0)
				end
			end
		end
		GameTooltip:Show()
	end

	local function OnLeave()
		enteredFrame = false
		GameTooltip_Hide()
	end

	local function OnUpdate(self, t)
		int = int - t
		int2 = int2 - t

		if int < 0 then
			RebuildAddonList()
			local total = UpdateMemory()
			stat.text:SetText(formatMem(total))
			local r, g, b = S:ColorGradient(total/(maxMemorySize * 1024), IB.InfoBarStatusColor[3][1], IB.InfoBarStatusColor[3][2], IB.InfoBarStatusColor[3][3], 
																	IB.InfoBarStatusColor[2][1], IB.InfoBarStatusColor[2][2], IB.InfoBarStatusColor[2][3],
																	IB.InfoBarStatusColor[1][1], IB.InfoBarStatusColor[1][2], IB.InfoBarStatusColor[1][3])
			stat.icon:SetVertexColor(r, g, b)
			int = 10
		end
		if int2 < 0 then
			if enteredFrame then
				OnEnter(self)
			end
			int2 = 1
		end
	end

	stat:HookScript("OnMouseDown", function(self)
		UpdateAddOnMemoryUsage()
		local before = gcinfo()
		collectgarbage("collect")
		ResetCPUUsage()
		UpdateAddOnMemoryUsage()
		S:Print(L["共释放内存"], formatMem(before - gcinfo()))
	end)
	stat:HookScript("OnUpdate", OnUpdate)
	stat:HookScript("OnEnter", OnEnter)
	stat:HookScript("OnLeave", OnLeave)

	hooksecurefunc("collectgarbage", function() OnUpdate(Status, 10) end)
end