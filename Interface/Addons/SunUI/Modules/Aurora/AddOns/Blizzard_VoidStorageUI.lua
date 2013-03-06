local S, L, DB, _, C = unpack(select(2, ...))
local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
local AuroraConfig = DB.AuroraConfig

DB.AuroraModules["Blizzard_VoidStorageUI"] = function()
	S.SetBD(VoidStorageFrame, 20, 0, 0, 20)
	S.CreateBD(VoidStoragePurchaseFrame)

	VoidStorageBorderFrame:DisableDrawLayer("BORDER")
	VoidStorageBorderFrame:DisableDrawLayer("BACKGROUND")
	VoidStorageBorderFrame:DisableDrawLayer("OVERLAY")
	VoidStorageDepositFrame:DisableDrawLayer("BACKGROUND")
	VoidStorageDepositFrame:DisableDrawLayer("BORDER")
	VoidStorageWithdrawFrame:DisableDrawLayer("BACKGROUND")
	VoidStorageWithdrawFrame:DisableDrawLayer("BORDER")
	VoidStorageCostFrame:DisableDrawLayer("BACKGROUND")
	VoidStorageCostFrame:DisableDrawLayer("BORDER")
	VoidStorageStorageFrame:DisableDrawLayer("BACKGROUND")
	VoidStorageStorageFrame:DisableDrawLayer("BORDER")
	VoidStorageFrameMarbleBg:Hide()
	select(2, VoidStorageFrame:GetRegions()):Hide()
	VoidStorageFrameLines:Hide()
	VoidStorageStorageFrameLine1:Hide()
	VoidStorageStorageFrameLine2:Hide()
	VoidStorageStorageFrameLine3:Hide()
	VoidStorageStorageFrameLine4:Hide()
	select(12, VoidStorageDepositFrame:GetRegions()):Hide()
	select(12, VoidStorageWithdrawFrame:GetRegions()):Hide()
	for i = 1, 10 do
		select(i, VoidStoragePurchaseFrame:GetRegions()):Hide()
	end

	for i = 1, 9 do
		local bu1 = _G["VoidStorageDepositButton"..i]
		local bu2 = _G["VoidStorageWithdrawButton"..i]

		bu1:SetPushedTexture("")
		bu2:SetPushedTexture("")

		_G["VoidStorageDepositButton"..i.."Bg"]:Hide()
		_G["VoidStorageWithdrawButton"..i.."Bg"]:Hide()

		_G["VoidStorageDepositButton"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
		_G["VoidStorageWithdrawButton"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)

		local bg1 = CreateFrame("Frame", nil, bu1)
		bg1:Point("TOPLEFT", -1, 1)
		bg1:Point("BOTTOMRIGHT", 1, -1)
		bg1:SetFrameLevel(bu1:GetFrameLevel()-1)
		S.CreateBD(bg1, .25)

		local bg2 = CreateFrame("Frame", nil, bu2)
		bg2:Point("TOPLEFT", -1, 1)
		bg2:Point("BOTTOMRIGHT", 1, -1)
		bg2:SetFrameLevel(bu2:GetFrameLevel()-1)
		S.CreateBD(bg2, .25)
	end

	for i = 1, 80 do
		local bu = _G["VoidStorageStorageButton"..i]

		bu:SetPushedTexture("")

		_G["VoidStorageStorageButton"..i.."Bg"]:Hide()
		_G["VoidStorageStorageButton"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
	end

	S.Reskin(VoidStoragePurchaseButton)
	S.Reskin(VoidStorageHelpBoxButton)
	S.Reskin(VoidStorageTransferButton)
	S.ReskinClose(VoidStorageBorderFrame:GetChildren(), nil)
	S.ReskinInput(VoidItemSearchBox)
end