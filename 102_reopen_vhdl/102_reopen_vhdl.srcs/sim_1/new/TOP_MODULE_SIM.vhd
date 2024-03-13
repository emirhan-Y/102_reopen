----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2024 05:54:01 PM
-- Design Name: 
-- Module Name: TOP_MODULE_SIM - Behavioral
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

entity TOP_MODULE_SIM is
--  Port ( );
end TOP_MODULE_SIM;

architecture Behavioral of TOP_MODULE_SIM is
    
    component TOP is
        generic (
            clk_freq:       integer := 100000000; -- set the clock frequency
            uart_baud_rate: integer := 115200; -- set the baud rate for UART
            P_ROM_size:     integer := 65535 -- 64KB Program ROM
        );
        Port ( 
            in_clk:         in std_logic; -- main clock
            in_rx:          in std_logic; -- UART receiver
            out_tx:         out std_logic; -- UART transmitter
            
            in_chip_enable: in std_logic;
            in_trx_enable:  in std_logic;
            
            out_end_of_op_flag: out std_logic;
            out_fatal_error: out std_logic
        );
    end component;

    signal in_clk_sig : std_logic := '0';
    signal in_trx_enable_sig: std_logic := '0';
    
    signal in_rx_sig : std_logic := '0';
    signal out_tx_sig : std_logic := '0';
    
    signal out_end_of_op_flag_sig : std_logic;
    signal out_fatal_error_sig : std_logic;
    
    constant clk_half_period : time := 5 ns;
    constant baud_period : time := 8681 ns;
    
begin

    TOP_inst : TOP
        port map (
            in_clk => in_clk_sig,
            in_rx => in_rx_sig,
            out_tx => out_tx_sig,
            in_chip_enable => '1',
            in_trx_enable => in_trx_enable_sig,
            out_end_of_op_flag => out_end_of_op_flag_sig,
            out_fatal_error => out_fatal_error_sig
        );

    CLK_GEN: process begin
        in_clk_sig <= not in_clk_sig;
        wait for clk_half_period;
    end process;
    
    STIMULUS_PROCESS: process begin
        in_rx_sig <= '1'; -- idle
        wait for 1ms;
        in_trx_enable_sig <= '1';
        wait for 1ms;
    
        in_rx_sig <= '1'; -- idle
        wait for baud_period;
        in_rx_sig <= '0'; -- start
        wait for baud_period;
        
        in_rx_sig <= '1'; -- send 0x67 through UART
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
        
        in_rx_sig <= '1'; -- back to idle
        wait for baud_period;
        in_rx_sig <= '0'; -- start
        wait for baud_period;
        
        in_rx_sig <= '1'; -- send 0x39 through UART
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
        
        in_rx_sig <= '0';  -- send 0x00 through UART
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
        
        in_rx_sig <= '1';  -- send 0xFF through UART
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
        
        in_rx_sig <= '1';  -- send 0xb1 through UART
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
        
        in_rx_sig <= '0';  -- send 0x24 through UART
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
        
        in_rx_sig <= '0';  -- send 0x04 through UART, which is the end of transmission character
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
        in_rx_sig <= '0';
        wait for baud_period;
        
        in_rx_sig <= '1';
        wait;
    end process;
    
end Behavioral;
