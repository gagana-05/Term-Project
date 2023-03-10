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

[FemtoRV](https://github.com/BrunoLevy/learn-fpga/blob/master/FemtoRV/README.md) is a minimalistic RISC-V design, with easy-to-read Verilog sources directly written from the RISC-V specification. The most elementary version (quark), an RV32I core, weights 400 lines of VERILOG (documented version), and 100 lines if you remove the comments. We will be using quark version for our custom layout.

> List of issues we faced while sythesizing the available code: <a href="challenges"> Challenges </a>

### Standard cell layout design in Magic

1. #### Magic + skywater-PDK installation

   - Follow this blog for [magic vlsi + skywater-pdk local installation guide](https://lootr5858.wordpress.com/2020/10/06/magic-vlsi-skywater-pdk-local-installation-guide/)

2. #### Standard Cell layout

3. #### Create port definition

4. #### Set port class and port use attributes

### Defining and extracting LEF file in Magic

## Plugging Custom LEF to OpenLane

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

The first decision in synthesis is determining the optimal synthesis strategy SYNTH_STRATEGY for your design. For that purpose there is a flag in the flow.tcl script, -synth_explore that runs a synthesis strategy exploration and reports the results in a table in a html file under <code> femto/reports/</code>.

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

![synthesis.png](https://github.com/gagana-05/Term-Project/blob/main/images/synthesis.png)

A "runs" folder is created under femto folder

![runs_synth.png](https://github.com/gagana-05/Term-Project/blob/main/images/runs_synth.png)

Since we have used a -tag name to be full_guide, a folder with tag_name is created, if tag name is not mentioned a folder titled "today_date..." will be the directory under femto

![tag_name.png](https://github.com/gagana-05/Term-Project/blob/main/images/tag_name.png)

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

![floorplan.png](https://github.com/gagana-05/Term-Project/blob/main/images/floorplan.png)

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

Post the floorplan run, a .def file will have been created within the <code>results/floorplan</code> directory. To view the floorplan, Magic is invoked after moving to the <code>results/floorplan</code> directory:

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

Various components can be identified by selecting and typing <code>what</code> in the tkcon window.

![selection.png](https://github.com/gagana-05/Term-Project/blob/main/images/selection_area.png)
![tkcon_window.png](https://github.com/gagana-05/Term-Project/blob/main/images/tkcon_window.png)

## Placement

The objective of placement is the convergence of overflow value. If overflow value progressively reduces during the placement run it implies that the design will converge and placement will be successful

```bash
run_placement
```
![placement.png](https://github.com/gagana-05/Term-Project/blob/main/images/placement.png)

Postplacement the layout can be viewed in magic, by invoking Magic in <code>results/placement</code> and running:

```text
magic -T /home/gagana/OpenLane/pdks/sky130A/libs.tech/magic/sky130A.tech lef read ../../tmp/merged.max.lef def read femto.def
```

<b> layout </b>

![placement_layout.png](https://github.com/gagana-05/Term-Project/blob/main/images/placement_layout.png)

> Expanded View
![placement_expand.png](https://github.com/gagana-05/Term-Project/blob/main/images/placement_expand.png)

<b> Note 2</b>:
Power distribution network generation is usually a part of the floorplan step. However, in the openLANE flow, floorplan does not generate PDN. The steps are - floorplan, placement CTS and then PDN


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
"SYNTH_MAX_FANOUT": 20

OpenLane Flow: 
max fanout violation count: <b>12</b>

<b>Setting:</b>
"SYNTH_MAX_FANOUT": 30 <br>

OpenLane Flow:
max fanout violation count: <b>6</b>

Observation: 
- We observe that as the limit to max fanout at output is increased, fanout after the design flow also increases. (Not sure why?)

We will try resolving this warning a little later and move on to next step of synthesizing the module

#### Issue 3














