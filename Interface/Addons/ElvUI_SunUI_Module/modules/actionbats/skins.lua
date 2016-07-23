local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local AB = E:GetModule('ActionBars')
local LSM = LibStub("LibSharedMedia-3.0")

function AB:StyleButton(button, noBackdrop, useMasque)
	local name = button:GetName();
	local icon = _G[name.."Icon"];
	local count = _G[name.."Count"];
	local flash	 = _G[name.."Flash"];
	local hotkey = _G[name.."HotKey"];
	local border  = _G[name.."Border"];
	local macroName = _G[name.."Name"];
	local normal  = _G[name.."NormalTexture"];
	local normal2 = button:GetNormalTexture()
	local shine = _G[name.."Shine"];
	local combat = InCombatLockdown()

	if not button.noBackdrop then
		button.noBackdrop = noBackdrop;
	end

	if not button.useMasque then
		button.useMasque = useMasque;
	end

	if flash then flash:SetTexture(nil); end
	if normal then normal:SetTexture(nil); normal:Hide(); normal:SetAlpha(0); end
	if normal2 then normal2:SetTexture(nil); normal2:Hide(); normal2:SetAlpha(0); end

	if border and not button.useMasque then
		border:Kill();
	end

	if count then
		count:ClearAllPoints();
		count:Point("BOTTOMRIGHT", 0, 2);
		count:FontTemplate(LSM:Fetch("font", self.db.font), self.db.fontSize, self.db.fontOutline)
	end

	if not button.noBackdrop and not button.backdrop and not button.useMasque then
		button:CreateBackdrop('Transparent', true)   --唯一重写的地方
		button.backdrop:SetAllPoints()
	end

	if icon then
		icon:SetTexCoord(unpack(E.TexCoords));
		icon:SetInside()
	end

	if shine then
		shine:SetAllPoints()
	end

	if self.db.hotkeytext then
		hotkey:FontTemplate(LSM:Fetch("font", self.db.font), self.db.fontSize, self.db.fontOutline)
	end

	--Extra Action Button
	if button.style then
		--button.style:SetParent(button.backdrop)
		button.style:SetDrawLayer('BACKGROUND', -7)
	end

	button.FlyoutUpdateFunc = AB.StyleFlyout
	self:FixKeybindText(button);

	if not button.useMasque then
		button:StyleButton();
	else
		button:StyleButton(true, true, true)
	end

	if(not self.handledbuttons[button]) then
		E:RegisterCooldown(button.cooldown)

		self.handledbuttons[button] = true;
	end
end