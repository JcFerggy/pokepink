	object_const_def
	const_export UNDERGROUNDPATHNORTHSOUTH_CHIEF

UndergroundPathNorthSouth_Object:
	db $1 ; border block

	def_warp_events
	warp_event  5,  4, UNDERGROUND_PATH_ROUTE_5, 3
	warp_event  2, 41, UNDERGROUND_PATH_ROUTE_6, 3

	def_bg_events

	def_object_events
	object_event  4,  24, SPRITE_CHIEF, STAY, DOWN, TEXT_UNDERGROUNDPATHNORTHSOUTH_CHIEF

	def_warps_to UNDERGROUND_PATH_NORTH_SOUTH
