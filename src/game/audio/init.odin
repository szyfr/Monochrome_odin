package audio


//= Imports
import "core:fmt"
import "core:strings"

import "vendor:raylib"

import "../../game"


//= Procedures
init :: proc() {
	game.audio = new(game.AudioSystem)

	raylib.InitAudioDevice()
	raylib.SetMasterVolume(game.masterVolume)

	musicList := raylib.LoadDirectoryFiles("data/private/audio/music")

	for i in 0..<musicList.count {
		str := strings.clone_from_cstring(musicList.paths[i])
		value := str

		str, _ = strings.remove_all(str, ".wav")
		str, _ = strings.remove_all(str, "data/private/audio/music/")
		game.audio.musicFilenames[str] = strings.clone_to_cstring(value)
	}

	raylib.UnloadDirectoryFiles(musicList)
	soundList := raylib.LoadDirectoryFiles("data/private/audio/sfx")

	for i in 0..<soundList.count {
		str := strings.clone_from_cstring(soundList.paths[i])
		value := str

		str, _ = strings.remove_all(str, ".wav")
		str, _ = strings.remove_all(str, "data/private/audio/sfx/")
		game.audio.soundFilenames[str] = strings.clone_to_cstring(value)
	}

	raylib.UnloadDirectoryFiles(soundList)
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