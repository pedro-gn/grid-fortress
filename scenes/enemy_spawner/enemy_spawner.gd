extends Node
class_name EnemySpawner

signal wave_changed(current_wave: int, total_waves: int)
signal time_to_next_wave_updated(time_left: float, total_wait_time: float)
signal wave_progress_updated(enemies_spawned: int, total_enemies_in_wave: int)
signal wave_spawning_started
signal all_waves_completed

@export var waves : Array[Wave]
@export var spawn_points : Array[Node2D]
@export var autostart : bool = false

var is_spawning : bool = false
var _skip_waiting : bool = false 

func _ready():
	if autostart: start()

func start():
	if not is_spawning:
		if waves.is_empty() or spawn_points.is_empty(): return
		is_spawning = true
		_spawn_loop()
	else:
		skip_wave_wait()

func skip_wave_wait():
	_skip_waiting = true

func _spawn_loop():
	var total_waves = waves.size()
	
	for i in range(total_waves):
		var wave = waves[i]
		
		wave_changed.emit(i + 1, total_waves)
		wave_spawning_started.emit()
		
		# 1. CALCULATE TOTAL ENEMIES FOR THIS WAVE
		var total_enemies_in_wave = 0
		for group in wave.enemies:
			total_enemies_in_wave += group.enemy_count
			
		var enemies_spawned_so_far = 0
		
		# Initial update to set bar to 100%
		wave_progress_updated.emit(0, total_enemies_in_wave)
		
		# --- Spawning Loop ---
		for enemy_group in wave.enemies:
			var enemy_name = enemy_group.enemy_name
			if not Databases.enemies.has(enemy_name): continue 
				
			for j in range(enemy_group.enemy_count):
				_spawn_enemy(enemy_name)
				
				# 2. UPDATE PROGRESS
				enemies_spawned_so_far += 1
				wave_progress_updated.emit(enemies_spawned_so_far, total_enemies_in_wave)
				
				if enemy_group.spawn_interval > 0:
					await get_tree().create_timer(enemy_group.spawn_interval).timeout
				else:
					await get_tree().process_frame
					
		# --- Waiting Loop ---
		if i < total_waves - 1 and wave.time_until_next_wave > 0:
			await _wait_and_update_ui(wave.time_until_next_wave)
			
	is_spawning = false
	all_waves_completed.emit()

func _wait_and_update_ui(wait_time: float):
	var time_left = wait_time
	_skip_waiting = false 
	
	# Emit initial time
	time_to_next_wave_updated.emit(time_left, wait_time)
	
	while time_left > 0:
		if _skip_waiting: break
		await get_tree().create_timer(0.1).timeout
		time_left -= 0.1
		
		# UPDATED: Send both current and total time
		time_to_next_wave_updated.emit(time_left, wait_time)
	
	# Ensure we finish cleanly
	time_to_next_wave_updated.emit(0, wait_time)
	_skip_waiting = false

func _spawn_enemy(enemy_name: String):
	# (Your existing code here)
	var enemy_scene = Databases.enemies[enemy_name]
	if not enemy_scene: return
	var enemy_instance = enemy_scene.instantiate()
	get_parent().add_child.call_deferred(enemy_instance)
	var spawn_point = spawn_points.pick_random()
	if enemy_instance.has_method("set_global_position"):
		enemy_instance.set_global_position(spawn_point.global_position)
