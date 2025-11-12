extends Node
class_name EnemySpawner

## Emitted when all waves have been completely spawned.
signal all_waves_completed

## The array of Wave resources that define the spawning sequence.
@export var waves : Array[Wave]
## The array of Node2D points where enemies will be spawned.
@export var spawn_points : Array[Node2D]
## If true, the spawner will automatically call start() in _ready().
@export var autostart : bool = false

var is_spawning : bool = false

func _ready():
	if autostart:
		start()

## Call this function to begin the wave spawning process.
func start():
	# Prevent the spawner from starting if it's already running
	if is_spawning:
		return
		
	# --- Configuration Checks ---
	if waves.is_empty():
		push_warning("EnemySpawner: 'waves' array is empty. Nothing to spawn.")
		return
		
	if spawn_points.is_empty():
		push_error("EnemySpawner: 'spawn_points' array is empty. Cannot determine spawn locations.")
		return
	
	if not get_parent():
		push_error("EnemySpawner: Spawner is not in the scene tree. Cannot spawn enemies.")
		return
		
	is_spawning = true
	# Start the asynchronous spawn loop.
	# We don't need 'async' keyword here because we just call it.
	_spawn_loop()

# This function uses 'await' to create timers, processing all waves,
# enemy groups, and intervals sequentially without blocking the main thread.
func _spawn_loop():
	for wave in waves:
		# --- Spawning Enemies for the Current Wave ---
		for enemy_group in wave.enemies:
			var enemy_name = enemy_group.enemy_name
			var count = enemy_group.enemy_count
			var interval = enemy_group.spawn_interval
			
			# Check if the enemy exists in the database
			if not Databases.enemies.has(enemy_name):
				push_error("EnemySpawner: Enemy name '%s' not found in Databases." % enemy_name)
				continue # Skip this enemy group and move to the next
				
			# Spawn 'count' enemies of this type
			for i in range(count):
				_spawn_enemy(enemy_name)
				
				# Wait for the spawn interval before spawning the next enemy
				if interval > 0:
					await get_tree().create_timer(interval).timeout
				else:
					# If interval is 0, wait for the next physics or process frame
					# to avoid spawning too many enemies in a single frame.
					await get_tree().process_frame
					
		# --- Wave Finished, Waiting for Next Wave ---
		if wave.time_until_next_wave > 0:
			await get_tree().create_timer(wave.time_until_next_wave).timeout
			
	# --- All Waves Completed ---
	is_spawning = false
	all_waves_completed.emit()
	print("EnemySpawner: All waves completed.")

# Handles the instantiation and placement of a single enemy
func _spawn_enemy(enemy_name: String):
	# 1. Get the PackedScene from the database
	var enemy_scene = Databases.enemies[enemy_name]
	if not enemy_scene:
		push_error("EnemySpawner: Scene for '%s' is null in Databases." % enemy_name)
		return
		
	# 2. Instantiate the enemy
	var enemy_instance = enemy_scene.instantiate()
	
	# 3. Add the enemy to the scene (as a sibling of the spawner)
	# This is generally safer than add_child() so enemies aren't
	# dependent on the spawner's transform or visibility.
	get_parent().add_child.call_deferred(enemy_instance)
	
	# 4. Pick a random spawn point
	var spawn_point = spawn_points.pick_random()
	
	# 5. Set its global position (assumes enemy instance is Node2D/Node3D based)
	if enemy_instance.has_method("set_global_position"):
		enemy_instance.set_global_position(spawn_point.global_position)
	else:
		push_warning("EnemySpawner: Spawned enemy '%s' does not have 'set_global_position'. Cannot set position." % enemy_name)
