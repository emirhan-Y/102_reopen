----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2024 03:27:09 PM
-- Design Name: 
-- Module Name: PROGRAM_CLOCK - Behavioral
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

entity PROGRAM_CLOCK is
    generic (
        main_clock_tick_for_half_clock_cycle : integer := 10000000
    );
    Port (
        in_main_clock:      in std_logic;
        in_p_clock_enable:  in std_logic;
        
        out_p_clock :       out std_logic
    );
end PROGRAM_CLOCK;

architecture Behavioral of PROGRAM_CLOCK is

    signal clock_signal : std_logic := '0';
    signal clock_counter : integer range 0 to main_clock_tick_for_half_clock_cycle := 0;

begin

    PROGRAM_CLOCK_GENERATOR: process(in_main_clock) begin
        if rising_edge(in_main_clock) then
            if in_p_clock_enable = '1' then
                if clock_counter = main_clock_tick_for_half_clock_cycle - 1 then
                    clock_signal <= not clock_signal;
                    clock_counter <= 0;
                else
                    clock_counter <= clock_counter + 1;
                end if;
            else
                clock_signal <= '0';
                clock_counter <= 0;
            end if;
        end if;
    end process;
    
    out_p_clock <= clock_signal;

end Behavioral;
