----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/31/2025 10:59:06 AM
-- Design Name: 
-- Module Name: memory - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity memory is
port (  
                  address: in std_logic_vector(7 downto 0);  
                  data_in: in std_logic_vector(7 downto 0);  
                  write: in std_logic;  
                  port_in_00: in std_logic_vector(7 downto 0);   
      port_in_01: in std_logic_vector(7 downto 0);  
      port_in_02: in std_logic_vector(7 downto 0);    
      port_in_03: in std_logic_vector(7 downto 0);   
      port_in_04: in std_logic_vector(7 downto 0);   
      port_in_05: in std_logic_vector(7 downto 0);   
      port_in_06: in std_logic_vector(7 downto 0);   
      port_in_07: in std_logic_vector(7 downto 0);   
      port_in_08: in std_logic_vector(7 downto 0);   
      port_in_09: in std_logic_vector(7 downto 0);  
      port_in_10: in std_logic_vector(7 downto 0);   
      port_in_11: in std_logic_vector(7 downto 0);   
      port_in_12: in std_logic_vector(7 downto 0);   
      port_in_13: in std_logic_vector(7 downto 0);   
      port_in_14: in std_logic_vector(7 downto 0);    
      port_in_15: in std_logic_vector(7 downto 0);  
                  clock,reset: in std_logic;  
                  data_out: out std_logic_vector(7 downto 0);  
      port_out_00: out std_logic_vector(7 downto 0);   
      port_out_01: out std_logic_vector(7 downto 0);  
      port_out_02: out std_logic_vector(7 downto 0);    
      port_out_03: out std_logic_vector(7 downto 0);   
      port_out_04: out std_logic_vector(7 downto 0);   
      port_out_05: out std_logic_vector(7 downto 0);   
      port_out_06: out std_logic_vector(7 downto 0);   
      port_out_07: out std_logic_vector(7 downto 0);   
      port_out_08: out std_logic_vector(7 downto 0);   
      port_out_09: out std_logic_vector(7 downto 0);  
      port_out_10: out std_logic_vector(7 downto 0);   
      port_out_11: out std_logic_vector(7 downto 0);   
      port_out_12: out std_logic_vector(7 downto 0);   
      port_out_13: out std_logic_vector(7 downto 0);   
      port_out_14: out std_logic_vector(7 downto 0);    
      port_out_15: out std_logic_vector(7 downto 0)  
           ); 
end memory;

architecture Behavioral of memory is

 component rom_128x8_sync   
 port (  
                address: in std_logic_vector(6 downto 0);  
                data_out: out std_logic_vector(7 downto 0);  
                clock: in std_logic  
           );  
 end component rom_128x8_sync; 
 
 component rw_96x8_sync   
 port(  
                address: in std_logic_vector(6 downto 0);  
                data_in: in std_logic_vector(7 downto 0);  
                write: in std_logic;  
                clock: in std_logic;  
                data_out: out std_logic_vector(7 downto 0)  
           );  
 end component rw_96x8_sync;
 
 component Output_Ports   
 port (  
                address: in std_logic_vector(3 downto 0);  
                data_in: in std_logic_vector(7 downto 0);  
                write: in std_logic;  
                clock: in std_logic;  
                reset: in std_logic;  
      port_out_00: out std_logic_vector(7 downto 0);   
      port_out_01: out std_logic_vector(7 downto 0);  
      port_out_02: out std_logic_vector(7 downto 0);    
      port_out_03: out std_logic_vector(7 downto 0);   
      port_out_04: out std_logic_vector(7 downto 0);   
      port_out_05: out std_logic_vector(7 downto 0);   
      port_out_06: out std_logic_vector(7 downto 0);   
      port_out_07: out std_logic_vector(7 downto 0);   
      port_out_08: out std_logic_vector(7 downto 0);   
      port_out_09: out std_logic_vector(7 downto 0);  
      port_out_10: out std_logic_vector(7 downto 0);   
      port_out_11: out std_logic_vector(7 downto 0);   
      port_out_12: out std_logic_vector(7 downto 0);   
      port_out_13: out std_logic_vector(7 downto 0);   
      port_out_14: out std_logic_vector(7 downto 0);    
      port_out_15: out std_logic_vector(7 downto 0)  
           ); 
end component Output_Ports;

 signal rom_out,ram_out:std_logic_vector(7 downto 0);  
 signal output_port_addr: std_logic_vector(3 downto 0);  
 signal ram_address,rom_address: std_logic_vector(6 downto 0); 
 signal ram_write,port_write: std_logic;
 
begin  


    -- RAM only from 0x80 to 0xDF; output ports only from 0xE0 to 0xEF
    ram_address <= address(6 downto 0) when (address >= x"80" and address < x"E0") else  
                                "0000000";  
    ram_write   <= write when (address >= x"80" and address < x"E0") else '0';
    port_write  <= write when (address(7 downto 4) = x"E") else '0';
    rom_address <= address(6 downto 0) when (address(7)='0') else  
                                "0000000";  
    output_port_addr <= address(3 downto 0) when (address(7 downto 4)= x"E") else  
                                "0000";  
                                
                                
    rom_128x8_sync_u: rom_128x8_sync port map  
                     (  
                          address => rom_address,  
                          clock  => clock,  
                          data_out => rom_out  
                     );  
                     
    rw_96x8_sync_u: rw_96x8_sync port map   
                     (  
                          address  => ram_address,  
                          data_in  => data_in,  
                          write    => ram_write,  
                          clock    => clock,  
                          data_out => ram_out  
                     );  
                     
    Output_Ports_u: Output_Ports port map  
                     (  
                          address  => output_port_addr,  
                          data_in  => data_in,  
                          write    => port_write,  
                          clock    => clock,  
                          reset    => reset,  
                          port_out_00 => port_out_00,  
                          port_out_01 => port_out_01,  
                          port_out_02 => port_out_02,  
                          port_out_03 => port_out_03,   
                          port_out_04 => port_out_04,  
                          port_out_05 => port_out_05,  
                          port_out_06 => port_out_06,  
                          port_out_07 => port_out_07,  
                          port_out_08 => port_out_08,  
                          port_out_09 => port_out_09,  
                          port_out_10 => port_out_10,  
                          port_out_11 => port_out_11,  
                          port_out_12 => port_out_12,  
                          port_out_13 => port_out_13,  
                          port_out_14 => port_out_14,   
                          port_out_15 => port_out_15  
                     );    
                     
                     
       --- Multiplexer Output  
    data_out <= rom_out when address < x"80" else  
                          ram_out when address < x"E0" else  
                          port_in_00 when address = x"F0" else  
                          port_in_01 when address = x"F1" else  
                          port_in_02 when address = x"F2" else  
                          port_in_03 when address = x"F3" else  
                          port_in_04 when address = x"F4" else  
                          port_in_05 when address = x"F5" else  
                          port_in_06 when address = x"F6" else  
                          port_in_07 when address = x"F7" else  
                          port_in_08 when address = x"F8" else  
                          port_in_09 when address = x"F9" else  
                          port_in_10 when address = x"FA" else  
                          port_in_11 when address = x"FB" else  
                          port_in_12 when address = x"FC" else  
                          port_in_13 when address = x"FD" else  
                          port_in_14 when address = x"FE" else  
                          port_in_15 when address = x"FF" else  
                          x"00";                                  
                     
end Behavioral;
