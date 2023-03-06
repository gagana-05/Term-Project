# VLSI Design Automation

<details>
  <summary>Table of Contents</summary>
    <ol>
        <li>
            <a href="#introduction-to-openlane-flow">Introduction to Openlane Flow</a>
        </li>
        <li>
            <a href="#overview-of-physical-design-flow">Overview of Physical Design Flow</a>
        </li>
    </ol>
</details>

### Introduction to OpenLane Flow
OpenLANE is a completely automated RTL to GDSII flow which embeds in it different opensource tools, namely, OpenROAD, Yosys, ABC, Magic etc., apart from many custom methodology scripts for design exploration and optimization.
Openlane is built around Skywater 130nm process node and is capable of performing full ASIC implementation steps from RTL all the way down to GDSII. The flow-chart below gives a better picture of openlane flow as a whole. <hr>
![Openlane_Flow](https://www.chipsalliance.org/news/improving-the-openlane-asic-build-flow-with-open-source-systemverilog-support/openlane-flow.png)
Image Coutersy: [Chips Alliance](https://www.chipsalliance.org/news/improving-the-openlane-asic-build-flow-with-open-source-systemverilog-support/)

### Overview of Physical Design Flow
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






