----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2024 03:43:45 PM
-- Design Name: 
-- Module Name: EDGE_DETECTOR_SIM - Behavioral
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

entity EDGE_DETECTOR_SIM IS 
end EDGE_DETECTOR_SIM;

architecture EDGE_DETECTOR_SIM_ARCH of EDGE_DETECTOR_SIM is
    component R_EDGE_DETECTOR is
        port (
            in_clk:     in std_logic;
            in_signal:  in std_logic;
            
            out_pulse:  out std_logic
        );
    end component;

    signal in_clk_sig : std_logic := '0';
    signal in_signal_sig : std_logic := '0';
    
    signal out_pulse_sig : std_logic;
    
    constant clk_half_period : time := 5 ns;

begin
    EDGE_DETECTOR_inst : R_EDGE_DETECTOR
        port map (
            in_clk => in_clk_sig,
            in_signal => in_signal_sig,
            
            out_pulse => out_pulse_sig
        );

    CLK_GEN: process begin
        in_clk_sig <= not in_clk_sig;
        wait for clk_half_period;
    end process;
    
    STIMULUS_PROCESS: process begin
        in_signal_sig <= '1';
        wait for 10000 ns;
        in_signal_sig <= '0';
        wait for 1000 ns;
        
        in_signal_sig <= '1';
        wait for 100 ns;
        in_signal_sig <= '0';
        wait for 100 ns;
        
        in_signal_sig <= '1';
        wait for 10 ns;
        in_signal_sig <= '0';
        wait for 100 ns;
        
        in_signal_sig <= '1';
        wait for 5 ns;
        in_signal_sig <= '0';
        wait for 1000 ns;
        
        wait;
    end process;

end EDGE_DETECTOR_SIM_ARCH;
