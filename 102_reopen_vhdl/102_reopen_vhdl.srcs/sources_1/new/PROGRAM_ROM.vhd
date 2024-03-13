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
    generic (
        P_ROM_size:         integer := 262144 -- 256KB Program ROM
    );
    port (
        -- clock
        in_clk:             in std_logic;
        -- address line
        in_address:         in integer range 0 to (P_ROM_size - 1);
        -- parallel data line
        inout_byte:         inout std_logic_vector(7 downto 0);
        -- chip control inputs
        in_chip_enable:     in std_logic;
        in_write_enable:    in std_logic;
        in_output_enable:   in std_logic
    );
end PROGRAM_ROM;

architecture Behavioral of PROGRAM_ROM is

    type rom_type is array ((P_ROM_size - 1) downto 0) of std_logic_vector(7 downto 0);
    signal rom : rom_type := (others => (others => '0'));
    -- attribute rom_sytle : string;
    -- attribute rom_sytle of rom : signal is "block";
    
    signal inout_byte_sig : std_logic_vector(7 downto 0);

begin

    FLASH_ROM: process(in_clk) begin
        if rising_edge(in_clk) then
            if in_chip_enable = '1' and in_write_enable = '1' then
                rom(in_address) <= inout_byte;
            end if;
        end if;
    end process;
    
    inout_byte <= inout_byte_sig when (in_chip_enable = '1' and in_write_enable = '0' and in_output_enable = '1') else (others => 'Z');

    READ_ROM: process(in_clk) begin
        if rising_edge(in_clk) then
            if in_chip_enable = '1' and in_write_enable = '0' and in_output_enable = '1' then
                inout_byte_sig <= rom(in_address);
            else
                inout_byte_sig <= (others => '0');
            end if;
        end if;
    end process;
end Behavioral;
