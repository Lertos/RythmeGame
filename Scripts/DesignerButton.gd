extends Button

var musicPath
var beatFilePath

func _on_Button_pressed():
	Global.musicPath = musicPath
	Global.beatInfoPath = beatFilePath
	
	get_node("/root/TitleScreen/Fader").fadeOut()
	yield(get_tree().create_timer(1), "timeout")
	
	get_tree().change_scene("res://Scenes/LevelDesigner.tscn")

func setLabelText(text):
	$Label.text = text
