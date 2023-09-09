package localization


//= Imports
import "vendor:raylib"

import "../system/packages"

import "../debug"


//= Procedures
load :: proc() {
	text = make(map[string]cstring, 10000)

//	packages.load_image("fuck",0)

	if !raylib.FileExists("settings.json") {
		debug.log("[WARNING] - Failed to find settings.json. Creating new.")
		//save_settings_from_default()
	}
	//load_settings_from_file()
}

close :: proc() {
	delete(text)
}