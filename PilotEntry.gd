extends PanelContainer


var lapsed := 0.0
var ticker_text : Array = ["Loading pilot data..."]
var ticker_count := 0

var lapsed2 := 0.0
var ticker_text2 : Array = ["Loading mech data..."]
var ticker_count2 := 0

func _process(delta) -> void:
	lapsed += delta
	lapsed2 += delta
	$Data/PilotData/TickerBox/Ticker.set_visible_characters(lapsed / 0.1)
	$Data/MechTickerBox/Ticker.set_visible_characters(lapsed2 / 0.1)
	
	
	if $Data/PilotData/TickerBox/Ticker.get_percent_visible() >= 1.0:
		lapsed = 0
		ticker_count += 1
		if ticker_count >= ticker_text.size(): ticker_count = 0
		
		# Cascade.
		$Data/PilotData/TickerBox/LineTop.set_text($Data/PilotData/TickerBox/LineMiddle.get_text())
		$Data/PilotData/TickerBox/LineMiddle.set_text($Data/PilotData/TickerBox/LineBottom.get_text())
		$Data/PilotData/TickerBox/LineBottom.set_text($Data/PilotData/TickerBox/Ticker.get_text())
		
		$Data/PilotData/TickerBox/Ticker.set_text("   > " + str(ticker_text[ticker_count]))
		$Data/PilotData/TickerBox/Ticker.set_visible_characters(5)
	
	if $Data/MechTickerBox/Ticker.get_percent_visible() >= 1.0:
		lapsed2 = 0
		ticker_count2 += 1
		if ticker_count2 >= ticker_text2.size(): ticker_count2 = 0
		
		# Cascade.
		$Data/MechTickerBox/Line0.set_text($Data/MechTickerBox/Line1.get_text())
		$Data/MechTickerBox/Line1.set_text($Data/MechTickerBox/Line2.get_text())
		$Data/MechTickerBox/Line2.set_text($Data/MechTickerBox/Line3.get_text())
		$Data/MechTickerBox/Line3.set_text($Data/MechTickerBox/Line4.get_text())
		$Data/MechTickerBox/Line4.set_text($Data/MechTickerBox/Line5.get_text())
		$Data/MechTickerBox/Line5.set_text($Data/MechTickerBox/Line6.get_text())
		$Data/MechTickerBox/Line6.set_text($Data/MechTickerBox/Line7.get_text())
		$Data/MechTickerBox/Line7.set_text($Data/MechTickerBox/Line8.get_text())
		$Data/MechTickerBox/Line8.set_text($Data/MechTickerBox/Ticker.get_text())
		
		$Data/MechTickerBox/Ticker.set_text("> " + str(ticker_text2[ticker_count2]))
		$Data/MechTickerBox/Ticker.set_visible_characters(2)


func _ready() -> void:
	var image = Image.new()
	image.load("res://res/nodata.png")
	
	$Data/PilotData/TickerBox/Ticker.set_text("   > Initializing connection... ")
	$Data/PilotData/TickerBox/Ticker.set_visible_characters(5)
	
	$Data/MechTickerBox/Ticker.set_text("> Initializing connection... ")
	$Data/MechTickerBox/Ticker.set_visible_characters(2)
	
	# Resize mech image.
	var size : Vector2 = image.get_size()
	size = size * 105 / size.x
	image.resize(size.x, size.y)
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	$Data/MechData/CenterContainer/MechImage.texture = texture
	
	# Resize pilot image.
	var image2 = Image.new()
	image2.load("res://res/ManFromVolta.png")
	size = image2.get_size()
	size = size * 150 / size.x
	image2.resize(size.x, size.y)
	
	var texture2 = ImageTexture.new()
	texture2.create_from_image(image2)
	
	$Data/CenterContainer/PilotImage.texture = texture2


func init(id : String) -> void:
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	$HTTPRequestImage.connect("request_completed", self, "_on_request_image_completed")
	$HTTPRequestMech.connect("request_completed", self, "_on_request_mech_completed")
	
	# Fetch the data.
	var url := "https://api.github.com/gists/" + id
	
	$HTTPRequest.request(url)
	yield($HTTPRequest, "request_completed")


func _on_PilotData_pressed() -> void:
	OS.set_clipboard($Data/PilotData/PilotData.get_text())


func _on_request_completed(result, _response_code, _headers, body) -> void:
	if result == 5: 
		print("Error loading pilot data.")
		return
	
	var full_json_data : Dictionary = JSON.parse(body.get_string_from_ascii()).result
	
	if full_json_data.size() == 2: return # GitHub is not happy with me lol.
	
	var json_data : Dictionary = JSON.parse(full_json_data["files"]["pilot.txt"]["content"]).result
	
	# Set pilot image.
	if str(json_data["cloud_portrait"]) != "Null":
		$HTTPRequestImage.request(json_data["cloud_portrait"])
	elif str(json_data["portrait"]) != "Null":
		$HTTPRequestImage.request("https://raw.githubusercontent.com/massif-press/compcon/master/static/img/pilot/" + json_data["portrait"])
	
	# Set pilot data.
	$Data/PilotData/CallsignBody.set_text("   " + json_data["callsign"])
	var background : String = " " + json_data["background"]
	if background == " None": background = ""
	$Data/PilotData/NameBody.set_text("   " + json_data["name"] + " // " + "LL" + str(json_data["level"]) + background)
	$Data/PilotData/PilotData.set_text(full_json_data["id"])
	$Data/PilotData/LastSync.set_text("   " + str(json_data["lastSync"]))
	
	# Set pilot gibberish.
	for i in json_data["skills"].size():
		var id = json_data["skills"][i]["id"]
		var rank = int(json_data["skills"][i]["rank"]) * 2
		
		for skill in Global.SKILLS:
			if id == skill["id"]:
				ticker_text.append(skill["name"] + "+" + str(rank))
				break
	
	for i in json_data["reserves"].size():
		ticker_text.append("RESERVE: " + str(json_data["reserves"][i]))
	
	# HASE skills.
	var _H = str(json_data["mechSkills"][0])
	var _A = str(json_data["mechSkills"][1])
	var _S = str(json_data["mechSkills"][2])
	var _E = str(json_data["mechSkills"][3])
	ticker_text.append("HASE: " + _H + "/" + _A + "/" + _S + "/" + _E )
	
	for i in json_data["talents"].size():
		var id = json_data["talents"][i]["id"]
		var rank = json_data["talents"][i]["rank"]
		
		for talent in Global.TALENTS:
			if id == talent["id"]:
				ticker_text.append(talent["name"] + str(rank) + "[" + talent["ranks"][rank]["name"] + "]")
				break
	
	# Set mech data.
	$Data/MechData/MechBody.set_text("No data.")
	$Data/MechData/Mech.set_text("No data.")
	
	for mech in json_data["mechs"]:
		if mech["active"] == true:
			# Set mech name.
			$Data/MechData/MechBody.set_text(mech["name"])
			
			# Set mech image.
			if str(mech["portrait"]) != "":
				$HTTPRequestMech.request("https://raw.githubusercontent.com/massif-press/compcon/master/static/img/mech/" + mech["portrait"])
			elif str(mech["cloud_portrait"]) != "":
				$HTTPRequestMech.request(mech["cloud_portrait"])
			
			# Set mech corpro and frame.
			for frame in Global.FRAMES:
				if frame["id"] == mech["frame"]:
					$Data/MechData/Mech.set_text(frame["source"] + " // " + frame["name"])
			
			# Set mech giberish.
			ticker_text2.append("// STATS //")
			ticker_text2.append("STRUCTURE: " + str(mech["current_structure"]))
			ticker_text2.append("STRESS: " + str(mech["current_stress"]))
			ticker_text2.append("HP: " + str(mech["current_hp"]))
			ticker_text2.append("REPAIR CAP: " + str(mech["current_repairs"]))
			#ticker_text2.append("OVERCHARGE COUNT: " + str(mech["current_overcharge"]))
			ticker_text2.append("CORE ENERGY: " + str(mech["current_core_energy"]))
			
			var system_id = ""
			var weapon_id = ""
			
			for loadout in mech["loadouts"]:
				ticker_text2.append("// LOADOUT //")
				ticker_text2.append(loadout["name"])
				
				## Systems.
				ticker_text2.append("// SYSTEMS //")
				
				for system in loadout["systems"]:
					for global_system in Global.SYSTEMS:
						if global_system["id"] == system["id"]:
							ticker_text2.append(global_system["name"])
				
				for system in loadout["integratedSystems"]:
					for global_system in Global.SYSTEMS:
						if global_system["id"] == system["id"]:
							ticker_text2.append(global_system["name"])
				
				## Weapons.
				ticker_text2.append("// WEAPONS //")
				
				for mount in loadout["mounts"]:
					for slot in mount["slots"]:
						for global_weapon in Global.WEAPONS:
							if global_weapon["id"] == slot["weapon"]["id"]:
								ticker_text2.append(global_weapon["name"])
				
				for mount in loadout["integratedMounts"]:
					for slot in mount["slots"]:
						for global_weapon in Global.WEAPONS:
							if global_weapon["id"] == slot["weapon"]["id"]:
								ticker_text2.append(global_weapon["name"])
				
				#for mount in loadout["improved_armament"]:
				#	for slot in mount["slots"]:
				#		for global_weapon in Global.WEAPONS:
				#			if global_weapon["id"] == slot["weapon"]["id"]:
				#				ticker_text2.append(global_weapon["name"])
				
				#for mount in loadout["integratedWeapon"]:
				#	for slot in mount["slots"]:
				#		for global_weapon in Global.WEAPONS:
				#			if global_weapon["id"] == slot["weapon"]["id"]:
				#				ticker_text2.append(global_weapon["name"])


func _on_request_image_completed(result, _response_code, _headers, body) -> void:
	if result == 5: 
		print("Error loading pilot image.")
		return
	
	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	if error:
		image.load_jpg_from_buffer(body)
	
	# Math time.
	var size : Vector2 = image.get_size()
	size = size * 150 / size.x
	image.resize(size.x, size.y)
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	$Data/CenterContainer/PilotImage.texture = texture


func _on_request_mech_completed(result, _response_code, _headers, body) -> void:
	if result == 5: 
		print("Error loading mech image.")
		return
	
	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	if error:
		image.load_jpg_from_buffer(body)
	
	# Resize.
	var size : Vector2 = image.get_size()
	size = size * 105 / size.x
	image.resize(size.x, size.y)
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	$Data/MechData/CenterContainer/MechImage.texture = texture
