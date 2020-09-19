extends Area2D

export (int) var type
export (int) var speed
export (Color) var color

func _ready():
	$Sprite.modulate = color
	
	if type == "left":
		$Sprite.rotation_degrees = 0
	if type == "up":
		$Sprite.rotation_degrees = 90
	if type == "right":
		$Sprite.rotation_degrees = 180

func _process(delta):
	self.position.y += speed * delta
	
	if self.position.y > 500:
		self.queue_free()

func die():
	$AnimationPlayer.play("Die")
	yield(get_tree().create_timer(0.25),"timeout")
	self.queue_free()
