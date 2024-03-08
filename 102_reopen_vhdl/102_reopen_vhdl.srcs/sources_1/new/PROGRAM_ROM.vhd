----------------------------------------------------------------------------------
-- Company: Bilkent University
-- Engineer: Emirhan Yagcioglu
-- 
-- Create Date: 03/08/2024 01:26:26 PM
-- Design Name: Program ROM main module
-- Module Name: PROGRAM_ROM - Behavioral
-- Project Name: MIDI Synthesizer
-- Target Devices: BASYS3
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

entity PROGRAM_ROM is
    Port (
        in_byte:            in std_logic_vector(7 downto 0);
        in_receiver_status: in std_logic;
        in_write_enable:    in std_logic;
        in_output_enable:   in std_logic;
        
        in_read_clk:        in std_logic;
        
        data_finished_flag: out std_logic;
        out_byte:           out std_logic_vector(7 downto 0)
    );
end PROGRAM_ROM;

architecture Behavioral of PROGRAM_ROM is

    type rom_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal rom : rom_type := (others => (others => '0'));
    -- attribute rom_sytle : string;
    -- attribute rom_sytle of rom : signal is "block";
    
    signal program_write_counter : integer range 0 to 65535 := 0;
    signal program_counter : integer range 0 to 65535 := 0;
    
    signal data_finished_flag_sig : std_logic := '0';

begin

    FLASH_DATA: process(in_receiver_status) begin
        if rising_edge(in_receiver_status) then
            if in_write_enable = '1' then
                rom(program_write_counter) <= in_byte;
                program_write_counter <= program_write_counter + 1;
            end if;
        end if;
    end process;
    
    READ_DATA: process(in_read_clk) begin
        if rising_edge(in_read_clk) then 
            if in_output_enable = '1' and data_finished_flag_sig = '0' then
                out_byte <= rom(program_counter);
                if program_counter = program_write_counter then
                    data_finished_flag_sig <= '1';
                else 
                    program_counter <= program_counter + 1;
                end if;
            end if;
        end if;
    end process;
    
    data_finished_flag <= data_finished_flag_sig;
    
end Behavioral;
