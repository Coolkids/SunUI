local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local AddOnName = ...

S.myclass            = select(2, UnitClass("player"))
if CUSTOM_CLASS_COLORS then
	S.myclasscolor = CUSTOM_CLASS_COLORS[S.myclass]
else
	S.myclasscolor = RAID_CLASS_COLORS[S.myclass]
end
S.myname             = UnitName("player")
S.myrealm            = GetRealmName()
S.version            = GetAddOnMetadata(AddOnName, "Version")
S.zone = GetLocale()
S.level = UnitLevel("player")

---重要的方法
function table.removeItem(list, item, removeAll)
	local rmCount = 0
	for i = 1, #list do
		if list[i - rmCount] == item then
			
			table.remove(list, i - rmCount)
			if removeAll then
				rmCount = rmCount + 1
			else
				break
			end
		end
	end
end

function table.deepcopy(t, n)
    local newT = {}
    if n == nil then    -- 默认为浅拷贝。。。
        n = 1
    end
    for i,v in pairs(t) do
        if n>0 and type(v) == "table" then
            local T = table.deepcopy(v, n-1)
            newT[i] = T
        else
            local x = v
            newT[i] = x
        end
    end
    return newT
end