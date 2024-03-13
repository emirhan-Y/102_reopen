----------------------------------------------------------------------------------
-- Company: Bilkent University
-- Engineer: Emirhan Yagcioglu
-- 
-- Create Date: 03/09/2024 12:28:26 AM
-- Design Name: UART Transm?tter Module
-- Module Name: UART_TX - Behavioral
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

entity UART_TX is
    generic (
        -- generic values (constants) for the module
        clk_freq:                   integer := 100000000;
        baud_rate:                  integer := 115200
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
end UART_TX;

architecture Behavioral of UART_TX is

    constant BASYS3_clock_ticks_per_half_UART_clock : integer := clk_freq / (2 * baud_rate); -- how many clock ticks the main clock takes in a half cycle of the UART clock
    -- required for UART sample timing
    type state is (state_idle, state_start, state_data_write, state_recycle, state_transmission_end); -- UART state struct
    signal current_state : state := state_idle; -- current UART state variable
    -- main FSM state variable
    signal state_clock_counter : integer range 0 to 2 * BASYS3_clock_ticks_per_half_UART_clock := 0; -- clock tick counter for start state
    signal data_bit_counter : integer range 0 to 8 := 0; -- counter for the current data bit 
    signal current_byte : std_logic_vector(7 downto 0); -- received byte holder, since it needs to be buffered (otherwise garbage values will be outputted during transmission)
    
begin

    UART_TX_CYCLE: process(in_clk) begin
        if rising_edge(in_clk) then
            case current_state is
                when state_idle =>
                    out_tx <= '1'; -- while idle the line stays high
                    out_transmitter_status <= '0'; -- initial values of the control signals
                    out_tx_data_end_flag <= '0';
                    if in_tx_enable = '1' then
                        if state_clock_counter = 2 * BASYS3_clock_ticks_per_half_UART_clock then
                            state_clock_counter <= 0;
                            current_state <= state_start;
                        else
                            state_clock_counter <= state_clock_counter + 1;
                        end if;
                    end if;
                when state_start =>
                    out_tx <= '0';
                    if state_clock_counter = 2 * BASYS3_clock_ticks_per_half_UART_clock then
                        state_clock_counter <= 0;
                        current_state <= state_data_write;
                    else
                        state_clock_counter <= state_clock_counter + 1;
                    end if;
                when state_data_write =>
                    out_tx <= in_byte(data_bit_counter);
                    if state_clock_counter = 2 * BASYS3_clock_ticks_per_half_UART_clock then
                        state_clock_counter <= 0;
                        if data_bit_counter = 7 then
                            data_bit_counter <= 0;
                            out_transmitter_status <= '1';
                            if in_byte = "00001010" then
                                current_state <= state_transmission_end;
                            else
                                current_state <= state_recycle;
                            end if;
                        else 
                            data_bit_counter <= data_bit_counter + 1;
                        end if;
                    else
                        state_clock_counter <= state_clock_counter + 1;
                    end if;
                when state_recycle =>
                    out_tx <= '1';
                    out_transmitter_status <= '0';
                    data_bit_counter <= 0;
                    state_clock_counter <= 0;
                    current_state <= state_idle; -- cycle ends
                when state_transmission_end =>
                    out_tx <= '1'; -- let
                    out_tx_data_end_flag <= '1';
                    if reset = '1' then
                        current_state <= state_recycle; -- recycle state resets the rx module
                    end if;
            end case;
        end if;
    end process;

end Behavioral;
