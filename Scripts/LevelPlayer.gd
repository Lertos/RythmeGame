extends Node

const ARROW_SCENE = preload("res://Scenes/Arrow.tscn")
const ARROW_BOX_SCENE = preload("res://Scenes/ArrowBox.tscn")

var arrowSpriteSize = 50

#From the middle of the box - how far out is considered an X hit
#Each is only half of the total range as it spreads in the - and + direction
var goodTolerance = arrowSpriteSize * 0.25
var perfectTolerance = arrowSpriteSize * 0.075

#Postioning for both axis for arrows and boxes
var yPosForArrow = -(arrowSpriteSize/2)
var yPosForArrowBoxes = 205

var xPosForArrow = {
	"left" : 165,
	"up" : 241,
	"right" : 317
}

#The time in which the arrows should fall (in ms)
var timeToFall = 2000

#The time to wait at the start as starting the song adds a slight delay (in ms)
var timeToWaitInitially = 225

#Holds the nodes of each box type
var boxes = {}

#Scoring variables
var okayBeats = 0
var goodBeats = 0
var perfectBeats = 0

#The song that is pulled from the Global.gd script
var song

#Beat information (direction, timestamp)
var data = {}

#Compare the counter with counterMax to see the end of the data dictonary 
var counterMax
var counter = 1

#Used to calculate the elapsed time after the song starts
var startTime = null

#Track the current next timestamp and direction from our song data
var nextBeatTime
var nextBeatDir


func _ready():
	Global.getRandomColorSet()
	$Background/Rect.modulate = Global.bgColor
	
	get_viewport().set_size(Vector2(480, 270))

	self.song = $AudioManager.setupSound(Global.musicPath)
	
	#Load the data from the music track selected
	loadData()

	#Spawn arrow boxes
	spawnArrowBoxes()

	#Wait 3 seconds as that's the time we want the arrows to fall before they reach the arrow boxes
	yield(get_tree().create_timer(timeToFall/1000), "timeout")

	#Start the song
	song.play()
	
	#Initialize the start time
	startTime = OS.get_ticks_msec() - self.timeToWaitInitially
	
	#Get the initial beat to spawn
	var nextBeat = data[0]
	self.nextBeatTime = nextBeat["timestamp"]
	self.nextBeatDir = nextBeat["direction"]

	$Fader.fadeIn()


#Handles input
func _input(event):
	var dir = null
	
	if event.is_action_pressed("left"):
		dir = "left"
	if event.is_action_pressed("up"):
		dir = "up"
	if event.is_action_pressed("right"):
		dir = "right"
	
	if(dir != null):
		var collidingArrow = boxes[dir].getCollidingArrow()
		
		if collidingArrow != null:
			getScore(collidingArrow, boxes[dir])
		
			collidingArrow.die()


func _process(delta):
	if self.startTime != null:
		#Check if the elapsed time is bigger than the next time stamp - if so, create an arrow
		if (OS.get_ticks_msec() - self.startTime) > (self.nextBeatTime - self.timeToFall) :
			if counter < counterMax:
				createArrow()
			
				var nextBeat = data[counter]
				self.nextBeatTime = nextBeat["timestamp"]
				self.nextBeatDir = nextBeat["direction"]
				
				counter += 1
			else:
				calculateScore()
				self.startTime = null


#Calculates the difference of the Y position of the arrow and the box's colliders
func getScore(arrow, box):
	var arrowPosY = arrow.position.y
	var boxPosY = box.position.y
	var difference = abs(arrowPosY - boxPosY)
	
	if difference < self.perfectTolerance:
		box.showPerfect()
		self.perfectBeats += 1
	elif difference < self.goodTolerance:
		box.showGood()
		self.goodBeats += 1
	else:
		box.showOkay()
		self.okayBeats += 1


#Creates 4 boxes for each arrow type
func spawnArrowBoxes():
	boxes["left"] = createArrowBox("left")
	boxes["up"] = createArrowBox("up")
	boxes["right"] = createArrowBox("right")


#Creates an arrow box instance and sets it up using the top variables
func createArrowBox(type):
	var box = ARROW_BOX_SCENE.instance()
	box.type = type
	box.color = Global.boxColor
	
	box.position.x = self.xPosForArrow[type]
	box.position.y = self.yPosForArrowBoxes
	
	self.add_child(box)
	
	return box


#Creates a new arrow and sets the type and speed - which is handled in the arrow scene
func createArrow():
	var arrow = ARROW_SCENE.instance()
	arrow.type = self.nextBeatDir
	arrow.speed = (yPosForArrowBoxes/(timeToFall/1000))
	arrow.color = Global.arrowColor
	
	self.add_child(arrow)
	
	arrow.position.x = self.xPosForArrow[self.nextBeatDir]
	arrow.position.y = self.yPosForArrow


func calculateScore():
	var totalScore = 0
	var totalBeats = self.counterMax
	
	var hitBeats = (self.okayBeats + self.goodBeats + self.perfectBeats)
	
	totalScore += self.okayBeats * 25
	totalScore += self.goodBeats * 50
	totalScore += self.perfectBeats * 100
	
	while song.playing == true:
		yield(get_tree().create_timer(1), "timeout")
	
	yield(get_tree().create_timer(1), "timeout")
	
	$ScoreScreen.setScoreValues(totalScore, totalBeats, hitBeats, self.okayBeats, self.goodBeats, self.perfectBeats)
	$Fader.fadeOut()
	yield(get_tree().create_timer(1), "timeout")
	$Fader.fadeIn()
	$ScoreScreen.visible = true

#Initially loads the beat information from the save file
func loadData():
	var file = File.new()
	var path = Global.beatInfoPath
	if file.file_exists(path):
		var error = file.open(path, File.READ)
		if error == OK:
			data = file.get_var()
			counterMax = data.size()
			file.close()
			#print(data)


func _on_Button_pressed():
	$Fader.fadeOut()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://Scenes/TitleScreen.tscn")
