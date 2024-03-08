----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2024 02:59:16 PM
-- Design Name: 
-- Module Name: UART_PROGRAM_LOAD_TEST - Behavioral
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

entity top_testbench IS 
end top_testbench;

architecture top_testbench_arch of top_testbench is
    component TOP is
        generic (
            clk_freq:       integer := 100000000; -- set the clock frequency
            uart_baud_rate: integer := 115200 -- set the baud rate for UART
        );
        Port ( 
            in_100MHz_clk:  in std_logic; -- main clock
            in_rx:          in std_logic; -- UART receiver
            
            out_byte:       out std_logic_vector(7 downto 0)
        );
    end component;

    signal in_100MHz_clk_sig : std_logic := '0';
    signal in_rx_sig : std_logic := '0';
    
    signal out_byte_sig : std_logic_vector(7 downto 0);
    
    constant clk_half_period : time := 5 ns;
    constant baud_period : time := 8681 ns;

begin
    TOP_inst : TOP
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

end architecture top_testbench_arch;