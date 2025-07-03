@tool
class_name MinMax
## A simple class to keep track of the minimum and maximum values.

var min_value: float
var max_value: float


func _init():
	min_value = INF
	max_value = -INF


## Adds a new value to the MinMax object.
func add_value(new: float):
	if new < min_value:
		min_value = new
	elif new > max_value:
		max_value = new

