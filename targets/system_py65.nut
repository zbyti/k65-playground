
output_file_name <- "data.bin"
low_addr <- 0x0200
high_addr <- 0xFFFF


function opt_lowaddr(cmd)
{
	if( !parse_isint() )
		error("Address argument missing")
	local addr = parse_int();
	if( addr<0 || addr>=0xFFFF )
		error("Address outside 0x0000..0xFFFF range")
	low_addr = addr;
}
OPTIONS.lowaddr <- opt_lowaddr

function opt_hiaddr(opt)
{
	if( !parse_isint() )
		error("Address argument missing")
	local addr = parse_int();
	if( addr<0 || addr>=0xFFFF )
		error("Address outside 0x0000..0xFFFF range")
	high_addr = addr;
}

OPTIONS.hiaddr <- opt_hiaddr


// creates a bank with default parameters
function link_create_bank(name)
{
	local bnum = bank_count();

	if( bnum>0 )
		error("Py65 supports only single bank");

	bank_create( name, 1, low_addr, high_addr, 0 );
}

// executed in linker just after initializing all other sections
function link_make_sections()
{
	// generate start
	as <- sec_entrypoint()
	sec_set_fixaddr(as,low_addr)
	sec_set_referenced(as,1)
}

// write final binary to file
function link_write_binary(path)
{
	bin_fopen_wb(path);

	local bstart = bank_get_start(0);
	local bsize = bank_get_last_used_byte(0)+1 - bstart;

	bin_emit(0, 0, 256 * 2);
	bin_emit(0,bstart,bsize);
	bin_fclose();
}
