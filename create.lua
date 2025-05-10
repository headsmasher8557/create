-- type checker
local function check(givenValue, expectedType, err)
	local err = err or "expected {expected}, got {given}"
	local givenType = typeof(givenValue)
	assert(givenType == expectedType,
		err:gsub("{given}", givenType):gsub("{expected}", expectedType))
end
local Create_Impl
local function constructor(obj)
	return function(dat)
		for i,v in pairs(dat) do
			if type(i) == "number" then
				check(v, "Instance", "numeric keys must be paired with {expected}s, got {given}")
				v.Parent = obj
			elseif type(i) == "table" then
				if i.__e then
					check(v, "function", "Create.E must be paired with a {expected}, got {given}")
					obj[i.__e]:Connect(function(...)
						v(obj, ...)
					end)
				end
			elseif i ~= "Parent" and i ~= Create_Impl then
				obj[i] = v
			end
		end
		local init = dat[Create_Impl]
		if init then
			check(init, "function", "[Create] must be set to a {expected}, got {given}")
			init(obj)
		end
		obj.Parent = dat.Parent or obj.Parent
		return obj
	end
end
local function Create_Priv(ty)
	return constructor(Instance.new(ty))
end
Create_Impl = setmetatable({E = function(name)
	return {__e = name}
end, set = function(obj) -- same as Create, but an Instance is passed through instead
	return constructor(obj)
end}, {
	__call = function(t, ...)
		return Create_Priv(...)
	end
})
-- alternative function names
Create_Impl.Event = Create_Impl.E
Create_Impl.event = Create_Impl.E
Create_Impl.e = Create_Impl.E
Create_Impl.Set = Create_Impl.set

return Create_Impl
