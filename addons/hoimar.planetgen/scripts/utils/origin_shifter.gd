extends Node
## Shift all nodes so the parent node always stays close to the center.

const MAX_DISTANCE := 2000.0

## The path to the world node.
@export var world_node_path: NodePath
@onready var world_node: Node3D = get_node_or_null(world_node_path)
@onready var parent := get_parent()


func _ready():
	if !world_node:
		world_node = get_node("../..")


func _process(delta):
	if parent.global_transform.origin.length() > MAX_DISTANCE:
		shift_origin()


## Shifts the origin of the world.
func shift_origin():
	var offset: Vector3 = parent.global_transform.origin
	for child in world_node.get_children():
		if child is Node3D:
			child.global_translate(-offset)
