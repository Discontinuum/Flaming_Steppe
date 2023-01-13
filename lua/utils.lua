function wesnoth.wml_actions.get_recruit_list( cfg )
	-- support function
	-- Lua does not have the in operator as Python
	-- in Python, "in" can be used also to check if a list contains a certain value, not only to iterate
	local function check( t, v )
		for i, va in ipairs( t ) do
			if type( v ) == type( va ) and v == va then
				return true
			end
		end
		return false
	end

	local filter_side = wml.get_child( cfg, "filter_side" ) or wml.error( "Missing [filter_side] in [get_recruit_list]" )
	local filter = wml.get_child( cfg, "filter" )
	local variable = cfg.variable or "recruit_list"

	for index, side in ipairs( wesnoth.sides.find( filter_side ) ) do
		local recruit_list = { }

		for recruitable in string.gmatch( side.__cfg.recruit, '[^,]+' ) do
			table.insert( recruit_list, recruitable )
		end

		if filter then
			filter = wml.shallow_literal( filter )
			filter.side = side.side -- to avoid collecting extra_recruit from enemies
			for index,unit in ipairs( wesnoth.units.find_on_map( filter ) ) do
				if unit.canrecruit and #unit.extra_recruit > 0 then
					for extra_index, extra_recruitable in ipairs( unit.extra_recruit ) do
						if not check( recruit_list, extra_recruitable ) then
							table.insert( recruit_list, extra_recruitable )
						end
					end
				end
			end
		end

		wml.variables[string.format("%s[%d]", variable, index - 1)] = { side = side.side,
											team_name = side.team_name,
											user_team_name = side.user_team_name,
											name = side.side_name,
											recruit_list = table.concat( recruit_list, "," ) }
	end
end
