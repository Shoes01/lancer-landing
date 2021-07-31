extends Panel


onready var MissionLog := $VBoxContainer/HBoxContainer/MissionLog

onready var goals := $VBoxContainer/HBoxContainer/MissionLog/VBoxContainer/WhitePanel/VBoxContainer/GoalsBody
onready var mission := $VBoxContainer/HBoxContainer/MissionLog/VBoxContainer/WhitePanel/VBoxContainer/MissionBody
onready var mission_number := $VBoxContainer/HBoxContainer/MissionLog/VBoxContainer/WhitePanel/VBoxContainer/Mission
onready var reserves := $VBoxContainer/HBoxContainer/MissionLog/VBoxContainer/WhitePanel/VBoxContainer/ReservesBody
onready var stakes := $VBoxContainer/HBoxContainer/MissionLog/VBoxContainer/WhitePanel/VBoxContainer/StakesBody

onready var planet_animation := $VBoxContainer/TopBar/Planet/Planet/AnimationPlayer


func _ready():
	mission_number.set_text("MISSION // #001")
	var text := "Disrupt Harrison Armory reclamation efforts"
	mission.set_text(text.to_upper())
	goals.set_text(">>> Prevent Harrison Armory from establishing a base.")
	stakes.set_text(">>> Upon failure, Harrison Armory will hunt you down.")
	reserves.set_text(">>> COMP/CON Integrated Hacking Suite")
	
	
	planet_animation.play("Idle")


func _on_Button_pressed():
	OS.shell_open("https://compcon.app/#/")


func _on_Button2_pressed():
	OS.shell_open("https://www.owlbear.rodeo/")
