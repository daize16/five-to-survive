extends Node

signal held_changed(id: String)

const ITEMS_PER_CUPBOARD := 3

var contents := {}          # container id -> Array of ingredient ids
var held_item := ""         # "" means hands are empty

# containers: container id -> area ("cabin" or "garden")
# required:   ingredients the antidote needs (guaranteed to appear somewhere)
func new_run(containers: Dictionary, required: Array = []) -> void:
	contents.clear()
	held_item = ""
	held_changed.emit("")

	var ids: Array = containers.keys()
	ids.shuffle()
	for cid in ids:
		contents[cid] = []

	# 1. Required ingredients go in a random container of the right habitat.
	for r in required:
		var spots: Array = ids.filter(func(cid):
			return _fits(r, containers[cid]) \
				and contents[cid].size() < ITEMS_PER_CUPBOARD \
				and not contents[cid].has(r))
		if spots.is_empty():
			spots = ids.filter(func(cid): return contents[cid].size() < ITEMS_PER_CUPBOARD)
		if not spots.is_empty():
			contents[spots.pick_random()].append(r)

	# 2. Fill the rest with decoys that suit each container's area.
	for cid in ids:
		var bag: Array = contents[cid]
		var pool: Array = IngredientDB.all_ids().filter(func(x):
			return not required.has(x) and _fits(x, containers[cid]) and not bag.has(x))
		pool.shuffle()
		for d in pool:
			if bag.size() >= ITEMS_PER_CUPBOARD:
				break
			bag.append(d)
		bag.shuffle()

func _fits(ingredient_id: String, area: String) -> bool:
	var habitat: String = IngredientDB.DATA.get(ingredient_id, {}).get("habitat", "any")
	return habitat == "any" or habitat == area

func take_item(container_id: String, item_id: String) -> bool:
	if held_item != "":
		return false
	contents[container_id].erase(item_id)
	held_item = item_id
	held_changed.emit(item_id)
	return true

func use_held_item() -> String:
	var item := held_item
	held_item = ""
	held_changed.emit("")
	return item
