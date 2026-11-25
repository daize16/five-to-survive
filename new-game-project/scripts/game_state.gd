extends Node

signal held_changed(id: String)

const ITEMS_PER_CUPBOARD := 3

var contents := {}        # cupboard_id -> Array of ingredient ids
var held_item := ""       # "" means hands are empty

# Call once at the start of every run.
# `required` = ingredients the antidote needs (guaranteed to appear somewhere).
func new_run(cupboard_ids: Array, required: Array = []) -> void:
	contents.clear()
	held_item = ""
	held_changed.emit("")

	var ids := cupboard_ids.duplicate()
	ids.shuffle()
	for cid in ids:
		contents[cid] = []

	# 1. Place each required ingredient in a different random cupboard.
	for i in required.size():
		contents[ids[i % ids.size()]].append(required[i])

	# 2. Fill the remaining slots with random decoys.
	var decoys: Array = IngredientDB.all_ids().filter(
		func(x): return not required.has(x))
	for cid in ids:
		var bag: Array = contents[cid]
		decoys.shuffle()
		for d in decoys:
			if bag.size() >= ITEMS_PER_CUPBOARD:
				break
			if not bag.has(d):
				bag.append(d)
		bag.shuffle()

# Called by the pop-up when the player clicks an item.
func take_item(cupboard_id: String, item_id: String) -> bool:
	if held_item != "":
		return false      # one-item inventory: hands are full
	contents[cupboard_id].erase(item_id)
	held_item = item_id
	held_changed.emit(item_id)
	return true

func use_held_item() -> String:
	var item = held_item
	held_item = ""
	held_changed.emit("")
	return item
