extends Node

#LevelPlayer loads this song at the start - should be set by either TitleScreen or LevelDesigner
var musicPath = "res://Songs/rhythm_music.wav"
var beatInfoPath = "user://rhythm_music.DAT"

var minColorValue = 20
var maxColorValue = 220

var arrowColor = Color(1,1,1)
var boxColor = Color(1,1,1)
var objectColor1 = 1
var objectColor2 = 1
var objectColor3 = 1

var bgColor = Color8(0, 0, 0, 220)


func getRandomColorSet():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var randColor1 = rng.randi_range(minColorValue, maxColorValue)
	var randColor2 = rng.randi_range(minColorValue, maxColorValue)
	var randColor3 = rng.randi_range(minColorValue, maxColorValue)

	var randomizer = rng.randi_range(20, 30)

	arrowColor = Color8(randColor1, randColor2, randColor3)
	boxColor = Color8(randColor1 + randomizer, randColor2 + randomizer, randColor3 + randomizer, 150)
	objectColor1 = 255-randColor1
	objectColor2 = 255-randColor3
	objectColor3 = 255-randColor2
