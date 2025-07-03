extends RigidBody3D
## This class represents a ship in the game.

const Constants := preload("../constants.gd")
const MAXVELOCITY := 50.0
const ROTATIONSPEED := 3.0
const SPEED_INCREMENT := 0.05
const SPEED_SCALE_MAX := 2.0

@export var linear_damping := 1.0
@export var angular_damping := 5.0

signal speed_scale_changed(value)

var impulse := Vector3.ZERO
var torque := Vector3.ZERO
## The speed scale of the ship.
var speed_scale := 0.5: get = get_speed_scale, set = set_speed_scale

# Called when the node enters the scene tree for the first time.
func _ready():
	linear_damp = linear_damping
	angular_damp = angular_damping

func _physics_process(delta: float):
	calculate_gravity(delta)
	apply_central_impulse(impulse)
	apply_torque(torque)
	impulse = Vector3.ZERO
	torque = Vector3.ZERO

func _integrate_forces(state: PhysicsDirectBodyState3D):
	pass

## Applies thrust to the ship.
func apply_thrust(v: Vector3) -> bool:
	if linear_velocity.length() > MAXVELOCITY:
		return false
	impulse += transform.basis.z * v.z * speed_scale
	impulse += transform.basis.x * v.x * speed_scale
	return true

## Rotates the ship.
func rotate(axis: Vector3, degrees: float):
	torque += axis * degrees

## Calculates the gravity to be applied to the ship.
func calculate_gravity(delta: float):
	var bodies = get_tree().get_nodes_in_group("planets")
	for body in bodies:
		var radius : float = body.global_transform.origin.distance_to(global_transform.origin)
		var direction : Vector3 = (body.global_transform.origin - global_transform.origin).normalized()
		var accel = direction * Constants.GRAVITY * body.mass / (radius * radius) * delta
		impulse += accel

## Sets the speed scale of the ship.
func set_speed_scale(new: float):
	speed_scale = new
	clamp(speed_scale, SPEED_INCREMENT, SPEED_SCALE_MAX)
	emit_signal("speed_scale_changed", new)

## Returns the speed scale of the ship.
func get_speed_scale():
	return speed_scale
