extends CanvasLayer

@export_file("*.tscn") var next_scene_path: String # Determines which scene to load
@export var parameters: Dictionary # Temporarily stores parameters to be passed to target scene


func _ready():
	ResourceLoader.load_threaded_request(next_scene_path) # Starts the loading process behind the scenes


func _process(delta):
	if ResourceLoader.load_threaded_get_status(next_scene_path) == ResourceLoader.THREAD_LOAD_LOADED: # Checks to see if the file is finished loading
		set_process(false) # Stops the process function; otherwise this block will be called multiple times and cause errors
		await get_tree().create_timer(1).timeout # Added a delay for testing purposes. Can be removed in the final game.
		var new_scene: PackedScene = ResourceLoader.load_threaded_get(next_scene_path) # Gets the loaded scene, which is packed, so it'll have to be manually instantiated
		var new_node = new_scene.instantiate() # Instantiates a copy of the loaded scene
		new_node.parameters = parameters # Assigns parameters to new scene
		var current_scene = get_tree().current_scene # Stores the currently active scene, so we can replace it later
		get_tree().get_root().add_child(new_node) # Adds the new scene to the scene tree. This MUST happen before assigning it as the current scene.
		get_tree().current_scene = new_node # Assigns our new scene as the current scene
		current_scene.queue_free() # Now we can remove the original scene
