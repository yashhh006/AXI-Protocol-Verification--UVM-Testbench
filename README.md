# Verification of the AXI Protocol using UVM 

This project is a UVM testbench I built from scratch to test the AXI protocol. My goal was to create a "test rig" that could check if a device communicating with AXI is following all the rules correctly.

The environment simulates a Master device talking to a Slave device, and I've built checks to validate their entire conversation.

---

### My Verification Setup

I used **SystemVerilog** and the **UVM**. The testbench is organized into a few key parts:

* **The AXI Master**: This component  initiates activity by generating random, valid commands (like read and write requests) to thoroughly test the system.

* **The AXI Slave**: This component is designed to behave like a simple memory, responding correctly to any command the Master sends it.

* **The Scoreboard**: It watches all the data the Master writes and compares it to the data it reads back. This instantly tells us if the data was corrupted, ensuring our test passed.

---

### Key AXI Features I Tested

I focused on verifying the most important parts of the AXI protocol to ensure it's robust:

* **All 5 Channels**: Full validation of the `Write Address`, `Write Data`, `Write Response`, `Read Address`, and `Read Data` channels for all testcases and analyzed the waveform.

* **Burst Transfers**: Made and verified the testcase that sends data in chunks (like `INCR`, `WRAP`, and `FIXED`).

* **Narrow Transfers**: Verified the testcase when the Master and Slave have different data bus sizes.

---

### The Test Scenarios I Created

I wrote a variety of tests to target different behaviors:

* **`basic_read_write_test`**: A simple "sanity check" to ensure the most basic functions work.
* **`burst_transfer_tests`**: Specific tests for each burst type to check them in detail.
* **`stress_test`**: A randomized test that throws a lot of different commands at once to try and find tricky corner-case bugs.

---

### Tracking My Progress with Coverage

To be sure my tests were thorough, I used **functional coverage**. This allowed me to track exactly which features I had tested and helped me find any gaps in my test plan, ensuring a high-quality verification effort.
