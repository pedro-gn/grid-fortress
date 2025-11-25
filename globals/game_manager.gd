extends Node

# -- Seus preloads originais --
var game_over_screen : PackedScene = preload("res://UI/gameover_screen_ui/gameover_screen_ui.tscn")
var start_screen : PackedScene = preload("res://UI/start_screen_ui/start_screen_ui.tscn")
var main_game_scene : PackedScene = preload("res://scenes/main/main.tscn")

enum SCENES {
	MAIN,
	START,
	GAMEOVER
}

# -- Variáveis para a Transição --
var transition_layer : CanvasLayer
var color_rect : ColorRect
var transition_duration : float = 0.5 

func _ready():
	_setup_transition_layer()

func _setup_transition_layer():
	transition_layer = CanvasLayer.new()
	transition_layer.layer = 100
	add_child(transition_layer)
	
	# Cria o retângulo preto
	color_rect = ColorRect.new()
	color_rect.color = Color.BLACK
	color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	# Importante: Ignora o mouse para não bloquear cliques quando estiver transparente
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE 
	
	# Começa totalmente transparente
	color_rect.modulate.a = 0.0 
	transition_layer.add_child(color_rect)

func load_scene(new_scene_name : SCENES):
	# 1. Bloqueia interação durante a transição (opcional, mas recomendado)
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# 2. Animação de Entrada (FADE OUT - Tela fica preta)
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, transition_duration)
	
	# Espera o tween terminar antes de trocar a cena
	await tween.finished
	
	# 3. Troca a Cena (Sua lógica original)
	match new_scene_name:
		SCENES.MAIN:
			get_tree().change_scene_to_packed(main_game_scene)
		SCENES.START:
			get_tree().change_scene_to_packed(start_screen)
		SCENES.GAMEOVER:
			get_tree().change_scene_to_packed(game_over_screen)
	
	# 4. Animação de Saída (FADE IN - Tela fica transparente)
	tween = create_tween() # Cria um novo tween
	tween.tween_property(color_rect, "modulate:a", 0.0, transition_duration)
	
	await tween.finished
	
	# 5. Libera o mouse novamente
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
