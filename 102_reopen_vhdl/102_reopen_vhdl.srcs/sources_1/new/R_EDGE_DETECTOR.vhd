----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2024 03:25:29 PM
-- Design Name: 
-- Module Name: R_EDGE_DETECTOR - Behavioral
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

entity R_EDGE_DETECTOR is
    port (
        in_clk:     in std_logic;
        in_signal:  in std_logic;
        
        out_pulse:  out std_logic
    );
end R_EDGE_DETECTOR;

architecture Behavioral of R_EDGE_DETECTOR is
    signal previous_sample : std_logic := '0';
begin
    PULSE_GEN: process(in_clk) begin
        if rising_edge(in_clk) then
            if in_signal = '1' and previous_sample = '0' then
                out_pulse <= '1';
            else
                out_pulse <= '0';
            end if;
            previous_sample <= in_signal;
        end if;
    end process;
end Behavioral;
