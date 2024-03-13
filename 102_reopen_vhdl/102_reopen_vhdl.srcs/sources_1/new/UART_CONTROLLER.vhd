----------------------------------------------------------------------------------
-- Company: Bilkent University
-- Engineer: Emirhan Yagcioglu
-- 
-- Create Date: 03/08/2024 07:17:37 PM
-- Design Name: UART Logic & Data Controller
-- Module Name: UART_CONTROLLER - Behavioral
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

entity UART_CONTROLLER is
    generic (
        clk_freq:               integer := 100000000;
        baud_rate:              integer := 115200;
        P_ROM_size:             integer := 262144
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
end UART_CONTROLLER;

architecture Behavioral of UART_CONTROLLER is

    component R_EDGE_DETECTOR is
        port (
            in_clk:     in std_logic;
            in_signal:  in std_logic;
            
            out_pulse:  out std_logic
        );
    end component;
    
    signal rx_status_pulse: std_logic := '0';
    signal tx_status_pulse: std_logic := '0';

    type state is (
    uart_controller_off,
    uart_controller_in_transmission,
    uart_controller_in_readback, 
    uart_controller_wait_for_readback_result, 
    uart_controller_readback_correct, 
    uart_controller_readback_incorrect, 
    uart_controller_transmission_complete); -- UART state struct
    signal current_uart_controller_state : state := uart_controller_off; -- current UART state variable

    signal inout_result_byte_line_sig : std_logic_vector(7 downto 0) := (others => '0');
    signal inout_result_byte_line_wr : std_logic := '0';
    signal uart_tx_enable : std_logic := '0'; -- to enable the readback
    
    constant MAX_NUMBER_OF_TRIES : integer := 3;
    signal current_number_of_tries: integer range 0 to MAX_NUMBER_OF_TRIES := 0;
    
begin
    UART_PROGRAM_TRANSFER_PROCESS: process(in_chip_enable, in_clk) begin
        if in_chip_enable = '1' then
            if rising_edge(in_clk) then
                case current_uart_controller_state is
                    when uart_controller_off =>
                        inout_result_byte_line_sig <= (others => '0');
                        out_address <= 0;
                        out_reset_rx <= '0';
                        out_reset_tx <= '0';
                        out_PROM_write_en <= '0';
                        out_PROM_out_en <= '0';
                        out_tx_en <= '0';
                        out_end_op <= '0';
                        out_fatal_error <= '0';
                        
                        if in_trx_enable = '1' then
                            current_uart_controller_state <= uart_controller_in_transmission;
                        end if;
                    when uart_controller_in_transmission =>
                        out_PROM_write_en <= '1';
                        if in_rx_data_end_flag = '1' then
                            current_uart_controller_state <= uart_controller_in_readback;
                            out_address <= 0;
                            out_tx_en <= '1';
                            out_PROM_write_en <= '0';
                            out_PROM_out_en <= '1';
                        else
                            if rx_status_pulse = '1' then
                                out_address <= out_address + 1;
                            end if;
                        end if;
                    when uart_controller_in_readback =>
                        out_reset_rx <= '0';
                        if in_tx_data_end_flag = '1' then
                            current_uart_controller_state <= uart_controller_wait_for_readback_result;
                            out_address <= 0;
                            out_tx_en <= '0';
                            out_PROM_write_en <= '0';
                            out_PROM_out_en <= '0';
                            out_reset_rx <= '1';
                        else
                            if tx_status_pulse = '1' then
                                out_address <= out_address + 1;
                            end if;
                        end if;
                    when uart_controller_wait_for_readback_result =>
                        if rx_status_pulse = '1' then
                            if inout_result_byte_line = "00000110" then
                                current_uart_controller_state <= uart_controller_readback_correct;
                            else
                                current_uart_controller_state <= uart_controller_readback_incorrect;
                                out_reset_tx <= '1';
                            end if;
                        end if;
                    when uart_controller_readback_correct =>
                        out_end_op <= '1';
                        current_uart_controller_state <= uart_controller_transmission_complete;
                    when uart_controller_readback_incorrect =>
                        inout_result_byte_line_wr <= '1';
                        inout_result_byte_line_sig <= "00000110";
                        out_tx_en <= '1';
                        if tx_status_pulse = '1' then
                            inout_result_byte_line_wr <= '0';
                            inout_result_byte_line_sig <= (others => '0');
                            current_uart_controller_state <= uart_controller_transmission_complete;
                            out_reset_tx <= '0';
                            current_number_of_tries <= current_number_of_tries + 1;
                            if current_number_of_tries = MAX_NUMBER_OF_TRIES then
                                out_fatal_error <= '1';
                                current_uart_controller_state <= uart_controller_transmission_complete;
                            end if;
                        end if;
                    when uart_controller_transmission_complete =>
                        out_address <= 0;
                        out_reset_rx <= '0';
                        out_reset_tx <= '0';
                        out_PROM_write_en <= '0';
                        out_PROM_out_en <= '0';
                        out_tx_en <= '0';
                end case;
            end if;
        else 
            
        end if;
    end process;
    
    R_EDGE_DETECTOR_RX: R_EDGE_DETECTOR port map(
        in_clk => in_clk,
        in_signal => in_rx_status,
            
        out_pulse => rx_status_pulse
    );
    
    R_EDGE_DETECTOR_TX: R_EDGE_DETECTOR port map(
        in_clk => in_clk,
        in_signal => in_tx_status,
            
        out_pulse => tx_status_pulse
    );
    
    inout_result_byte_line <= inout_result_byte_line_sig when (inout_result_byte_line_wr = '1') else (others => 'Z');
end Behavioral;