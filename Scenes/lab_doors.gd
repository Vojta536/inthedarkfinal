extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_enemy_hunt() -> void:
	for door in get_tree().get_nodes_in_group("metal_doors"):
		door._keepOpen()
