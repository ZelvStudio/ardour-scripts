ardour {
	["type"]    = "EditorAction",
	name        = "Export selected regions",
	license     = "MIT",
	author      = "Zelv",
	description = [[Open export dialog for each selected region]]
}


function factory () return function ()

	-- get Editor GUI Selection
	local selection = Editor:get_selection ()

	-- save list of selected regions
	local regions_to_export = {}
	for r in selection.regions:regionlist ():iter () do
		regions_to_export[r:name ()] = r
	end

	-- iterates over export dialogs for each region
	for name, r in pairs(regions_to_export) do

		print ("Region:", name)

		-- set selection in the editor to the current region only
		local rv = Editor:regionview_from_region (r)
		local tmp_selection = ArdourUI.SelectionList ()
		tmp_selection:push_back(rv)

		Editor:set_selection (tmp_selection, ArdourUI.SelectionOp.Set)
		
		-- open selected region export dialog
		Editor:access_action("Region", "export-region")

	end
end end


function icon (params) return function (ctx, width, height, fg)
	local wh = math.min (width, height) * .5
	ctx:translate (math.floor (width * .5 - wh), math.floor (height * .5 - wh))

	ctx:set_line_width (1)

	function draw_arrow (x0,y0)
		ctx:set_source_rgba (.2, .2, .2, 1)
		ctx:set_line_width(1.5)

		ctx:move_to (x0, y0)
		local x1 = x0 + wh * 0.2
		local y1 = y0 - wh * .92
		local x2 = x0 + wh * 0.2 * 0.7
		local y2 = y0 - wh * .92 * 0.7
		ctx:line_to (x1, y1)
		ctx:stroke ()

		ctx:move_to (x1, y1)
		local ar = wh * 0.37
		ctx:line_to (x2 - ar, y2)
		ctx:line_to (x2 + ar, y2)
		ctx:close_path ()
		ctx:fill()
	end

	-- left rectangle
	ctx:rectangle (.25 + math.ceil(wh * 0.25), math.ceil(wh ), math.floor(wh * .66) , math.floor(.66 * wh) )
	ctx:set_source_rgba (1, 0, 0, 1)
	ctx:stroke_preserve ()
	ctx:set_source_rgba (.9, .9, .9, 1)
	ctx:fill ()

	-- right rectangle
	ctx:rectangle (.25 + math.ceil(wh * 1.1), math.ceil(wh), math.floor(wh * .66) , math.floor(.66 * wh) )
	ctx:set_source_rgba (1, 0, 0, 1)
	ctx:stroke_preserve ()
	ctx:set_source_rgba (.9, .9, .9, 1)
	ctx:fill ()


	-- left arrow
	local x0 = .25 + math.ceil(wh * 0.25) + math.floor(wh * .66) / 2.0
	local y0 = math.ceil(wh) + math.floor(wh * .66) / 2.0
	draw_arrow(x0,y0)


	-- right arrow
	local x0 = .25 + math.ceil(wh * 1.1) + math.floor(wh * .66) / 2.0
	local y0 = math.ceil(wh) + math.floor(wh * .66) / 2.0
	draw_arrow(x0,y0)
end end