#if !defined(using_map_DATUM)

	#include "vignette-large.dmm"

	#include "vignette_areas.dm"
	#include "vignette_elevator.dm"
	#include "vignette_presets.dm"
	#define using_map_DATUM /datum/map/vignette

#elif !defined(MAP_OVERRIDE)
	#warn A map has already been included, ignoring Vignette

#endif
