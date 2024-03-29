----------------------------------------------------------------------------------
-- Company: Bilkent University
-- Engineer: Emirhan Yagcioglu
-- 
-- Create Date: 03/07/2024 11:26:17 PM
-- Design Name: UART Receiver Module
-- Module Name: UART_RX - Behavioral
-- Project Name: MIDI Synthesizer
-- Target Devices: BASYS3
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision: Initial commit
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Revision: Program counter connection established
-- Revision 0.1 - Experimental
-- Additional Comments: 
-- Removed the output latch, as this operation will be done by the Program ROM now
-- Added new outputs for ROM control
-- A new state added indicating the end of transmission
-- This version successfully passed experiments:
--  --  A speed reading test was conducted which gives satisfactory results
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_RX is
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
        in_rx:                      in std_logic; -- UART receiver line
        out_byte:                   out std_logic_vector(7 downto 0); -- UART receiver output
        -- status flags
        out_receiver_status:        out std_logic; -- output the UART receiver status (one byte)
        out_rx_data_end_flag:       buffer std_logic -- output the UART receiver status (all data)
    );
end UART_RX;

architecture Behavioral of UART_RX is
    
    constant BASYS3_clock_ticks_per_half_UART_clock : integer := clk_freq / (2 * baud_rate); -- how many clock ticks the main clock takes in a half cycle of the UART clock
    -- required for UART sample timing
    type state is (state_idle, state_start, state_data_read, state_stop, state_recycle, state_transmission_end); -- UART state struct
    signal current_state : state := state_idle; -- current UART state variable
    -- main FSM state variable
    signal state_clock_counter : integer range 0 to 2 * BASYS3_clock_ticks_per_half_UART_clock := 0; -- clock tick counter for start state
    signal data_bit_counter : integer range 0 to 8 := 0; -- counter for the current data bit 
    signal received_byte : std_logic_vector(7 downto 0); -- received byte holder, since it needs to be buffered (otherwise garbage values will be outputted during transmission)
    
begin

    UART_RX_CYCLE: process(in_clk) begin
        if rising_edge(in_clk) then
            case current_state is
                when state_idle =>
                    out_rx_data_end_flag <= '0'; -- initial values of the control signals
                    out_receiver_status <= '0';
                    state_clock_counter <= 0; -- While idle, push 0 to the state counter (required for false start conditions)
                    if in_rx = '0' then -- After the receive signal goes low
                        current_state <= state_start; -- set the state to start
                    end if;
                when state_start => -- RX dropped after a long streak of high, indicating intention for transmission
                    if state_clock_counter = BASYS3_clock_ticks_per_half_UART_clock then -- if half a UART clock cycle has passed in the start state, 
                        if in_rx = '0' then -- we are in the middle of the start bit. If the receive signal is still low, the transmission will begin
                            state_clock_counter <= 0; -- reset the state counter prior to data transmission
                            current_state <= state_data_read; -- set the state to data read
                        else -- if the receive signal reverted high, bad transmission, will be ignored (might not be the best solution here)
                            current_state <= state_idle; -- revert back to the idle state
                        end if;
                    else -- state clock counter has not reached the midpoint of the start bit
                        state_clock_counter <= state_clock_counter + 1; -- count the clock cycles in the start state
                    end if;
                when state_data_read => -- RX drop was significant and data reading operation will commence
                    if state_clock_counter = 2 * BASYS3_clock_ticks_per_half_UART_clock then -- if one UART clock cycle has passed after middle of the start bit,
                        received_byte(data_bit_counter) <= in_rx; -- we are in the middle of the first data bit, so read it
                        data_bit_counter <= data_bit_counter + 1; -- increment the data index
                        state_clock_counter <= 0; -- data clock counter reset
                    else
                        state_clock_counter <= state_clock_counter + 1; -- we are not in the middle of a data bit; count the clocks
                        if data_bit_counter = 8 then -- means the transmission is over
                            current_state <= state_stop;
                        end if;
                    end if;
                when state_stop => -- Transmission is over
                    if state_clock_counter = 2 * BASYS3_clock_ticks_per_half_UART_clock then -- if a UART clock cycle has passed after the last data point, 
                        out_receiver_status <= '1'; -- we are in the middle of the stop bit. Transmission ends successfully
                        if received_byte = "00001010" then -- end of line character
                            current_state <= state_transmission_end; -- complete end of transmission is reached, indicated via a "end of transmission" character
                        else
                            current_state <= state_recycle; -- recycle UART, go to the beginning
                        end if;
                        state_clock_counter <= 0;
                    else 
                        state_clock_counter <= state_clock_counter + 1; -- we are not in the middle of the stop bit; count the clocks
                    end if;
                when state_recycle => -- cycle reset state reset all variables to their initial values
                    out_receiver_status <= '0';
                    data_bit_counter <= 0;
                    state_clock_counter <= 0;
                    current_state <= state_idle; -- cycle ends
                when state_transmission_end => -- end of transmission flag was received, terminate receive operation
                    if state_clock_counter = 2 * BASYS3_clock_ticks_per_half_UART_clock then -- wait a bit before setting the end flag
                        out_receiver_status <= '1';
                        out_rx_data_end_flag <= '1';
                        if reset = '1' then
                            current_state <= state_recycle; -- recycle state resets the rx module
                        end if;
                    else 
                        state_clock_counter <= state_clock_counter + 1; -- we are not in the middle of the stop bit; count the clocks
                    end if;
            end case;
        end if;
    end process;
    
    out_byte <= received_byte when (out_rx_data_end_flag = '0') else (others => 'Z');

end Behavioral;
