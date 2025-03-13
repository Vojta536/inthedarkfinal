extends Node2D

var noc: int = 1
var windowRoom: bool = false
var alarmRoom: bool = false
var lureRoom: bool = false
var generatorFull: bool = false
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
var new_counter: int = 0


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if not FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		file.store_var(data) 
		file.close()
	if FileAccess.file_exists(save_path) == false:
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		noc = 1
		file.store_var(data)
	if FileAccess.file_exists(save_path) == true:
		var file = FileAccess.open(save_path,FileAccess.READ)
		data = file.get_var()
		noc = data["noc"]
	print(data)
	if data["windowRoomState"] == false:
		$Label.text = "You recharged your batteries, took a break and went to bed. It is hard to sleep with how cold it is outside, broken windows or not. Tomorow is another day."
	elif noc == 3:
		$Label.text = "The forest is dead silent, the only thing you can hear is the sound of the wind. Or what you think is the sound of the wind."
	elif noc == 4:
		$Label.text = "Even now, it is watching. Even now, you are not safe. Persist."
	elif noc == 5:
		$Label.text = "You are close. Do not give up."
	else:
		$Label.text = "You recharged your batteries, repaired the windows, took a break and went to bed. Tomorow is another day."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("enter"):
		
		get_tree().change_scene_to_file("res://Menu.tscn")
