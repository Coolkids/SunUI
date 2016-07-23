local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule('Skins')
local A = E:GetModule('Skins-SunUI')


function S:HandleButton(f, strip)
	A:Reskin(f)
end

function S:HandleScrollBar(frame, thumbTrim)
	A:ReskinScroll(frame)
end

function S:HandleTab(tab)
	A:ReskinTab(tab)
end

function S:HandleCheckBox(frame, noBackdrop)
	A:ReskinCheck(frame)
end

function S:HandleIcon(icon, parent)
	A:ReskinIcon(icon)
end