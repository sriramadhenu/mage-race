extends PointLight2D

var glowing: bool = true

func _process(delta) -> void:
	if glowing:
		energy += 0.5 * delta
		if energy > 1.0:
			energy = 1.0
			glowing = false
	else:
		energy -= 0.5 * delta
		if energy < 0.0:
			energy = 0.0
			glowing = true
