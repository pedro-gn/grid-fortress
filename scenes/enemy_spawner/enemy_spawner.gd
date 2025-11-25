extends Node
class_name EnemySpawner

## Emitted when the wave index changes.
signal wave_changed(current_wave: int, total_waves: int)
## Emitted every second during the break between waves (for the UI).
signal time_to_next_wave_updated(time_left: int)
## Emitted when spawning starts (to hide the timer).
signal wave_spawning_started
## Emitted when all waves have been completely spawned.
signal all_waves_completed

@export var waves : Array[Wave]
@export var spawn_points : Array[Node2D]
@export var autostart : bool = false

var is_spawning : bool = false

func _ready():
	if autostart:
		start()

func start():
	if is_spawning or waves.is_empty() or spawn_points.is_empty():
		return
	
	is_spawning = true
	_spawn_loop()

func _spawn_loop():
	var total_waves = waves.size()
	
	# Iterate by index so we can send the current wave number to the UI
	for i in range(total_waves):
		var wave = waves[i]
		
		# Notify UI: Wave changed (i + 1 because arrays start at 0, but humans count from 1)
		wave_changed.emit(i + 1, total_waves)
		wave_spawning_started.emit()
		
		# --- Spawning Enemies for the Current Wave ---
		for enemy_group in wave.enemies:
			var enemy_name = enemy_group.enemy_name
			var count = enemy_group.enemy_count
			var interval = enemy_group.spawn_interval
			
			if not Databases.enemies.has(enemy_name):
				continue 
				
			for j in range(count):
				_spawn_enemy(enemy_name)
				
				if interval > 0:
					await get_tree().create_timer(interval).timeout
				else:
					await get_tree().process_frame
					
		# --- Wave Finished, Waiting for Next Wave ---
		# Only wait if this isn't the very last wave
		if i < total_waves - 1 and wave.time_until_next_wave > 0:
			# Call our custom wait function that updates the UI
			await _wait_and_update_ui(wave.time_until_next_wave)
			
	# --- All Waves Completed ---
	is_spawning = false
	all_waves_completed.emit()
	print("EnemySpawner: All waves completed.")

# New helper function to handle the countdown
func _wait_and_update_ui(wait_time: float):
	var time_left = wait_time
	
	while time_left > 0:
		# Emit the floored time (e.g., 5.0 -> 5)
		time_to_next_wave_updated.emit(ceil(time_left))
		
		# Wait for 1 second (or less if time_left is small)
		var step = 1.0
		if time_left < 1.0:
			step = time_left
			
		await get_tree().create_timer(step).timeout
		time_left -= step
	
	# Send 0 to clear the UI
	time_to_next_wave_updated.emit(0)

func _spawn_enemy(enemy_name: String):
	var enemy_scene = Databases.enemies[enemy_name]
	if not enemy_scene: return
	var enemy_instance = enemy_scene.instantiate()
	get_parent().add_child.call_deferred(enemy_instance)
	var spawn_point = spawn_points.pick_random()
	if enemy_instance.has_method("set_global_position"):
		enemy_instance.set_global_position(spawn_point.global_position)
