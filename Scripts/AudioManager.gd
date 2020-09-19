extends Node

func setupSound(path):
	var audioPlayer = AudioStreamPlayer.new()
	
	var stream = load(path)
	audioPlayer.set_stream(stream)
	
	self.add_child(audioPlayer)
	
	return audioPlayer
