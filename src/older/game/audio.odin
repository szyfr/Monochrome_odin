package game


//= Imports
import "vendor:raylib"


//= Structures
AudioSystem :: struct {
	musicFilenames	: map[string]cstring,
	soundFilenames	: map[string]cstring,

	musicCurrentName: string,
	musicCurrent	: raylib.Music,

	soundCurrentName: string,
	soundCurrent	: raylib.Sound,
}