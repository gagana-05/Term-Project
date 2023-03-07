# VLSI Design Automation

<details>
  <summary>Table of Contents</summary>
    <ol>
        <li>
            <a href="#introduction-to-openlane-flow">Introduction to Openlane Flow</a>
        </li>
        <li>
            <a href="#physical-design-flow">Physical Design Flow</a>
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
    </ol>
</details>

### Introduction to OpenLane Flow
OpenLANE is a completely automated RTL to GDSII flow which embeds in it different opensource tools, namely, OpenROAD, Yosys, ABC, Magic etc., apart from many custom methodology scripts for design exploration and optimization.
Openlane is built around Skywater 130nm process node and is capable of performing full ASIC implementation steps from RTL all the way down to GDSII. The flow-chart below gives a better picture of openlane flow as a whole. <hr>
![Openlane_Flow](https://www.chipsalliance.org/news/improving-the-openlane-asic-build-flow-with-open-source-systemverilog-support/openlane-flow.png)
Image Coutersy: [Chips Alliance](https://www.chipsalliance.org/news/improving-the-openlane-asic-build-flow-with-open-source-systemverilog-support/)

### Physical Design Flow
Place and Route (PnR) is the core of any ASIC implementation and Openlane flow integrates into it several key open source tools which perform each of the respective stages of PnR. Below are the stages and the respective tools that are called by openlane for the functionalities as described: 

1. Synthesis
   - [yosys](https://github.com/YosysHQ/yosys) : Generating gate level netlist
   - [abc](https://github.com/YosysHQ/yosys)  : Performing Cell mapping
   - [OpenSTA](https://github.com/The-OpenROAD-Project/OpenSTA) : Performing pre-layout STA
2. Floorplanning
   - [init_fp](https://github.com/The-OpenROAD-Project/OpenROAD/tree/master/src/init_fp) : Defining the core area for the macro as well as the cell sites and the tracks.
   - [ioplacer](https://github.com/The-OpenROAD-Project/ioPlacer/) : Placing the macro input and output ports.
   - [pdn](https://github.com/The-OpenROAD-Project/pdn/) : Generating the power distribution network.
3. Placement
4. Clock Tree Synthesis (CTS)
5. Routing
6. GDSII generation

Follow this link for brief overview on OpenLane and its installation: [Openlane docs](https://openlane.readthedocs.io/en/latest/)

### LEF Overview
Library Exchange Format (LEF) file serves the purpose of protecting intellectual property and is basically of two types:
- Cell LEF - It's an abstract view of the cell and only gives information about PR boundary, pin position and metal layer information of the cell, information necessary for PnR tool to correctly place and route a block.
* Technology LEF - It contains information about available metal layer, via information, DRCs of particular technology used by placer and router etc.. The below diagram highlights the difference between a layout and a LEF (Image Courtesy: Google): <br>

![image](https://user-images.githubusercontent.com/82756709/223063425-f41c19bf-6c9d-4222-9050-bb3887edb66b.png) <hr>

### Objective
The goal of this project is to design a single height standard cell and plug this custom cell into a more complex design and perform its PnR in the Openlane Flow.The standard cell chosen is CMOS inverter and the design into which it is plugged is prebuilt [femtoRV32](https://github.com/BrunoLevy/learn-fpga/blob/master/FemtoRV/RTL/PROCESSOR/femtorv32_quark.v) core.

### About FemtoRV32

### Standard cell layout design in Magic
1. #### Magic + skywater-PDK installation 
   - Follow this blog for [magic vlsi + skywater-pdk local installation guide](https://lootr5858.wordpress.com/2020/10/06/magic-vlsi-skywater-pdk-local-installation-guide/)
2. 














