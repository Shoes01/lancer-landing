extends Node


var FRAMES : Array
var TALENTS : Array
var SKILLS : Array
var SYSTEMS : Array
var WEAPONS : Array

func _ready():
	var path : String
	var file : File
	var json : String
	
	# FRAMES.
	path = "res://data/frames.json"
	file = File.new()
	file.open(path, File.READ)
	json = file.get_as_text()
	FRAMES = JSON.parse(json).result
	file.close()
	
	# SKILLS.
	path = "res://data/skills.json"
	file = File.new()
	file.open(path, File.READ)
	json = file.get_as_text()
	SKILLS = JSON.parse(json).result
	file.close()
	
	# TALENTS.
	path = "res://data/talents.json"
	file = File.new()
	file.open(path, File.READ)
	json = file.get_as_text()
	TALENTS = JSON.parse(json).result
	file.close()
	
	# SYSTEMS.
	path = "res://data/systems.json"
	file = File.new()
	file.open(path, File.READ)
	json = file.get_as_text()
	SYSTEMS = JSON.parse(json).result
	file.close()
	
	# WEAPONS.
	path = "res://data/weapons.json"
	file = File.new()
	file.open(path, File.READ)
	json = file.get_as_text()
	WEAPONS = JSON.parse(json).result
	file.close()
