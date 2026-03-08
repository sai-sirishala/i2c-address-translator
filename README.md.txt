# I2C Address Translator (SystemVerilog)

## Overview
This project implements an **I2C Address Translator** using **SystemVerilog RTL design**.  
The module translates a **virtual I2C device address (0x49)** received from the master into a **real device address (0x48)** of the target slave device.

The design keeps the **data phase unchanged** and only modifies the **address phase** when the incoming address matches the configured virtual address.

---

## Features
- Implemented using **SystemVerilog RTL**
- **Finite State Machine (FSM)** based architecture
- **Shift register** used for address capture
- **Selective address translation**
- Pass-through behavior for non-target addresses
- Maintains **standard I2C timing (~100 kHz)**
- Verified with a **SystemVerilog testbench**

---

## Address Translation

| Master Address | Output Address |
|----------------|---------------|
| 0x49 (Virtual) | 0x48 (Real)   |
| Other Address  | Pass-through  |

---

## Design Architecture

The module consists of the following components:

- **START condition detection**
- **FSM with three states**
  - `IDLE`
  - `ADDR_PHASE`
  - `DATA_PHASE`
- **Address capture using shift register**
- **Selective translation logic**

---

## Project Structure
i2c-address-translator
│
├── rtl
│ └── i2c_address_translator.sv
│
├── tb
│ └── testbench.sv
│
└── README.md

---

## Simulation

Simulation was performed using:

- SystemVerilog
- Synopsys VCS Simulator
- EDA Playground
- EPWave waveform viewer

Two scenarios were verified:

1️⃣ Non-target address  
Address: **0x55**  
Expected behavior: **Pass-through**

2️⃣ Address translation  
Address: **0x49**  
Translated to: **0x48**

---

## How to Run

1. Open project in **EDA Playground**
2. Select **SystemVerilog**
3. Choose simulator **Synopsys VCS**
4. Enable **EPWave**
5. Run simulation

---

## Learning Outcomes

- Understanding of **I2C protocol**
- RTL design using **SystemVerilog**
- FSM based digital design
- Shift register implementation
- Testbench verification
- Waveform analysis

---

## Author

S.SAI

Aspiring **VLSI / Digital Design Engineer**

---

This project is created for **learning and educational purposes**.