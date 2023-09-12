package localization


//= Imports
import "core:fmt"
import "core:os"
import "core:strings"
import "core:reflect"
import "core:encoding/json"

import "vendor:raylib"

import "../settings"
import "../debug"


//= Procedures
load :: proc() {
	text = make(map[string]cstring, 10000)

	builder : strings.Builder
	str := fmt.sbprintf(&builder, "data/localization/%v.json", reflect.enum_string(settings.language))

	if !os.is_file(str) {
		debug.logf("[WARNING] - Failed to find '%v'.", str)
		return
	}
	
	file, _ := os.read_entire_file(str)
	fileJson, _ := json.parse(file)

	for obj in fileJson.(json.Object) do text[strings.clone(obj)] = strings.clone_to_cstring(fileJson.(json.Object)[obj].(string))

	json.destroy_value(fileJson)
	delete(file)
}

close :: proc() {
	for obj in text do delete_key(&text, obj)

	delete(text)
}