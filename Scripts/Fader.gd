extends Node2D

func fadeIn():
	$AnimationPlayer.play("FadeIn")
	yield(get_tree().create_timer(1), "timeout")
	self.visible = false

func fadeOut():
	self.visible = true
	$AnimationPlayer.play("FadeOut")
