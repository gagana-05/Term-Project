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
            <a href = "#observation"> Observation</a>
        </li>
         <li>
            <a href = "#team-members"> Team Members</a>
        </li>
        <li>
            <a href = "#challenges"> Challenges</a>
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

## Objective

The goal of this project is to design a single height standard cell and plug this custom cell into a more complex design and perform its PnR in the Openlane Flow.The standard cell chosen is CMOS inverter and the design into which it is plugged is prebuilt [femtoRV32](https://github.com/BrunoLevy/learn-fpga/blob/master/FemtoRV/RTL/PROCESSOR/femtorv32_quark.v) core.

## About FemtoRV32

[FemtoRV](https://github.com/BrunoLevy/learn-fpga/blob/master/FemtoRV/README.md) is a minimalistic RISC-V design, with easy-to-read Verilog sources directly written from the RISC-V specification. The most elementary version (quark), an RV32I core, weights 400 lines of VERILOG (documented version), and 100 lines if you remove the comments. We will be using quark version for our custom layout.

> List of issues we faced while sythesizing the available code: <a href="challenges"> Challenges </a>

## Standard cell layout design in Magic


### Magic + skywater-PDK installation

   - Follow this blog for [magic vlsi + skywater-pdk local installation guide](https://lootr5858.wordpress.com/2020/10/06/magic-vlsi-skywater-pdk-local-installation-guide/)
   - Or magic can also be invoked in pdks folder of Openlane installation directory: 
   ```/OpenLane/pdks/sky130A/libs.tech/magic``` <br>
   Under this directory run ```magic -T sky130A.tech &```
   
### Standard Cell layout
We will be creating designs in single height standard cell format, so the dimensions needs to be multiple of the single height which for sky130 has a nomenclature of unithd with dimensions 0.46 x 2.72 (w x h) for sky130_fd_sc_hd PDK variant. Thus, step 1 is to create a bounding box of width 1.38 x 2.72 (3w x h). <br>
- Not sure why this isn't working for me but we will see later, in magic tkcon window:
``` text
property FIXED_BBOX {0 0 138 272} 
```
- Followed by designing the inverter in magic, and making sure there are no DRC errors
<hr>

![inv_top_mag.png](https://github.com/gagana-05/Term-Project/blob/main/images/inv_top_mag.png)

<b> Note: </b> <br>
the layout is included in the repo can be viewed in magic layout window as magic -T sky130A.tech inv.mag &


### Create port definition

Once the layout is ready, the next step is extracting the LEF file for the cell. However, certain properties and definitions need to be set to the pins of the cell which aid the placer and router tool. For LEF files, a cell that contains ports is written as a macro cell, and the ports are the declared PINs of the macro. Our objective is to extract LEF from a given layout (here of a simple CMOS inverter) in standard format. Defining port and setting correct class and use attributes to each port is the first step. The easiest way to define a port is through Magic Layout window and following are the steps:

- In Magic Layout window, first source the .mag file for the design. Then ```Edit >> Text``` which opens up a dialogue box. <br>

![image](https://user-images.githubusercontent.com/82756709/230848333-0f928939-33f9-4b48-affb-6cc0188d0c85.png)

- For each layer, make a box on that particular layer and input a label name along with a sticky label of the layer name with which the port needs to be associated, ensure the port enable checkbox box is checked and default checkbox is unchecked as shown below:

Above two figures, port A ( in port ) and port Y ( out port ) are taken from the locali ( local interconnect ) layer. <br>

![image](https://user-images.githubusercontent.com/82756709/230848131-58346f34-c80b-4516-ab5c-09f9e4babedd.png)

Note:
The number mentioned in the text area next to the enable checkbox defines the order in which the ports will be written in LEF file.

For power and ground layer, can be done in same or different layer. Here, we have connected gnd and power are taken from metal 1 ( notice the text area beside sticky checkbox )


### Set port class and port use attributes

Once the port definition is done, the next step is to set port class and port use attributes. The "class" and "use" properties of the port have no internal meaning to magic but are used by the LEF and DEF format read and write routines, and match the LEF/DEF CLASS and USE properties for macro cell pins. <hr>
![port_def.png](https://github.com/gagana-05/Term-Project/blob/main/images/port_def.png)

### Defining and extracting LEF file in Magic

Certain properties need to be set before writing the LEF. There are specific property names associated with the LEF format. Once the properties are set, lef write command write the LEF file with the same nomenclature as that of the magic layout file.

![image](https://user-images.githubusercontent.com/82756709/230839326-d3f5ce3a-1ae4-4d89-908b-6b75d1731015.png)

### Extracting Spice file via magic 

Run the following commands in magic tkcon window to extract spice file:

```text
extract all
ext2spice cthresh 0 rthresh 0
ext2spice
```

In order to simulate the spice file necessary libraries and simulation source code is included, and model names are modified to given MOSFET definitions within the library. <br>
Simulation results: <hr>

![image](https://user-images.githubusercontent.com/82756709/230841613-0e1199f7-c5a0-4c2a-9289-0bbaf5f2f44f.png)
![image](https://user-images.githubusercontent.com/82756709/230841618-0d8765da-5072-4a46-a5e3-9136e0873edc.png)




## Plugging Custom LEF to OpenLane

In order to include the new standard cell in the synthesis, copy the sky130_vsdinv.lef file to the ```designs/femto/src directory```
Since abc maps the standard cell to a library abc there must be a library that defines the CMOS inverter. The sky130_fd_sc_hd__typical.lib file from [link](https://github.com/nickson-jose/vsdstdcelldesign/tree/master/libs) to be copied to the ```designs/femto/src directory``` (Note: the slow and fast library files may also be copied and modified according to custom cell design).

Open OpenLane Directory and enter:

```bash
make mount
```

List of commands:

```bash
./flow.tcl -design femto -init_design_config -add_to_designs
./flow.tcl -design femto
```

## Synthesis Exploration 

The first step in synthesis is determining the optimal synthesis strategy SYNTH_STRATEGY for your design. For that purpose there is a flag in the flow.tcl script, -synth_explore that runs a synthesis strategy exploration and reports the results in a table in a html file under `femto/reports/`.

```bash
./flow.tcl -design design_name -synth_explore
```
![synth_explore.png](https://github.com/gagana-05/Term-Project/blob/main/images/synth_explore.png)

### Regression and exploration

> [Issues #3](#issue-3)

## Interactive mode

```bash
./flow.tcl -interactive
```

Load the package file

```bash
package require openlane
0.9
```

<b>Note 1:</b> Now run the commands in the following sequence and ensure no steps are skipped

```bash
prep -design femto -tag full_guide
```

![interactive_flow.png](https://github.com/gagana-05/Term-Project/blob/main/images/interactive_flow.png)

Include the below command to include the additional lef (inv.lef) into the flow:

```text
set lefs [glob $::env(DESIGN_DIR)/src/*.lef]
add_lefs -src $lefs
```

![adding_lefs.png](https://github.com/gagana-05/Term-Project/blob/main/images/adding_lefs.png)

## Synthesis

### Review of files and Synthesis step:


```bash
run_synthesis
```


A "runs" folder is created under femto folder

Since we have used a -tag name to be full_guide, a folder with tag_name is created, if tag name is not mentioned a folder titled "today_date..." will be the directory under femto

> presynthesis

![preSynth.png](https://github.com/gagana-05/Term-Project/blob/main/images/preStat.png)

> post-synthesis

![postSynth.png](https://github.com/gagana-05/Term-Project/blob/main/images/postSynth.png)


<b>Calculation of Flop ratio</b>

```text
Flop ratio = Number of D Flip flops 
             ______________________
             Total Number of cells


dfxtp_4 = 1178,
Number of cells = 6709,
Flop ratio = 1178/6709 = 0.1755 = 17.55%
```

## Floorplanning

The objective is to design the layout of silicon area and establish a reliable power distribution network (PDN) for powering the various components of the synthesized netlist. Prior to placement, it is essential to determine the macro placement and blockages to ensure a compliant GDS file. <br>
To achieve this, a ring is created that connects to the pads to enable the transfer of power around the edges of the chip. Additionally, power straps are integrated to deliver power to the center of the chip through the use of higher metal layers, which minimizes issues related to IR drop and electro-migration.

```bash
run_floorplan
```

### Floorplanning Considerations

<b>Two parameters are of importance:</b>

### Utilization Factor and Aspect Ratio

```code
Utilisation Factor =  Area occupied by netlist
                     __________________________
                        Total area of core

Aspect Ratio =  Height
               ________
                Width
```

A Utilisation Factor of 1 signifies 100% utilisation leaving no space for extra cells such as buffer. However, practically, the Utilisation Factor is 0.5-0.6. Likewise, an Aspect ratio of 1 implies that the chip is square shaped. Any value other than 1 implies rectanglular chip.

Post the floorplan run, a .def file will have been created within the `results/floorplan` directory. To view the floorplan, Magic is invoked after moving to the `results/floorplan` directory:

```text
magic -T /home/gagana/OpenLane/pdks/sky130A/libs.tech/magic/sky130A.tech lef read ../../tmp/merged.max.lef def read femto.def
```

### layout
![floorplan_layout.png](https://github.com/gagana-05/Term-Project/blob/main/images/floorplan_layout.png)

#### <b>Helpfull Commands while exploring Magic </b>

- Zoom in (z)
- Zoom out (shift + z)
- Full view (v)
- Select region (s)

Various components can be identified by selecting and typing `what` in the tkcon window.

![selection.png](https://github.com/gagana-05/Term-Project/blob/main/images/selection_area.png)

> tkcon window <br>
![tkcon_window.png](https://github.com/gagana-05/Term-Project/blob/main/images/tkcon_window.png)

## Placement

The objective of placement is the convergence of overflow value. If overflow value progressively reduces during the placement run it implies that the design will converge and placement will be successful

```bash
run_placement
```

Postplacement the layout can be viewed in magic, by invoking Magic in `results/placement` and running:

```text
magic -T /home/gagana/OpenLane/pdks/sky130A/libs.tech/magic/sky130A.tech lef read ../../tmp/merged.max.lef def read femto.def
```

<b> layout </b>

> Expanded View
![placement_expand.png](https://github.com/gagana-05/Term-Project/blob/main/images/placement_expand.png)

<b> Note 2</b>:
Power distribution network generation is usually a part of the floorplan step. However, in the openLANE flow, floorplan does not generate PDN. The steps are - floorplan, placement CTS and then PDN


List of commands to be run in a sequential manner to complete the overall flow for RTL to GDSII layout

```text
run_cts
run_routing
write_powered_verilog 
set_netlist $::env(routing_logs)/$::env(femto).powered.v
run_magic
run_magic_spice_export
run_magic_drc
run_lvs
run_antenna_check

```

## Observation

> post-synthesis
![image](https://user-images.githubusercontent.com/82756709/230839672-e4632d55-968a-4a99-87c0-e0a0a1206dd6.png)


### Identifying custom made cell

```bash
getcell sky130_vsdinv
```

![image](https://user-images.githubusercontent.com/82756709/230839597-f2d27d49-9763-45a7-8025-ec7c1014b187.png)

### Cell After placement

![image](https://user-images.githubusercontent.com/82756709/230839797-2bee0f42-c07a-41ef-bc88-e6f5e4d6cdb3.png)

### Reports

#### Area
![image](https://user-images.githubusercontent.com/82756709/230839900-5756efe1-0bc1-4615-9a78-db8fd7061612.png)

#### Core Area

![image](https://user-images.githubusercontent.com/82756709/230840002-b8faa6f0-5eb1-443e-9b11-16d9de026e32.png)

#### Die Area

![image](https://user-images.githubusercontent.com/82756709/230840233-4bee0099-8e34-49cd-b391-b0979a7c061e.png)


####  Power (Total, Internal, Switching, Leakage)

![image](https://user-images.githubusercontent.com/82756709/230840272-7644a70c-0895-4cf8-bbe4-15093f5e2619.png)


## Team Members

- Gaganashree (201EC228)
- Priyanka Gawande (201EC250)

## Challenges

Very Helpful source : [Timing Closure of OpenSource Designs](https://docs.google.com/document/d/13J1AY1zhzxur8vaFs3rRW9ZWX113rSDs63LezOOoXZ8/edit#)

[Issues in detail with screenshots](https://docs.google.com/document/d/1WPB9M_3ZLJP0JGJ7WuvxG-3gWosTZSsQpdfXbrL1UGY/edit?usp=sharing) <br>

Issue #1 <br>
config.json file

``` json
{
    "DESIGN_NAME": "femto",
    "VERILOG_FILES": "dir::src/*.v",
    "CLOCK_PORT": "clk",
    "CLOCK_PERIOD": 10.0,
    "DESIGN_IS_CORE": true
}
```

Command:
``` bash 
./flow.tcl -design femto 
```
OpenLane Flow: <span style="color:red"> Flow Failed </span>

#### <b> Two files of importance:</b>
> 25-rcx_sta.worst_slack.rpt<br>
> metrics.csv <br>

Since we don’t have a hard requirement for clock frequency we can adjust the clock period to eliminate setup violations.
Tried setting up the clock time period to 15 ns and it worked!

<b>Setting</b>:
"CLOCK_PERIOD": 15.0


Command: 
``` bash 
./flow.tcl -design femto 
```
OpenLane Flow: <span style="color:green"> Flow Complete </span> <span style="color:yellow"> with [WARNING] fanout violation</span> 

Issue #2 : Configuring the config.json file to remove fanout violation

#### <b> Two files of importance: </b>
> 25-rcx_sta.max.rpt <br>
> 25-rcx_sta.worst_slack.rpt

OpenLane Flow:
max fanout violation count : <b>91</b>

<b>Setting</b>:
"SYNTH_MAX_FANOUT": 50

Issue #3: Flow fails when executing run_routing in interactive flow

> Opening logs file

![image](https://user-images.githubusercontent.com/82756709/230842139-0e12f7a9-f118-49f9-a22f-d0ca92fb35d7.png)

## References

https://github.com/nickson-jose/vsdstdcelldesign















