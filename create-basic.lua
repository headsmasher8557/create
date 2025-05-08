function set(obj)
	return function(data)
		for k, v in pairs(data) do
			if type(k) == 'number' then
				v.Parent = obj
			elseif k ~= "Parent" then
				obj[k] = v
			end
		end
		obj.Parent = data.Parent
		return obj
	end
end

function Create(ty)
	return set(Instance.new(ty))
end

return Create