--[[
	For Kui Nameplates
	Rename this file to custom.lua to attach custom code to the addon. Once
	renamed, you'll need to completely restart WoW so that it detects the file.
]]
local kn = KuiNameplates

---------------------------------------------------------------------- Create --
local function PostCreate(frame)
	-- Place code to be performed after a frame is created here.
end

------------------------------------------------------------------------ Show --
local function PostShow(frame)
	-- Place code to be performed after a frame is shown here.
end

------------------------------------------------------------------------ Hide --
local function PostHide(frame)
	-- Place code to be performed after a frame is hidden here.
end

---------------------------------------------------------------------- Target --
local function PostTarget(frame)
	-- Place code to be performed when a frame becomes the player's target here.
end

-------------------------------------------------------------------- Register --
kn.RegisterPostFunction('create', PostCreate)
kn.RegisterPostFunction('show', PostShow)
kn.RegisterPostFunction('hide', PostHide)
kn.RegisterPostFunction('target', PostTarget)