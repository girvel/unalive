local module = {}

module.chance = function(chance)
	return math.random() < chance
end

module.choice = function(list)
	return list[math.ceil(math.random() * #list)]
end

return module
