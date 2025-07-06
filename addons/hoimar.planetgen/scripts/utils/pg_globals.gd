@tool
extends Node
## Global settings for Planet Generator.

const Const := preload("../constants.gd")

## Whether to draw wireframes.
var wireframe: bool = false: set = set_wireframe
## Colors patches of terrain randomly.
var colored_patches: bool
## re-generates planets even if there are still active threads.
var benchmark_mode: bool
var solar_systems: Array[SolarSystem] = []
## Global queue for TerrainJobs.
var job_queue := JobQueue.new()
var speed_scale: float = 0.001


func _ready():
	if Const.THREADS_ENABLED:
		set_process(false)   # Otherwise, process queue in single thread.


func _exit_tree():
	job_queue.clean_up()


## Queues a terrain patch to be generated.
func queue_terrain_patch(data: PatchData) -> TerrainJob:
	var job := TerrainJob.new(data)
	job_queue.queue(job)
	return job


## Registers a solar system.
func register_solar_system(sys: SolarSystem):
	solar_systems.append(sys)


## Unregisters a solar system.
func unregister_solar_system(sys: SolarSystem):
	solar_systems.erase(sys)


## Sets whether to draw wireframes.
func set_wireframe(value: bool):
	wireframe = value
	RenderingServer.set_debug_generate_wireframes(value)
	if value:
		get_viewport().set_debug_draw(SubViewport.DEBUG_DRAW_WIREFRAME)
	else:
		get_viewport().set_debug_draw(SubViewport.DEBUG_DRAW_DISABLED);


func _process(delta):
	job_queue.process_queue_without_threads()
