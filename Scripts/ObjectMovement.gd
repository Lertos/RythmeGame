extends Node

#Direction
var xDirection
var yDirection

#Position
var xPos
var yPos

#Speed
var xSpeed
var ySpeed

#Size
var xSize
var ySize

#Color
export (Color) var color

var isReady = false


func setupObject():
	self.scale.x = xSize
	self.scale.y = ySize
	
	if xPos != null:
		self.global_position.x = xPos
	else:
		self.global_position.x = -self.scale.x
		
	if yPos != null:
		self.global_position.y = yPos
	else:
		self.global_position.y = -self.scale.y
		
	self.modulate = color
	
	isReady = true


func _process(delta):
	if isReady == true:
		self.global_position.x += xDirection * xSpeed * delta
		self.global_position.y += yDirection * ySpeed * delta
	if outsideRange() == true:
		self.queue_free()

func outsideRange():
	#Check x boundaries
	if self.xDirection != 0:
		if self.xDirection > 0:
			if self.global_position.x > (get_viewport().get_size().x + self.scale.x):
				return true
		else:
			if self.global_position.x < (0 - self.scale.x):
				return true
	#Check y boundaries
	if self.yDirection != 0:
		if self.yDirection > 0:
			if self.global_position.y > (get_viewport().get_size().y + self.scale.y):
				return true
		else:
			if self.global_position.y < (0 - self.scale.y):
				return true
