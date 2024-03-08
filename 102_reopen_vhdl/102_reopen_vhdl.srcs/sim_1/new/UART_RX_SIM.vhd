----------------------------------------------------------------------------------
-- Company: Bilkent University
-- Engineer: Emirhan Yagcioglu
-- 
-- Create Date: 03/08/2024 12:06:43 AM
-- Design Name: UART Receiver Test Module
-- Module Name: UART_RX_SIM - Behavioral
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

entity testbench IS 
end testbench;

architecture testbench_arch of testbench is
    component UART_RX is
        generic (
            clk_freq:                   integer := 100000000;
            baud_rate:                  integer := 115200
        );
        Port ( 
            in_100MHz_clk:              in std_logic; -- main clock
            in_rx:                      in std_logic; -- UART receiver 
            
            out_byte:                   out std_logic_vector(7 downto 0) -- UART receiver output
        );
    end component;

    signal in_100MHz_clk_sig : std_logic := '0';
    signal in_rx_sig : std_logic := '0';
    
    signal out_byte_sig : std_logic_vector(7 downto 0);
    
    constant clk_half_period : time := 5 ns;
    constant baud_period : time := 8681 ns;

begin
    UART_RX_inst : UART_RX
        port map (
            in_100MHz_clk => in_100MHz_clk_sig,
            in_rx => in_rx_sig,
            
            out_byte => out_byte_sig
        );

    CLK_GEN: process begin
        in_100MHz_clk_sig <= not in_100MHz_clk_sig;
        wait for clk_half_period;
    end process;
    
    STIMULUS_PROCESS: process begin
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        
        in_rx_sig <= '0';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '1';
        wait for baud_period;
        
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        in_rx_sig <= '1';
        wait for baud_period;
        
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        
        in_rx_sig <= '0';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        
        in_rx_sig <= '0';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        in_rx_sig <= '1';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        in_rx_sig <= '0';
        wait for baud_period;
        
        in_rx_sig <= '1';
        wait;
    end process;

end architecture testbench_arch;