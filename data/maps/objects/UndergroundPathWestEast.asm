	object_const_def
	const_export UNDERGROUNDPATHWESTEAST_CHIEF

UndergroundPathWestEast_Object:
	db $1 ; border block

	def_warp_events
	warp_event  2,  5, UNDERGROUND_PATH_ROUTE_7, 3
	warp_event 47,  2, UNDERGROUND_PATH_ROUTE_8, 3

	def_bg_events

	def_object_events
	object_event 26,  3, SPRITE_CHIEF, STAY, LEFT, TEXT_UNDERGROUNDPATHWESTEAST_CHIEF

	def_warps_to UNDERGROUND_PATH_WEST_EAST
