extends Panel


onready var control_panels := $VBoxContainer/Body/BodyInside/ControlPanels
onready var planet_animation := $VBoxContainer/TopBar/Planet/Planet/AnimationPlayer


func _ready() -> void:
	planet_animation.play("Idle")


func _on_Button_pressed() -> void:
	OS.shell_open("https://compcon.app/#/")


func _on_Button2_pressed() -> void:
	OS.shell_open("https://www.owlbear.rodeo/")


func _on_ButtonMission_pressed() -> void:
	for child in control_panels.get_children():
		child.set_visible(false)
	
	#control_panels.get_node("MissionLog").set_visible(true)


func _on_ButtonPilots_pressed() -> void:
	for child in control_panels.get_children():
		child.set_visible(false)
	
	control_panels.get_node("PilotRoster").set_visible(true)
