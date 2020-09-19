extends Node2D

const MOVEMENT_SCRIPT = preload("res://Scripts/ObjectMovement.gd")
const PIXEL_SPRITE = preload("res://Art/Pixels.png")

#Frequency
var freqMin = 0.05
var freqMax = 0.05

#Direction
var xDirection = 0
var yDirection = 1

#Position
var xMinPos = 0
var xMaxPos = 1280

var yMinPos = null
var yMaxPos = null

#Speed
var xMinSpeed = 150
var xMaxSpeed = 350

var yMinSpeed = 150
var yMaxSpeed = 300

#Size
var xMinSize = 20
var xMaxSize = 250

var yMinSize = 50
var yMaxSize = 400

#Color
var minColor1 = 1
var maxColor1 = 254
var minColor2 = 1
var maxColor2 = 254
var minColor3 = 1
var maxColor3 = 254

#Opacity
var minOpacity = 10
var maxOpacity = 30

#Timer
var timer

#Randomizer
var random = RandomNumberGenerator.new()


func _ready():
	#get_viewport().set_size(Vector2(480,270))
	
	random.randomize()
	
	timer = Timer.new()
	timer.connect("timeout", self, "createObject")
	timer.wait_time = freqMin
	
	self.add_child(timer)
	
	timer.start()
	
	$Sliders/Controls/FreqMin/FreqMin.value = self.freqMin
	$Sliders/Controls/FreqMax/FreqMax.value = self.freqMax
	
	$Sliders/Controls/xMinPos/xMinPos.value = self.xMinPos
	$Sliders/Controls/xMaxPos/xMaxPos.value = self.xMaxPos
	
	if self.yMinPos != null:
		$Sliders/Controls/yMinPos/yMinPos.value = self.yMinPos
		$Sliders/Controls/yMaxPos/yMaxPos.value = self.yMaxPos
	
	$Sliders/Controls/xMinSpeed/xMinSpeed.value = self.xMinSpeed
	$Sliders/Controls/xMaxSpeed/xMaxSpeed.value = self.xMaxSpeed
	
	$Sliders/Controls/yMinSpeed/yMinSpeed.value = self.yMinSpeed
	$Sliders/Controls/yMaxSpeed/yMaxSpeed.value = self.yMaxSpeed
	
	$Sliders/Controls/xMinSize/xMinSize.value = self.xMinSize
	$Sliders/Controls/xMaxSize/xMaxSize.value = self.xMaxSize
	
	$Sliders/Controls/yMinSize/yMinSize.value = self.yMinSize
	$Sliders/Controls/yMaxSize/yMaxSize.value = self.yMaxSize
	
	$Sliders/Controls/minColor1/minColor1.value = self.minColor1
	$Sliders/Controls/maxColor1/maxColor1.value = self.maxColor1
	
	$Sliders/Controls/minColor2/minColor2.value = self.minColor2
	$Sliders/Controls/maxColor2/maxColor2.value = self.maxColor2
	
	$Sliders/Controls/minColor3/minColor3.value = self.minColor3
	$Sliders/Controls/maxColor3/maxColor3.value = self.maxColor3
	
	$Sliders/Controls/minOpacity/minOpacity.value = self.minOpacity
	$Sliders/Controls/maxOpacity/maxOpacity.value = self.maxOpacity


#Display/Hide the sliders panel
func _input(event):
	if event.is_action_pressed("ShowHideSliders"): #F1
		if $Sliders.visible == false:
			$Sliders.visible = true
		else:
			$Sliders.visible = false


#To handle the new values supplied by the sliders changing
func _process(delta):
	self.freqMin = $Sliders/Controls/FreqMin/FreqMin.value
	self.freqMax = $Sliders/Controls/FreqMax/FreqMax.value
	
	self.xMinPos = $Sliders/Controls/xMinPos/xMinPos.value
	self.xMaxPos = $Sliders/Controls/xMaxPos/xMaxPos.value
	
	if self.yMinPos != null:
		self.yMinPos = $Sliders/Controls/yMinPos/yMinPos.value
		self.yMaxPos = $Sliders/Controls/yMaxPos/yMaxPos.value
	
	self.xMinSpeed = $Sliders/Controls/xMinSpeed/xMinSpeed.value
	self.xMaxSpeed = $Sliders/Controls/xMaxSpeed/xMaxSpeed.value
	
	self.yMinSpeed = $Sliders/Controls/yMinSpeed/yMinSpeed.value
	self.yMaxSpeed = $Sliders/Controls/yMaxSpeed/yMaxSpeed.value
	
	self.xMinSize = $Sliders/Controls/xMinSize/xMinSize.value
	self.xMaxSize = $Sliders/Controls/xMaxSize/xMaxSize.value
	
	self.yMinSize = $Sliders/Controls/yMinSize/yMinSize.value
	self.yMaxSize = $Sliders/Controls/yMaxSize/yMaxSize.value
	
	self.minColor1 = $Sliders/Controls/minColor1/minColor1.value
	self.maxColor1 = $Sliders/Controls/maxColor1/maxColor1.value
	
	self.minColor2 = $Sliders/Controls/minColor2/minColor2.value
	self.maxColor2 = $Sliders/Controls/maxColor2/maxColor2.value
	
	self.minColor3 = $Sliders/Controls/minColor3/minColor3.value
	self.maxColor3 = $Sliders/Controls/maxColor3/maxColor3.value
	
	self.minOpacity = $Sliders/Controls/minOpacity/minOpacity.value
	self.maxOpacity = $Sliders/Controls/maxOpacity/maxOpacity.value


#Creates a random new object using the above variables
func createObject():
	#Timer
	var newTime = random.randf_range(freqMin, freqMax)
	timer.wait_time = newTime
	timer.start()
	
	#Position
	var newXPos
	var newYPos
	
	if xMinPos != null:
		newXPos = random.randi_range(xMinPos, xMaxPos)
	if yMinPos != null:
		newYPos = random.randi_range(yMinPos, yMaxPos)
	
	#Speed
	var newXSpeed = random.randi_range(xMinSpeed, xMaxSpeed)
	var newYSpeed = random.randi_range(yMinSpeed, yMaxSpeed)
	
	#Size
	var newXSize = random.randi_range(xMinSize, xMaxSize)
	var newYSize = random.randi_range(yMinSize, yMaxSize)
	
	#Color
	var newColor1 = random.randi_range(minColor1, maxColor1)
	var newColor2 = random.randi_range(minColor2, maxColor2)
	var newColor3 = random.randi_range(minColor3, maxColor3)
	var newOpacity = random.randi_range(minOpacity, maxOpacity)
	
	var color = Color8(newColor1, newColor2, newColor3, newOpacity)
	
	#Make the object and assign properties
	var object = Sprite.new()
	object.texture = PIXEL_SPRITE
	object.set_script(MOVEMENT_SCRIPT)
	
	object.xDirection = self.xDirection
	object.yDirection = self.yDirection
	
	if xMinPos != null:
		object.xPos = newXPos
	if yMinPos != null:
		object.yPos = newYPos
	
	object.xSpeed = newXSpeed
	object.ySpeed = newYSpeed
	
	object.xSize = newXSize
	object.ySize = newYSize
	
	object.color = color
	
	self.add_child(object)
	
	object.setupObject()
