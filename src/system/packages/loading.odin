package packages


//= Imports
import "core:fmt"
import "core:bytes"
import "core:os"

import "vendor:raylib"

import "../../debug"


//= Procedures
load_image :: proc( filename : string, id : u32 ) -> raylib.Image {
	image : raylib.Image = {}

	create_test(filename)

	file, ok := os.read_entire_file_from_filename(filename)
	if !ok {
		debug.logf("[ERROR] - Failed to load package '%v'.", filename)
		return {}
	}
//	fmt.printf("%v:%v\n",ok,file)

//	image.width  = i32(file[0])
//	image.height = i32(file[1])
//	image.mipmaps = i32(file[2])
//	image.format = raylib.PixelFormat(file[3])
//
//	array : bytes.Buffer
//
//	for i:i32=0;i<image.width*image.height;i+=1 do bytes.buffer_write_byte(&array, file[i+4])
//	image.data = raw_data(bytes.buffer_to_bytes(&array))
	image = raylib.LoadImageFromMemory(".png", raw_data(file[2:]), i32(file[0])*i32(file[1]))
	

	return image
}

create_test :: proc( filename : string ) {
	image := raylib.LoadImage("data/core/sprites/arrow.png")
//
//	ref : [^]raylib.Color = ([^]raylib.Color)(image.data)
//
//	buffer : bytes.Buffer
//
//	bytes.buffer_write_byte(&buffer, u8(image.width))
//	bytes.buffer_write_byte(&buffer, u8(image.height))
//	bytes.buffer_write_byte(&buffer, u8(image.mipmaps))
//	bytes.buffer_write_byte(&buffer, u8(image.format))
//
//	for i:i32=0;i<image.width*image.height;i+=1 {
//		bytes.buffer_write_byte(&buffer, ref[i].r)
//		bytes.buffer_write_byte(&buffer, ref[i].g)
//		bytes.buffer_write_byte(&buffer, ref[i].b)
//		bytes.buffer_write_byte(&buffer, ref[i].a)
//	}
//
//	output := bytes.buffer_to_bytes(&buffer)
//	os.write_entire_file("data/testSprites.mon", output)

	file, ok := os.read_entire_file_from_filename("data/core/sprites/arrow.png")
	buffer : bytes.Buffer
	bytes.buffer_write_byte(&buffer, u8(image.width))
	bytes.buffer_write_byte(&buffer, u8(image.height))
	for i:=0;i<len(file);i+=1 do bytes.buffer_write_byte(&buffer, file[i])

	os.write_entire_file("data/testSprites.mon", bytes.buffer_to_bytes(&buffer))
}