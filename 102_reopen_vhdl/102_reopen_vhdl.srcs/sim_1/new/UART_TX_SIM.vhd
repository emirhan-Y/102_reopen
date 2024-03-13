----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/09/2024 01:02:09 AM
-- Design Name: 
-- Module Name: UART_TX_SIM - Behavioral
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

entity UART_TX_SIM is
--  Port ( );
end UART_TX_SIM;

architecture Behavioral of UART_TX_SIM is

    component UART_TX is
        generic (
            clk_freq:                   integer := 100000000;
            baud_rate:                  integer := 115200
        );
        Port ( 
            in_100MHz_clk:              in std_logic; -- main clock
            in_enable_transmit:         in std_logic; -- transmit enable signal
            
            in_byte:                    in std_logic_vector(7 downto 0); -- UART input byte
            out_tx:                     out std_logic;  -- UART transmitter
            
            out_transmitter_status:     out std_logic; -- output the UART transmitter status (one byte)
            out_tx_data_end_flag:       out std_logic -- output the UART transmitter status (all data)
        );
    end component;
    
    type test_data_array is array (16 downto 0) of std_logic_vector(7 downto 0);
    signal test_data : test_data_array := (
    "00000100",
    "00110000",
    "00110001",
    "01000001",
    "00110010",
    "01000010",
    "01000011",
    "01000100",
    "00110011",
    "00110100",
    "01000101",
    "00110101",
    "01000110",
    "00110110",
    "01000111",
    "00110111",
    "00111000"
    );
    signal test_data_index : integer range 0 to 17 := 0;
    signal current_test_data : std_logic_vector(7 downto 0);
    
    signal in_100MHz_clk_sig : std_logic := '0';
    signal in_enable_transmit_sig: std_logic := '1';
    
    signal out_tx_sig : std_logic := '0';
    
    signal out_transmitter_status_sig : std_logic;
    signal out_tx_data_end_flag_sig : std_logic;
    
    constant clk_half_period : time := 5 ns;
    constant baud_period : time := 8681 ns;
    
begin

    current_test_data <= test_data(test_data_index);

    UART_TX_inst : UART_TX
        port map (
            in_100MHz_clk => in_100MHz_clk_sig,
            in_enable_transmit => in_enable_transmit_sig,
            
            in_byte => current_test_data,
            out_tx => out_tx_sig,
            
            out_transmitter_status => out_transmitter_status_sig,
            out_tx_data_end_flag => out_tx_data_end_flag_sig
        );

    CLK_GEN: process begin
        in_100MHz_clk_sig <= not in_100MHz_clk_sig;
        wait for clk_half_period;
    end process;
    
    STIMILUS_PROCESS: process(out_transmitter_status_sig) begin
        if rising_edge(out_transmitter_status_sig) then
            if test_data_index = 17 then
                test_data_index <= 0;
            else 
                test_data_index <= test_data_index + 1;
            end if;
        end if;
    end process;
    

end Behavioral;
