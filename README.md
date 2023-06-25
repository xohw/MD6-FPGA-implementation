
# MD6-FPGA-implementation
Name file: README


Team Number:				xohw23-084  
Project Name:				FPGA implementation of MD6 hash algorithm  
Link to YouTube Video:   https://youtu.be/c6ThYfS_pMA  
Link to Project repository:  https://github.com/xohw/MD6-FPGA-implementation.git  
Link to Full Demonstration Of Implementing The CF MD6 On FPGA video :	https://youtu.be/ZC4aacu0pbw  
University Name:			  Jerusalem College of Technology (JCT)  
Participant 1:				  Aviel Birduaker  
Participant 1 E-mail:			birduake@g.jct.ac.il  
Participant 2:				  Ofek Sharabi  
Participant 2 E-mail:			ofsharab@g.jct.ac.il  
Supervisor:				      Uri Stroh  
Supervisor E-mail:			stroh@jct.ac.il  
  
Board used:			        Basys 3 by Digilent Inc.  
Software Version:			Vivado 2022.1  

# Description of Project:  
Implementation of MD6 Hash algorithm in Verilog language in Artix-7 FPGA of Basys3 board.  


# Description of Archive:
* "MD6_CF_prototype" folder contains the prototype design files of our project, intended for reference purposes only and not for use in the final implementation.

* The "MD6_CF" folder includes all the relevant code files for our design, which are ready to be implemented.

* Within the "Documents" folder, you will find two reports. The first report, "MD6_report_Ron_Rivest," provides a detailed description of the MD6 hash function and was submitted as an entry in the NIST SHA-3 hash function competition. The second report is the submission for the Xilinx open hardware contest. It also includes the Basys3 data sheets and another pdf file which provides clarification on synthesis warnings that arose during the implementation process.

* The "Software" folder contains the MD6 software wrapper and the test vectors software. Both of these folders include implementations in both GUI and Python code.

* Lastly, the "VISIO" folder contains two block diagrams that are included in our report.  

# Implementation of the algorithm on the board:  

**Part 1: Board Setup**  

		1.  Connect the board to the computer using a USB cable.  
		2.  Open Vivado and create a new RTL project.  
		3.  Under 'Add Sources', include all the source codes (.v, .mem, .vh) from MD6_CF/Code files.   
		4.  In 'Add Constraints', add the xdc file from MD6_CF/XDC file. 
		5.  In 'Default Part', select the required chip: Artix-7, XC7A35T1CPG236C (speed -1).  
		6.  Run Synthesis, Implementation, and generate the Bitstream.  
		7.  Program the device.  

**Part 2: PC Setup**  

		1.  Check the "COM" number connected to the board in the device manager of your computer.  
		2.  Based on the loaded XDC file, press the reset button "BTNU" on the board (top button).  
		3.  Open the "MD6_CF.exe" from Software/MD6_CF Software/GUI App. 
		4.  Select the message and key type you want to insert.  
		5.  Enter the message - M.  
		6.  Enter the key - K (optional).   
		7.  Choose the length of the hashed message - d.  
		8.  Choose the mode control - L (optional).  
		9.  Choose the number of rounds - r (optional).  
		10. Enter the COM number.  
		11. Check that all the LD0-LD7 lights are on (This means that the data has been arrived). 
		    and LD8 is on (This means that message has been hashed).  
		12. Press the "BTNC" button on the panel (the middle button) for receiving the hashed message.  


# Instructions for running the test vectors:

		1.  Implementation of the algorithm on the board as described above.
		2.  Open the "Test_vector.exe" from Software/Test Vectors Software/GUI App.
		3.  Enter the COM number of your computer
		4.  Select the number of test vectors you want to run
		5.  When "reset" instruction appears on the screen, press the reset button BTNU and press the "Enter" shown on the screen
		6.  Check that all the LD0-LD7 lights are on (This means that the data has been arrived) 
		    and LD8 is on (This means that message has been hashed).
		7.  Press the "BTNC" button on the panel (the middle button) for receiving the hashed message
		8.  If you selected more than single test vector, repeat instructions 5-7 for as many selection
		    vectors as you selected
		9.  After finishing running the program, an csv file will be created which contains the
	 	    comparsion results b/w the HW and SW implementations. 

# Python Libraries

The libraries required to run the algorithm by a Python file as follows (Not relevant for the GUI files since they are included automatically):

**For MD6_CF**  

		1. serial
		2. binascii
		3. tkinter

**For Test_vector**  

		1. serial
		2. random
		3. secrets
		4. string
		5. pandas
		
	
