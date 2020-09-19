extends Area2D

export (int) var type
export (Color) var color

func _ready():
	if color != null:
		$Sprite.modulate = color
	
	if type == "left":
		$Sprite.rotation_degrees = 0
	if type == "up":
		$Sprite.rotation_degrees = 90
	if type == "right":
		$Sprite.rotation_degrees = 180
		
func getCollidingArrow():
	var arr = self.get_overlapping_areas()
	$BoxBlowup.stop()
	$BoxBlowup.play("BoxBlowup")
	
	if arr.empty():
		return null
	else:
		return arr[0]
		
func showOkay():
	resetLabel($Okay)
	$OkayAnim.play("Okay")

func showGood():
	resetLabel($Good)
	$GoodAnim.play("Good")
	
func showPerfect():
	resetLabel($Perfect)
	$PerfectAnim.play("Perfect")
	
func resetLabel(label):
	pass
