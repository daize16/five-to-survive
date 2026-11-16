extends Node

# id -> display name + placeholder colour
const DATA := {
	#"frog_legs":        {"name": "Frog's legs",       "color": Color("7d8a4e")},
	#"spider_silk":      {"name": "Spider silk",       "color": Color("d8d2c4")},
	#"bat_wings":        {"name": "Bat wings",         "color": Color("4a3b52")},
	#"beeswax":          {"name": "Beeswax",           "color": Color("d9a42b")},
	#"eye_of_newt":      {"name": "Eye of newt",       "color": Color("c4b45a")},
	"widows_tears":     {"name": "Tears of a Widow",  "color": Color("5a8fb0")},
	"shattered_mirror": {"name": "Shattered Mirror",  "color": Color("a9b4bc")},
	"crushed_beetles":  {"name": "Crushed Beetles",   "color": Color("3a2a22")},
	"raven_feather":    {"name": "Raven Feather",     "color": Color("1b1714")},
	"frozen_flame":     {"name": "Frozen Flame",      "color": Color("8fd0e8")},
}

var _cache := {}

func all_ids() -> Array:
	return DATA.keys()

func display_name(id: String) -> String:
	return DATA[id]["name"]

func get_texture(id: String) -> Texture2D:
	if _cache.has(id):
		return _cache[id]
	var tex: Texture2D
	var path := "res://assets/ingredients/%s.png" % id
	if ResourceLoader.exists(path):
		tex = load(path)
	else:
		var img := Image.create(32, 32, false, Image.FORMAT_RGBA8)
		img.fill(DATA[id]["color"])
		tex = ImageTexture.create_from_image(img)
	_cache[id] = tex
	return tex
