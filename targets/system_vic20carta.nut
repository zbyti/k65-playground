output_file_name <- "program.crt"
low_addr <- 0xA009
high_addr <- 0xBFFF
intro_mode <- 0

// creates a bank with default parameters
function link_create_bank(name)
{
	local bnum = bank_count();

	if( bnum>0 )
		error("VIC-20 supports only single bank");

	bank_create( name, 1, low_addr, high_addr, 0 );
}

function set_intro_mode(cmd)
{
	intro_mode = 1; 
}
OPTIONS.intro <- set_intro_mode

// executed in linker just after initializing all other sections
function link_make_sections()
{
	// generate start
	if( intro_mode )
	{
		as <- sec_entrypoint()
		sec_set_fixaddr(as,low_addr)
		sec_set_referenced(as,1)
	}
	else
	{
		as <- sec_create()
		sec_set_name(as,"__start")
		sec_set_type(as,"system")
		sec_set_fixaddr(as,low_addr)
		sec_add_bank(as,"main")
		sec_asm(as,"    JMP		main");
		sec_set_referenced(as,1)
		sec_init(as)
	}
}

// write final binary to file
function link_write_binary(path)
{
	bin_fopen_wb(path);

	local nbanks = bank_count();

	if( nbanks!=1 )
		error("VIC-20 supports only single bank");

	local bstart = bank_get_start(0);

	bin_write_word(low_addr);
  bin_write_word(low_addr);
	bin_write_word(0x3041);
	bin_write_word(0xC2C3);
	bin_write_byte(0xCD);
	bin_emit(0,bstart,1024*8-9);

	bin_fclose();
}
