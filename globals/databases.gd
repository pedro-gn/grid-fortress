extends Node

var grid_buildings = {
	"mage_tower" : preload("res://resources/grid_buildings/mage_tower.tres"),
	"archer_tower" : preload("res://resources/grid_buildings/archer_tower.tres"),
	"gold_mine" : preload("res://resources/grid_buildings/gold_mine.tres"),
	"mortar" : preload("res://resources/grid_buildings/mortar.tres"),
	"ballista" : preload("res://resources/grid_buildings/ballista.tres"),
	"acid_tower" : preload("res://resources/grid_buildings/acid_tower.tres"),
	"wall" : preload("res://resources/grid_buildings/wall.tres"),
	"drum_tower" : preload("res://resources/grid_buildings/drum_tower.tres"),
	"telescope_tower" : preload("res://resources/grid_buildings/telescope_tower.tres")
}

var enemies = {
	"skeleton" : preload("res://scenes/enemies/skeleton/skeleton.tscn"),
	"goblin" : preload("res://scenes/enemies/goblin/goblin.tscn"),
	"minotaur" : preload("res://scenes/enemies/minotaur/minotaur.tscn"),
	"bat" : preload("res://scenes/enemies/bat/bat.tscn"),
	"dragon": preload("res://scenes/dragon/dragon.tscn")
}
