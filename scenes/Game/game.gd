extends Control

@onready var game_over_screen: GameOverScreen = $GameOver

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(Constants.COLORS.background))
	
	game_over_screen.restart_clicked.connect(handle_restart_clicked)
	
	State.game_over.connect(handle_game_over)

func handle_game_over() -> void:
	game_over_screen.set_stats(State.curr_round, State.score)
	game_over_screen.visible = true
	
	var initial_position: Vector2 = game_over_screen.position
	
	var t: Tween = create_tween()
	
	t.tween_property(game_over_screen, "position", initial_position, 0.5).from(initial_position - Vector2(0, 100))
	t.parallel().tween_property(game_over_screen, "modulate:a", 1, 0.5).from(0)

func handle_restart_clicked() -> void:
	game_over_screen.visible = false
	State.init()
