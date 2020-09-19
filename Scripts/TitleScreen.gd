extends Control

const BUTTON_SCENE = preload("res://Scenes/Button.tscn")
const DESIGNER_BUTTON_SCENE = preload("res://Scenes/DesignerButton.tscn")


func _ready():
	get_viewport().set_size(Vector2(1280, 720))
	
	$Fader.fadeIn()

func _on_Play_pressed():
	$Fader.fadeOut()
	yield(get_tree().create_timer(1), "timeout")
	$Fader.fadeIn()
	
	getListOfSongs(false)


func _on_Design_pressed():
	$Fader.fadeOut()
	yield(get_tree().create_timer(1), "timeout")
	$Fader.fadeIn()
	
	getListOfSongs(true)

#Finds all .wav files in the Songs directory and sends the array of song names to be made into buttons
func getListOfSongs(isDesigner):
	var dir = Directory.new()
	var path = "res://Songs/"
	var songs = []
	
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				if (".import" in file_name):
					var songName = file_name.split(".")[0]
					songs.append(songName)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	if isDesigner == true:
		createButtons(path, songs, true)
	else:
		createButtons(path, songs, false)
	

#Takes each song name and makes buttons of them - with the proper links as well
func createButtons(path, songs, isDesigner):
	for i in range(songs.size()):
		var labelText = songs[i]
		var musicPath = path + songs[i] + ".wav"
		var beatFilePath = "res://Data/" + songs[i] + ".DAT"
		
		var button
		
		if isDesigner == true:
			button = DESIGNER_BUTTON_SCENE.instance()
		else:
			button = BUTTON_SCENE.instance()
			
		button.musicPath = musicPath
		button.beatFilePath = beatFilePath
		button.setLabelText(labelText)
		
		$SongSelect.add_child(button)
	
	$MainMenu.visible = false
	$SongSelect.visible = true
	

func _on_ExitGame_pressed():
	$Fader.fadeOut()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().quit()
