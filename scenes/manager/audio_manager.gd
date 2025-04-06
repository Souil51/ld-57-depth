extends Node

enum Sounds { ACHAT, ALARM, DECHET, DEFAITE, DETECTION, RANDOM_1, RANDOM_2, RISE, SKIP, START, THROW, TRESOR_1, TRESOR_2, TRESOR_3 }

var sound_files = [
	"res://assets/sound/new_song.wav"
]

var dic_sound = {
	Sounds.ACHAT: "res://assets/fx/achat.wav",
	Sounds.ALARM: "res://assets/fx/alarm.wav",
	Sounds.DECHET: "res://assets/fx/dechet.wav",
	Sounds.DEFAITE: "res://assets/fx/defaite.wav",
	Sounds.DETECTION: "res://assets/fx/detection.wav",
	Sounds.RANDOM_1: "res://assets/fx/random_1.wav",
	Sounds.RANDOM_2: "res://assets/fx/random_2.wav",
	Sounds.RISE: "res://assets/fx/rise.wav",
	Sounds.SKIP: "res://assets/fx/skip.wav",
	Sounds.START: "res://assets/fx/start.wav",
	Sounds.THROW: "res://assets/fx/throw.wav",
	Sounds.TRESOR_1: "res://assets/fx/tresor_1.wav",
	Sounds.TRESOR_2: "res://assets/fx/tresor_2.wav",
	Sounds.TRESOR_3: "res://assets/fx/tresor_3.wav"
}

func play_sound(player: AudioStreamPlayer , sound: Sounds, volume: float = 0) -> void:
	## Load the audio stream from the given file path
	var audio_stream = load(dic_sound[sound]) as AudioStream
	if audio_stream:
		player.stream = audio_stream
		player.volume_db = volume
		player.play()
	else:
		print("Error: Could not load sound file: ", sound)
