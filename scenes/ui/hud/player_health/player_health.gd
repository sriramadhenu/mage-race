extends Control

@export var max_hearts: int = 5
@export var heart_scene: PackedScene

var hearts: Array = []
var current_hp: int


func _ready():
	GameManager.player_health_changed.connect(_on_player_health_changed)
	GameManager.player_died.connect(_on_player_died)
	max_hearts = GameManager.max_health
	current_hp = max_hearts
	
	create_hearts()
	update_display(current_hp)
	apply_low_health_effect()


func _on_player_health_changed(new_health: int):
	var hearts_to_show = ceili(float(new_health))
	set_health(hearts_to_show)


func _on_player_died():
	# Show all hearts empty
	set_health(0)
	
	
func create_hearts():
	# free hearts if any exist
	for c in $Hearts.get_children():
		c.queue_free()

	hearts.clear()
	
	# create new hearts
	for i in range(max_hearts):
		var h = heart_scene.instantiate()
		$Hearts.add_child(h)
		hearts.append(h)


func update_display(hp: int):
	for i in range(hearts.size()):
		hearts[i].set_full(i < hp)


func set_health(new_hp: int):
	current_hp = clamp(new_hp, 0, max_hearts)
	update_display(current_hp)
	apply_low_health_effect()


func set_max_health(new_max: int):
	max_hearts = new_max
	create_hearts()
	update_display(current_hp)
	apply_low_health_effect()


func apply_low_health_effect():
	for h in hearts:
		h.stop_low_health_pulse()

	if current_hp == 1:
		hearts[0].start_low_health_pulse()


# testing function. delete soon.
# Press H to delete heart. Press J to increase heart. Press R to restore to full health.
#func _input(event):
	#if event is InputEventKey and event.pressed:
		#if event.keycode == KEY_H:
			#set_health(current_hp - 1)
#
		#if event.keycode == KEY_J:
			#set_health(current_hp + 1)
#
		#if event.keycode == KEY_R:
			#set_health(max_hearts)
