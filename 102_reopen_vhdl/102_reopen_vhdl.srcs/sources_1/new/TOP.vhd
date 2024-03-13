----------------------------------------------------------------------------------
-- Company: Bilkent University
-- Engineer: Emirhan Yagcioglu
-- 
-- Create Date: 03/08/2024 01:45:02 PM
-- Design Name: MIDI Synthesizer Top Module
-- Module Name: TOP - Behavioral
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

entity TOP is
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
end TOP;

architecture Behavioral of TOP is

    component UART is
        generic (
            clk_freq:           integer := clk_freq;
            baud_rate:          integer := uart_baud_rate;
            P_ROM_size:         integer := P_ROM_size
        );
        Port (
            -- clock
            in_clk:             in std_logic; -- main clock
            -- address lines
            out_address:        buffer integer range 0 to P_ROM_size - 1; -- ROM address
            -- data lines
            in_rx:              in std_logic; -- serial UART receiver line
            out_tx:             out std_logic; -- serial UART transmitter line
            inout_byte:         inout std_logic_vector(7 downto 0); -- parallel byte bus
            -- chip control inputs
            in_chip_enable:     in std_logic; -- the UART operation status
            in_trx_enable:      in std_logic;
            -- chip control outputs
            out_en_ROM_write:   out std_logic; -- ROM write enable driver
            out_en_ROM_out:     out std_logic; -- ROM output enable driver
            out_end_of_op_flag: out std_logic; -- the UART operation status
            
            out_fatal_error:    out std_logic
        );
    end component;
    component PROGRAM_ROM is
        generic (
            P_ROM_size:         integer := P_ROM_size
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
    end component;
    
    signal byte_connector: std_logic_vector(7 downto 0);
    signal address_connector: integer range 0 to P_ROM_size - 1;
    
    signal P_ROM_enable: std_logic := '1';
    
    signal P_ROM_write_enable_signal: std_logic;
    signal P_ROM_output_enable_signal:  std_logic;

begin

    UART1: UART port map (
        in_clk => in_clk,
        out_address => address_connector,
        in_rx => in_rx,
        out_tx => out_tx,
        inout_byte => byte_connector,
        in_chip_enable => in_chip_enable,
        in_trx_enable => in_trx_enable,
        out_en_ROM_write => P_ROM_write_enable_signal,
        out_en_ROM_out => P_ROM_output_enable_signal,
        out_end_of_op_flag => out_end_of_op_flag,
        out_fatal_error => out_fatal_error
    );
    
    PROGRAM_ROM1: PROGRAM_ROM port map (
        in_clk => in_clk,
        in_address => address_connector,
        inout_byte => byte_connector,
        in_chip_enable => P_ROM_enable,
        in_write_enable => P_ROM_write_enable_signal,
        in_output_enable => P_ROM_output_enable_signal
    );

end Behavioral;
