extends Node

const ARROW_BOX_SCENE = preload("res://Scenes/ArrowBox.tscn")

var song
var recordingStarted = false

var data = {}
var counter = 0
var startTime


#Used for positioning the boxes
var xPosForArrowBoxes = {
	"left" : 170,
	"up" : 240,
	"right" : 310
}
var yPosForArrowBoxes = {
	"left" : 200,
	"up" : 130,
	"right" : 200
}


func _ready():
	Global.getRandomColorSet()
	
	get_viewport().set_size(Vector2(480, 270))
	
	song = $AudioManager.setupSound(Global.musicPath)
	
	spawnArrowBoxes()
	
	$Fader.fadeIn()


func _input(event):
	var direction = null
	
	#If the recording has started
	if recordingStarted == true:
		if event.is_action_pressed("left"):
			direction = "left"
		if event.is_action_pressed("up"):
			direction = "up"
		if event.is_action_pressed("right"):
			direction = "right"
	
		if direction != null:
			data[counter] = {}
			data[counter]["direction"] = direction
			data[counter]["timestamp"] = (OS.get_ticks_msec() - startTime)
			get_node(direction).getCollidingArrow()
			
			counter += 1


	#Start the input recorder
	if event.is_action_pressed("StartRecording"): #F1
		startRecording()
		
	#Save the recorded data to a file
	if event.is_action_pressed("SaveToFile"): #F2
		saveData()


#Creates 4 boxes for each arrow type
func spawnArrowBoxes():
	createArrowBox("left")
	createArrowBox("up")
	createArrowBox("right")


#Creates an arrow box instance and sets it up using the top variables
func createArrowBox(type):
	var box = ARROW_BOX_SCENE.instance()
	box.type = type
	box.name = type
	box.color = Global.boxColor
	
	box.position.x = self.xPosForArrowBoxes[type]
	box.position.y = self.yPosForArrowBoxes[type]
	
	self.add_child(box)
	
	return box


#Starts the song and then starts tracking the players input
func startRecording():
	if song != null:
		song.play()
		recordingStarted = true
		
		data = {}
		counter = 0
		
		startTime = OS.get_ticks_msec()


#Saves the data to a specified file on the res:// directory
func saveData():
	if song != null:
		song.stop()
		recordingStarted = false
		
		var file = File.new()
		var error = file.open(Global.beatInfoPath, File.WRITE_READ)
		
		if error == OK:
			file.store_var(data)
			file.close()
			print("Save to file successful")
			$AcceptDialog.show_modal(true)
		else:
			print("Something went wrong with save")



func _on_Button_pressed():
	$Fader.fadeOut()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://Scenes/TitleScreen.tscn")
