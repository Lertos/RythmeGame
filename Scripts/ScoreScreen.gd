extends Node2D

func setScoreValues(score, total, hit, okay, good, perfect):
	$OuterContainer/ScoreContainer/ScoreLabel.text = str(score)
	$OuterContainer/BeatsHitContainer/BeatsHitLabel.text = str(str(hit) + " / " + str(total))
	
	$OuterContainer/OkayContainer/OkayLabel.text = str(okay)
	$OuterContainer/GoodContainer/GoodLabel.text = str(good)
	$OuterContainer/PerfectContainer/PerfectLabel.text = str(perfect)

func _on_ScoreButton_pressed():
	$Fader.fadeOut()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://Scenes/TitleScreen.tscn")
