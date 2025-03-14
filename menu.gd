extends Node3D

var noc = 1
var windowRoom: bool = false
var alarmRoom: bool = false
var lureRoom: bool = false
var generatorFull: bool = false
var doubleCheck: bool = false
var data = {
			"noc": noc,
			"windowRoomState": windowRoom,
			"alarmRoomState": alarmRoom ,
			"lureRoomState": lureRoom,
			"stavOken": [1,1,1,1,1,1,1],
			"RadarState" : false,
			"GeneratorState": generatorFull
		}

var save_path = "user://variable.save"
var new_counter = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	if not FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		file.store_var(data) 
		file.close()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if FileAccess.file_exists(save_path) == false:
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		noc = 1
		file.store_var(data)
	if FileAccess.file_exists(save_path) == true:
		var file = FileAccess.open(save_path,FileAccess.READ)
		data = file.get_var()
	print(data)
	$Control/BaseUI/Continue.text = "Continue " + str(data["noc"])


func _process(delta):
	pass


func _on_continue_pressed():
	if data["noc"]  == 1:
		get_tree().change_scene_to_file("res://Glory.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/MainScene.tscn")


func _on_new_game_pressed() -> void:
	if doubleCheck == false:
		doubleCheck = true
		$Control/BaseUI/AreYouSure.visible = true
	elif FileAccess.file_exists(save_path) == true:
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		data["noc"] = 1
		data["windowRoomState"] = false
		data["alarmRoomState"] = false
		data["lureRoomState"] = false
		data["stavOken"] = [1,1,1,1,1,1,1]
		data["RadarState"] = false
		data["GeneratorState"] = false
		file.store_var(data)
		get_tree().change_scene_to_file("res://Glory.tscn")
