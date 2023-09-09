package system


//= Imports
import "core:bytes"
import "core:fmt"
import "core:os"
import "core:strings"
import "core:encoding/json"

import "../debug"


//= Procedures
load_json :: proc( filename : string ) -> json.Object {
	data, success := os.read_entire_file_from_filename(filename)
	if !success {
		debug.log("[ERROR] - Failed to read settings")
		return nil
	}

	value, error := json.parse(data, .JSON5)
	if error != .None {
		debug.log("[ERROR] - Failed to parse settings")
		return nil
	}

	return value.(json.Object)
}

save_json :: proc( filename : string, input : json.Object ) -> bool {
	buffer : bytes.Buffer
	
	compile_object(&buffer, input)

	output := bytes.buffer_to_bytes(&buffer)
	os.write_entire_file(filename, output)

	return true
}

compile_object :: proc( buffer : ^bytes.Buffer, object : json.Object, depth : u8 = 1 ) {
	builder : strings.Builder

	bytes.buffer_write_string(buffer, "{")

	for entry in object {
		switch in object[entry] {
			case json.Null: break
			case i64:
				bytes.buffer_write_string(buffer, "\n")
				for i in 0..<depth do bytes.buffer_write_string(buffer, "\t")
				str := fmt.sbprintf(&builder, "\"%v\":%v,", entry, object[entry].(i64))
				bytes.buffer_write_string(buffer, str)
				strings.builder_reset(&builder)
			case f64:
				bytes.buffer_write_string(buffer, "\n")
				for i in 0..<depth do bytes.buffer_write_string(buffer, "\t")
				str := fmt.sbprintf(&builder, "\"%v\":%v,", entry, object[entry].(f64))
				bytes.buffer_write_string(buffer, str)
				strings.builder_reset(&builder)
			case bool:
				bytes.buffer_write_string(buffer, "\n")
				for i in 0..<depth do bytes.buffer_write_string(buffer, "\t")
				str := fmt.sbprintf(&builder, "\"%v\":%v,", entry, object[entry].(bool))
				bytes.buffer_write_string(buffer, str)
				strings.builder_reset(&builder)
			case string:
				bytes.buffer_write_string(buffer, "\n")
				for i in 0..<depth do bytes.buffer_write_string(buffer, "\t")
				str := fmt.sbprintf(&builder, "\"%v\":\"%v\",", entry, object[entry].(string))
				bytes.buffer_write_string(buffer, str)
				strings.builder_reset(&builder)
			case json.Array:
				bytes.buffer_write_string(buffer, "\n")
				for i in 0..<depth do bytes.buffer_write_string(buffer, "\t")
				str := fmt.sbprintf(&builder, "\"%v\": ", entry)
				bytes.buffer_write_string(buffer, str)
				strings.builder_reset(&builder)
				compile_array(buffer, object[entry].(json.Array), depth + 1)
			case json.Object:
				bytes.buffer_write_string(buffer, "\n")
				for i in 0..<depth do bytes.buffer_write_string(buffer, "\t")
				str := fmt.sbprintf(&builder, "\"%v\": ", entry)
				bytes.buffer_write_string(buffer, str)
				strings.builder_reset(&builder)
				compile_object(buffer, object[entry].(json.Object), depth + 1)
		}
	}

	bytes.buffer_write_string(buffer, "\n")
	for i in 0..<depth-1 do bytes.buffer_write_string(buffer, "\t")
	bytes.buffer_write_string(buffer, "}")
	if depth != 1 do bytes.buffer_write_string(buffer, ",")
}

// TODO: Make sure Objects and Arrays inside Arrays are dealt with properly
compile_array :: proc( buffer : ^bytes.Buffer, array : json.Array, depth : u8 = 1 ) {
	builder : strings.Builder
	bytes.buffer_write_string(buffer, "[")

	for i:=0;i<len(array);i+=1 {
		if i != 0 && i != len(array) do bytes.buffer_write_string(buffer, ",")
		switch in array[i] {
			case json.Null: break
			case i64:
				str := fmt.sbprintf(&builder, "%v", array[i].(i64))
				bytes.buffer_write_string(buffer, str)
				strings.builder_reset(&builder)
			case f64:
				str := fmt.sbprintf(&builder, "%v", array[i].(f64))
				bytes.buffer_write_string(buffer, str)
				strings.builder_reset(&builder)
			case bool:
				str := fmt.sbprintf(&builder, "%v", array[i].(bool))
				bytes.buffer_write_string(buffer, str)
				strings.builder_reset(&builder)
			case string:
				str := fmt.sbprintf(&builder, "\"%v\"", array[i].(string))
				bytes.buffer_write_string(buffer, str)
				strings.builder_reset(&builder)
			case json.Array:	compile_array(buffer, array[i].(json.Array))
			case json.Object:	compile_object(buffer, array[i].(json.Object))
		}
	}

	bytes.buffer_write_string(buffer, "],")
}