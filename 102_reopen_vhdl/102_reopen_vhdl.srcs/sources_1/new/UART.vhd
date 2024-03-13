----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2024 06:14:17 PM
-- Design Name: UART Wrapper Module
-- Module Name: UART - Behavioral
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

entity UART is
    generic (
        clk_freq:           integer := 100000000;
        baud_rate:          integer := 115200;
        P_ROM_size:         integer := 262144 -- 256KB Program ROM
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
end UART;

 architecture Behavioral of UART is
    
    component UART_RX is
        generic (
            -- generic values (constants) for the module
            clk_freq:                   integer := clk_freq;
            baud_rate:                  integer := baud_rate
        );
        Port (
            -- reset
            reset:                      in std_logic;
            -- clock
            in_clk:                     in std_logic; -- main clock
            -- data lines
            in_rx:                      in std_logic; -- UART receiver line
            out_byte:                   out std_logic_vector(7 downto 0); -- UART receiver output
            -- status flags
            out_receiver_status:        out std_logic; -- output the UART receiver status (one byte)
            out_rx_data_end_flag:       buffer std_logic -- output the UART receiver status (all data)
        );
    end component;
    
    component UART_TX is
        generic (
            -- generic values (constants) for the module
            clk_freq:                   integer := clk_freq;
            baud_rate:                  integer := baud_rate
        );
        Port (
            -- reset
            reset:                      in std_logic;
            -- clock
            in_clk:                     in std_logic; -- main clock
            -- data lines
            in_byte:                    in std_logic_vector(7 downto 0); -- UART input byte
            out_tx:                     out std_logic;  -- UART transmitter
            -- control inputs
            in_tx_enable:               in std_logic; -- transmit enable signal
            -- status flags
            out_transmitter_status:     out std_logic; -- output the UART transmitter status (one byte)
            out_tx_data_end_flag:       out std_logic -- output the UART transmitter status (all data)
        );
    end component;
    
    component UART_CONTROLLER is
        generic (
            clk_freq:               integer := clk_freq;
            baud_rate:              integer := baud_rate;
            P_ROM_size:             integer := P_ROM_size -- 256KB Program ROM
        );
        Port (
            -- clock
            in_clk:                 in std_logic; -- main clock
            -- address line
            out_address:            buffer integer range 0 to (P_ROM_size - 1); -- address to the ROM
            -- data line
            inout_result_byte_line: inout std_logic_vector(7 downto 0);
            -- chip control inputs
            in_chip_enable:         in std_logic; -- uart controller enable signal
            in_trx_enable:          in std_logic; -- uart start UART process signal
            in_rx_status:           in std_logic; -- uart receiver byte status
            in_tx_status:           in std_logic; -- uart transmitter byte status
            in_rx_data_end_flag:    in std_logic; -- rx end flag input
            in_tx_data_end_flag:    in std_logic; -- tx end flag input
            -- chip control outputs
            out_reset_rx:           out std_logic; -- signal used to reset the rx submodule ahead of retransmission results
            out_reset_tx:           out std_logic; -- signal used to reset the tx submodule ahead of retransmission
            out_PROM_write_en:      out std_logic; -- to enable the rom write enable
            out_PROM_out_en:        out std_logic; -- to enable the rom output enable
            
            out_tx_en:              out std_logic; -- to enable the tx module
            out_end_op:             out std_logic; -- indicate the end of UART operation
            
            out_fatal_error:        out std_logic -- indicates complete UART transmission failure
        );
    end component;
    
    signal in_rx_connector: std_logic;
    signal out_tx_connector: std_logic;
    
    signal rx_reset_signal_connector : std_logic;
    signal tx_reset_signal_connector : std_logic;
    signal transmitter_enable_signal: std_logic;
    signal receiver_status_connector: std_logic;
    signal rx_data_end_flag_signal: std_logic;
    signal transmitter_status_connector: std_logic;
    signal tx_data_end_flag_signal: std_logic;
    
begin

    UART_RX1: UART_RX port map (
        reset => rx_reset_signal_connector,
        in_clk => in_clk, 
        in_rx => in_rx,
        out_byte => inout_byte,
        
        out_receiver_status => receiver_status_connector, 
        out_rx_data_end_flag => rx_data_end_flag_signal
    );
    
    UART_TX1: UART_TX port map (
        reset => tx_reset_signal_connector,
        in_clk => in_clk,                                                                       
        in_byte => inout_byte,
        out_tx => out_tx,
        in_tx_enable => transmitter_enable_signal,
        
        out_transmitter_status => transmitter_status_connector, 
        out_tx_data_end_flag => tx_data_end_flag_signal
    );
    
    UART_CONTROLLER1: UART_CONTROLLER port map(
        in_clk => in_clk,
        out_address => out_address,
        inout_result_byte_line => inout_byte,
        in_chip_enable => in_chip_enable,
        in_trx_enable => in_trx_enable,
        in_rx_status => receiver_status_connector,
        in_tx_status => transmitter_status_connector,
        in_rx_data_end_flag => rx_data_end_flag_signal,
        in_tx_data_end_flag => tx_data_end_flag_signal,
        out_reset_rx => rx_reset_signal_connector,
        out_reset_tx => tx_reset_signal_connector,
        out_PROM_write_en => out_en_ROM_write,
        out_PROM_out_en => out_en_ROM_out,
        out_tx_en => transmitter_enable_signal,
        out_end_op => out_end_of_op_flag,
        out_fatal_error => out_fatal_error
    );

end Behavioral;