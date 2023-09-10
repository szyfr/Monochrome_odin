package packages


//= Imports


//= Structures
FileHeader :: struct {
	signature	: [4]u8,
	version		: u16,
	chunkCount	: u16,
	reserved	: u64,
}

ChunkInfo :: struct {
	type			: DataType,
	id				: u32,
	compressionType : CompressionType,
	encodingType	: EncodingType,
	flags			: u16,
	packedSize		: u32,
	baseSize		: u32,
	reserved		: u64,
}

DataType :: enum u8 {
	empty,
	raw,
	image,
	json,
	model,
	wave,

	// TODO
}

CompressionType :: enum u8 {
	none,
	deflate,

	// TODO
}
EncodingType :: enum u8 {
	none,
	base64,

	// TODO
}