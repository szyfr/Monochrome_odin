package audio


//= Imports
import "core:fmt"
import "core:strings"

import "vendor:raylib"

import "../../../game"


//= Procedures
init :: proc() {
	game.audio = new(game.AudioSystem)

	raylib.InitAudioDevice()
	raylib.SetMasterVolume(game.masterVolume)

	musicCount	: i32 = 0
	musicList	:= raylib.GetDirectoryFiles("data/audio/music", &musicCount)

	for i in 2..<musicCount {
		str := strings.clone_from_cstring(musicList[i])
		value := strings.concatenate({"data/audio/music/",str})

		str, _ = strings.remove_all(str, "aud_")
		str, _ = strings.remove_all(str, ".wav")
		game.audio.musicFilenames[str] = strings.clone_to_cstring(value)
	}

	raylib.ClearDirectoryFiles()
	soundCount	: i32 = 0
	soundList	:= raylib.GetDirectoryFiles("data/audio/sfx", &soundCount)

	for i in 2..<soundCount {
		str := strings.clone_from_cstring(soundList[i])
		value := strings.concatenate({"data/audio/sfx/",str})

		str, _ = strings.remove_all(str, "sfx_")
		str, _ = strings.remove_all(str, ".wav")
		game.audio.soundFilenames[str] = strings.clone_to_cstring(value)
	}
}

close :: proc() {
	raylib.UnloadMusicStream(game.audio.musicCurrent)
	raylib.UnloadSound(game.audio.soundCurrent)
	raylib.CloseAudioDevice()
}

play_music :: proc(
	name : string,
	pitch : f32 = 1,
) {
	if name == game.audio.musicCurrentName && raylib.IsMusicStreamPlaying(game.audio.musicCurrent) do return
	if game.audio.musicCurrent.buffer != nil do raylib.UnloadMusicStream(game.audio.musicCurrent)

	game.audio.musicCurrentName = name
	game.audio.musicCurrent = raylib.LoadMusicStream(game.audio.musicFilenames[name])
	game.audio.musicCurrent.looping = true

	raylib.PlayMusicStream(game.audio.musicCurrent)
	raylib.SetMusicPitch(game.audio.musicCurrent, pitch)
	raylib.SetMusicVolume(game.audio.musicCurrent, game.musicVolume)
}

play_sound :: proc(
	name : string,
	pitch : f32 = 1,
) {
	if name == game.audio.soundCurrentName && raylib.IsSoundPlaying(game.audio.soundCurrent) do return
	if game.audio.soundCurrent.buffer != nil do raylib.UnloadSound(game.audio.soundCurrent)

	game.audio.soundCurrentName = name
	game.audio.soundCurrent = raylib.LoadSound(game.audio.soundFilenames[name])
	raylib.PlaySound(game.audio.soundCurrent)
	raylib.SetSoundPitch(game.audio.soundCurrent, pitch)
	raylib.SetSoundVolume(game.audio.soundCurrent, game.soundVolume)
}