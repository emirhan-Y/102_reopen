import serial
import time


def init_serial():
    uart_serial = serial.Serial('COM9')  # This might need change
    uart_serial.baudrate = 115200  # configure the UART transmitter compatible with the BASYS3 receiver
    uart_serial.bytesize = 8
    uart_serial.stopbits = 1
    uart_serial.parity = 'N'
    return uart_serial


def test_serial(uart_serial):
    time.sleep(3)  # after config wait before sending data
    uart_serial.write(b'asdasd\nasdasd')  # some serial data


def read_from_the_port(uart_serial):
    return uart_serial.readline()


if __name__ == "__main__":
    basys3_uart_serial = init_serial()
    test_serial(basys3_uart_serial)
    print(read_from_the_port(basys3_uart_serial))
