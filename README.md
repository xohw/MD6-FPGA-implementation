# MD6-FPGA-implementation
Name file: README


Team Number:				xohw23-084  
Project Name:				FPGA implementation of MD6 hash algorithm  
Link to YouTube Video:   
Link to Project repository:  
  
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
* "MD6 old" folder includes the prototype design of our project. Not for use.  
* "MD6 codes" folder includes in it the all relevent Verilog codes of our design. Ready for implementation.   
* "videos" folder contain the video  
.............  

# Instruction to built and test the project:
	
	Implementation of the algorithm on the board:	
		1.  Connect the board to the computer by using the USB cable.
		2.  Open vivado > create project > RTL project.
		3.  In "Add Sources", Add all the source codes (.v) from "MD6 codes" folder.
		4.  In "Add constraint", Add the xdc file from "MD6 codes" folder.
		5.  In Default Part, Choose the required chip: Artix-7, XC7A35T1CPG236C (speed -1)
		6.  Run Synthesys, Implementation and generate BitStream.
		7.  Program the device.
# Message hashing:
		1.  Check the "COM" number connected to the board in the device manager of your computer.
		2.  Based on the loaded XDC file, press the reset button "BTNU" on the board (top button).
		3.  Open the "md6_interface.py" python file.
		4.  Select the message and key type you want to insert.
		5.  Enter the message - M.
		6.  Enter the key - K (optional). 
		7.  Choose the length of the hashed message - d.
		8.  Choose the mode control - L (optional).
		9.  Choose the number of rounds - r (optional).
		10. Enter the COM number
		11. Check that all the LD0-LD7 lights are on (This means that the data has been arrived) 
		    and LD8 is on (This means that message has been hashed).
		12. Press the "BTNC" button on the panel (the middle button) for receiving the hashed message


# Instructions for running the test vector:

		1.  Implementation of the algorithm on the board as described above.
		2.  Open the "test_vector.py" python file.
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
