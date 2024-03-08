# 102_reopen

An overhaul of my EEE102 Project

## Planned Upgrades

### Complete overhaul of control system

The worst offense commited by the original project was a lack of automation of the data loading procedure. When a new MIDI file was requested, I would have to run a python script to generate a "bitstream", unique to that MIDI file, which I then loaded to the system manuall. This required a resynthesis and reimplementation of the system, each time. This resynthesis process was the most time consuming part of the project, as the size of the project was massive due to a massive memory inefficiency.

#### Fixed memory bloat

The original project had a weird control system. Its inefficient implementation caused a lot of redundant memory usage, which limited the systems ability, as the BASYS3 board had very limited memory already. 

For this version, a small microcontroller-like control logic will be implemented.

## Version History

### v0.0.1

UART RX module is active
- Reads continuous data from the receiver (successful simulation, available in version/0.0.1/result)
- Failure mode fast start bit was tested successfully, though this approach is not the best solution for this problem

