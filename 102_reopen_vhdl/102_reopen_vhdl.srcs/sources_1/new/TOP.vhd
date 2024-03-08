----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2024 01:45:02 PM
-- Design Name: 
-- Module Name: TOP - Behavioral
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

entity TOP is
    generic (
        clk_freq:       integer := 100000000; -- set the clock frequency
        uart_baud_rate: integer := 115200 -- set the baud rate for UART
    );
    Port ( 
        in_100MHz_clk:  in std_logic; -- main clock
        in_rx:          in std_logic; -- UART receiver
        
        out_byte:       out std_logic_vector(7 downto 0)
    );
end TOP;

architecture Behavioral of TOP is

    component UART_RX is
        generic (
            clk_freq:       integer := 100000000;
            baud_rate:      integer := 115200
        );
        Port ( 
            in_100MHz_clk:              in std_logic; -- main clock
            in_rx:                      in std_logic; -- UART receiver 
            
            out_receiver_status:        out std_logic; -- output the UART receiver status (one byte)
            out_transmission_status:    out std_logic; -- output the UART transmission status (all data)
            out_byte:                   out std_logic_vector(7 downto 0) -- UART receiver output
        );
    end component;
    component PROGRAM_ROM is
        Port ( 
            in_byte:            in std_logic_vector(7 downto 0);
            in_receiver_status: in std_logic;
            in_write_enable:    in std_logic;
            in_output_enable:   in std_logic;
            
            in_read_clk:        in std_logic;
            
            data_finished_flag: out std_logic;
            out_byte:           out std_logic_vector(7 downto 0)
        );
    end component;
    component PROGRAM_CLOCK is
        generic (
            main_clock_tick_for_half_clock_cycle : integer := 10000000
        );
        Port (
            in_main_clock:      in std_logic;
            in_p_clock_enable:  in std_logic;
            
            out_p_clock :       out std_logic
        );
    end component;
    
    signal byte_connector: std_logic_vector(7 downto 0);
    signal receiver_status_connector: std_logic;
    signal transmission_status_signal: std_logic;
    
    signal program_clock_signal: std_logic;
    signal data_finished_flag_signal:  std_logic;

begin

    UART_RX1: UART_RX port map (
        in_100MHz_clk => in_100MHz_clk, 
        in_rx => in_rx, 
        out_receiver_status => receiver_status_connector, 
        out_transmission_status => transmission_status_signal,
        out_byte => byte_connector
    );
    
    PROGRAM_ROM1: PROGRAM_ROM port map (
        in_byte => byte_connector, 
        in_receiver_status => receiver_status_connector, 
        in_write_enable => '1',
        in_output_enable => '1',
        
        in_read_clk => program_clock_signal, 
        
        data_finished_flag => data_finished_flag_signal,
        out_byte => out_byte
    );
    
    PROGRAM_CLOCK1: PROGRAM_CLOCK port map (
        in_main_clock => in_100MHz_clk, 
        in_p_clock_enable => transmission_status_signal, 
        
        out_p_clock => program_clock_signal
    );

end Behavioral;
