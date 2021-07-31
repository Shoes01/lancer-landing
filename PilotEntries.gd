extends VBoxContainer


var pilot_entry := preload("res://PilotEntry.tscn")
var pilot_ids : Array = [
	"013f5e974a9452d210fbbd931c025e8e", # Graham
	"338eaacba5dffaae6dacb377eacebdc9", # Chris
	"9418ddc5db0954ec63fbffe6c708bb09", # Ben
	"5a42c481e9fa56e3558d9351fedb5cc5", # Max
	"c03489ef31be804c39e09132351a931b", # Pierre
	"e1fe55ea2beed354539ea3f25e297491"  # Sacha
	]


func _ready() -> void:	
	for pilot_id in pilot_ids:
		var child := pilot_entry.instance()
		$ScrollContainer/Pilots.add_child(child)
	
	var counter := 0
	for child in $ScrollContainer/Pilots.get_children():
		child.init(pilot_ids[counter])
		counter += 1
		

