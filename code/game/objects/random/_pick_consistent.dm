GLOBAL_LIST_EMPTY(consistent_pick_cache)

/*
# Explanation of what this is, and what problem it is trying to solve.

Example scenario: You want a big multi-tile table with a random wood type. Tables are composed of multiple parts.
The problem: If you just use `/obj/random/table`, then you will have a table that's all wrong, made from different wood types.
The solution: Consistent randomness. In this case, area-consistent. It returns the same thing when called different times in the same area.

The `consistent_pick_cache` is basically a 2-level assoc list:
```
GLOB.consistent_pick_cache = list(
	/area/example1 = list(
		/obj/random/table = /obj/structure/table/wood/bamboo,
	),
	/area/example2 = list(
		/obj/random/table = /obj/structure/table/wood/maple,
	),
)
```

*/

/**
 * Picks an item from a list consistently based on a scope and identifier.
 * @param choices List of items to pick from.
 * @param scope_key The group boundary (like an /area datum).
 * @param identifier Unique key for this specific roll (like src.type or a string name).
 */
/proc/pick_consistent(list/choices, scope_key, identifier)
	if(!length(choices))
		dbg_stack_trace("No choices available for consistent pick")
		return null
	if(!scope_key || !identifier)
		dbg_stack_trace("No scope key or identifier provided for consistent pick")
		return pickweight(choices)

	// get the scope cache (eg. for the area)
	var/list/scope_cache = GLOB.consistent_pick_cache[scope_key]

	// if already in cache, just return what was picked for this identifier and scope
	if(scope_cache?[identifier])
		return scope_cache[identifier]

	// if first time picking, pick and put the picked item in cache
	var/picked = pickweight(choices)
	if(!scope_cache)
		GLOB.consistent_pick_cache[scope_key] = list()
	GLOB.consistent_pick_cache[scope_key][identifier] = picked
	return picked

/// Resolves a z-level number or an atom to a z-level number
/proc/consistent_resolve_z(z_or_atom)
	var/z = z_or_atom
	if(isatom(z_or_atom))
		var/turf/T = get_turf(z_or_atom)
		z = T?.z
	dbg_assert(isnum(z) && z > 0, "invalid zlevel value: [z]")
	return z

/// Consistent within the same area.
/// Takes an `/area`, or an atom whose area is used.
/proc/pick_area_consistent(list/choices, area_or_atom, identifier)
	var/area/a = isarea(area_or_atom) ? area_or_atom : get_area(area_or_atom)
	dbg_assert(istype(a), "invalid area: [a]")
	return pick_consistent(choices, a, identifier)

/// Consistent within the same zlevel
/proc/pick_zlevel_consistent(list/choices, z_or_atom, identifier)
	var/z = consistent_resolve_z(z_or_atom)
	return pick_consistent(choices, "zlevel_[z]", identifier)

/// Consistent within the group of connected (multiz) zlevels
/proc/pick_connected_zlevels_consistent(list/choices, z_or_atom, identifier)
	var/z = consistent_resolve_z(z_or_atom)
	var/list/connected = GetConnectedZlevels(z)
	return pick_consistent(choices, "connected_zlevels_[min(connected)]", identifier)

/**
 * Consistent within the same map template.
 * Takes a `/datum/map_template` directly, or a z-level number or atom to resolve the template from.
 * If no template is found for the z-level (e.g. the main map, or templates placed with `load()`),
 * falls back to the group of connected z-levels.
 */
/proc/pick_map_template_consistent(list/choices, template_or_z_or_atom, identifier)
	if(istype(template_or_z_or_atom, /datum/map_template))
		return pick_consistent(choices, template_or_z_or_atom, identifier)

	var/z = consistent_resolve_z(template_or_z_or_atom)
	var/datum/map_template/template = get_map_template(z)
	if(template)
		return pick_consistent(choices, template, identifier)
	return pick_connected_zlevels_consistent(choices, z, identifier)

/**
 * Consistent within the same sector.
 * Takes an `/obj/effect/overmap/visitable` directly, or a z-level number or atom to resolve the sector from.
 * If no sector is found for the z-level (e.g. overmap disabled for the map, or the z-level
 * has no overmap object), falls back to the group of connected z-levels.
 */
/proc/pick_sector_consistent(list/choices, sector_or_z_or_atom, identifier)
	// Checked before resolving as an atom, since sectors are atoms themselves (they sit on the overmap zlevel).
	if(istype(sector_or_z_or_atom, /obj/effect/overmap/visitable))
		return pick_consistent(choices, sector_or_z_or_atom, identifier)

	var/z = consistent_resolve_z(sector_or_z_or_atom)
	var/obj/effect/overmap/visitable/sector = get_map_sector(z)
	if(sector)
		return pick_consistent(choices, sector, identifier)
	return pick_connected_zlevels_consistent(choices, z, identifier)
