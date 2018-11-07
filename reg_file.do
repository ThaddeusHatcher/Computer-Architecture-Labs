# Starting reg_file simulation
add wave -position insertpoint \
sim:/reg_file/data_in \ 
sim:/reg_file/readnotwrite \
sim:/reg_file/clock \
sim:/reg_file/reg_number \
sim:/reg_file/data_out \

-- Test write to each of 32 registers (0, 32) dec -> (0x00, 0x20) hex
force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000000 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000001 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000002 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000003 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000004 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000005 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000006 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000007 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000008 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000009 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h0000000A 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h0000000B 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h0000000C 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h0000000D 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h0000000E 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h0000000F 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000010 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000011 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000012 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000013 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000014 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000015 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000016 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000017 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000018 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000019 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h0000001A 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h0000001B 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h0000001C 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h0000001D 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h0000001E 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h0000001F 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 0
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000020 0
run 50 ns


-- Test read from each of 32 registers (0, 32) dec -> (0x00, 0x20) hex

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000000 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000001 0
run 50 ns
 
force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000002 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000003 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000004 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000005 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000006 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000007 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000008 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000009 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h0000000A 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h0000000B 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h0000000C 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h0000000D 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h0000000E 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h0000000F 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000010 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000011 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000012 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000013 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000014 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000015 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000016 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000017 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000018 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000019 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h0000001A 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h0000001B 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h0000001C 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h0000001D 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h0000001E 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h0000001F 0
run 50 ns

force -freeze sim:/reg_file/data_in 32'h00AAAAAA 0 
force -freeze sim:/reg_file/readnotwrite 1
force -freeze sim:/reg_file/clock 0
force -freeze sim:/reg_file/reg_number 4'h00000020 0
run 50 ns