local REVISION = 2;
if (type(LibTableRecycler) == "table") and (LibTableRecycler.revision >= REVISION) then
	return;
end

local type = type;
local wipe = wipe;
local tremove = tremove;

LibTableRecycler = LibTableRecycler or {};
LibTableRecycler.revision = REVISION;
LibTableRecycler.storage = LibTableRecycler.storage or {};
LibTableRecycler.__index = LibTableRecycler;

local storage = LibTableRecycler.storage;
local MAX_STORAGE = 50;

function LibTableRecycler:Recycle()
	for k, v in ipairs(self) do
		if (type(v) == "table") then
			wipe(v);
			if (#storage < MAX_STORAGE) then
				storage[#storage + 1] = v;
			end
		end
		self[k] = nil;
	end
	return self;
end

function LibTableRecycler:RecycleIndex(index)
	local tbl = tremove(self,index);
	if (tbl) then
		wipe(tbl);
		if (#storage < MAX_STORAGE) then
			storage[#storage + 1] = tbl;
		end
	end
end

function LibTableRecycler:Fetch()
	local tbl = #storage > 0 and tremove(storage,#storage) or {};
	self[#self + 1] = tbl;
	return tbl;
end

function LibTableRecycler:New()
	return setmetatable(#storage > 0 and tremove(storage,#storage) or {},self);
end