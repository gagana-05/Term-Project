# VLSI Design Automation

<details>
  <summary>Table of Contents</summary>
    <ol>
        <li>
            <a href="#introduction-to-openlane-flow">Introduction to Openlane Flow</a>
        </li>
        <li>
            <a href="#openlane-design-stages">OpenLane Design Stages</a>
        </li>
        <li>
            <a href="#lef-overview">LEF Overview</a>
        </li>
          </li>
        <li>
            <a href="#objective">Objective</a>
        </li>
        <li>
            <a href="#about-femtorv32">About FemtoRV32</a>
        </li>
        <li>
            <a href="#standard-cell-layout-design-in-magic">Standard cell Layout design in Magic</a>
        </li>
        <li>
            <a href="#defining-and-extracting-lef-file-in-magic">Defining and extracting LEF file in Magic</a>
        </li>
        <li>
            <a href="#plugging-custom-lef-to-openlane">Plugging custom LEF to OpenLane</a>
        </li>
        <li>
            <a href = "challenges"> Challenges</a>
        </li>
    </ol>
</details>

## Introduction to OpenLane Flow

OpenLANE is a completely automated RTL to GDSII flow which embeds in it different opensource tools, namely, OpenROAD, Yosys, ABC, Magic etc., apart from many custom methodology scripts for design exploration and optimization.
Openlane is built around Skywater 130nm process node and is capable of performing full ASIC implementation steps from RTL all the way down to GDSII. The flow-chart below gives a better picture of openlane flow as a whole. <hr>
![Openlane_Flow](https://www.chipsalliance.org/news/improving-the-openlane-asic-build-flow-with-open-source-systemverilog-support/openlane-flow.png)
Image Coutersy: [Chips Alliance](https://www.chipsalliance.org/news/improving-the-openlane-asic-build-flow-with-open-source-systemverilog-support/)

### OpenLane Design Stages

Place and Route (PnR) is the core of any ASIC implementation and Openlane flow integrates into it several key open source tools which perform each of the respective stages of PnR. Below are the stages and the respective tools that are called by openlane for the functionalities as described:

1. **Synthesis**
    1. `yosys/abc` - Perform RTL synthesis and technology mapping.
    2. `OpenSTA` - Performs static timing analysis on the resulting netlist to generate timing reports
2. **Floorplaning**
    1. `init_fp` - Defines the core area for the macro as well as the rows (used for placement) and the tracks (used for routing)
    2. `ioplacer` - Places the macro input and output ports
    3. `pdngen` - Generates the power distribution network
    4. `tapcell` - Inserts welltap and decap cells in the floorplan
3. **Placement**
    1. `RePLace` - Performs global placement
    2. `Resizer` - Performs optional optimizations on the design
    3. `OpenDP` - Performs detailed placement to legalize the globally placed components
4. **CTS**
    1. `TritonCTS` - Synthesizes the clock distribution network (the clock tree)
5. **Routing**
    1. `FastRoute` - Performs global routing to generate a guide file for the detailed router
    2. `TritonRoute` - Performs detailed routing
    3. `OpenRCX` - Performs SPEF extraction
6. **Tapeout**
    1. `Magic` - Streams out the final GDSII layout file from the routed def
    2. `KLayout` - Streams out the final GDSII layout file from the routed def as a back-up
7. **Signoff**
    1. `Magic` - Performs DRC Checks & Antenna Checks
    2. `KLayout` - Performs DRC Checks
    3. `Netgen` - Performs LVS Checks
    4. `CVC` - Performs Circuit Validity Checks

Follow this link for brief overview on OpenLane and its installation: [Openlane docs](https://openlane.readthedocs.io/en/latest/)

### LEF Overview

Library Exchange Format (LEF) file serves the purpose of protecting intellectual property and is basically of two types:

- Cell LEF - It's an abstract view of the cell and only gives information about PR boundary, pin position and metal layer information of the cell, information necessary for PnR tool to correctly place and route a block.

- Technology LEF - It contains information about available metal layer, via information, DRCs of particular technology used by placer and router etc.. The below diagram highlights the difference between a layout and a LEF (Image Courtesy: Google): <br>

![image](https://user-images.githubusercontent.com/82756709/223063425-f41c19bf-6c9d-4222-9050-bb3887edb66b.png) <hr>

### Objective

The goal of this project is to design a single height standard cell and plug this custom cell into a more complex design and perform its PnR in the Openlane Flow.The standard cell chosen is CMOS inverter and the design into which it is plugged is prebuilt [femtoRV32](https://github.com/BrunoLevy/learn-fpga/blob/master/FemtoRV/RTL/PROCESSOR/femtorv32_quark.v) core.

### About FemtoRV32

### Standard cell layout design in Magic

1. #### Magic + skywater-PDK installation

   - Follow this blog for [magic vlsi + skywater-pdk local installation guide](https://lootr5858.wordpress.com/2020/10/06/magic-vlsi-skywater-pdk-local-installation-guide/)

2. #### Standard Cell layout

3. #### Create port definition

4. #### Set port class and port use attributes

### Defining and extracting LEF file in Magic

## Plugging Custom LEF to OpenLane

<hr>
Open OpenLane Directory and enter:

```bash
make mount
```

To run in interactive mode

```bash
./flow.tcl -interactive
```

<b>Note 1:</b> Now the run the commands in the following sequence and no steps should be skipped

```bash
$ prep -design femto -tag myrun -init_design_config
```

![interactive_flow.png](image.png)

Include the below command to include the additional lef (inv.lef) into the flow:

```bash
% set lefs [glob $::env(DESIGN_DIR)/src/*.lef]
% add_lefs -src $lefs

```
