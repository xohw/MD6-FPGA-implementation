import serial
import binascii
import tkinter as tk
from tkinter import ttk
from tkinter import messagebox


#Functions for receiving information from the user

def padded():
    """
    The essential purpose of the function is to facilitate 
    the preparation of data for UART transmission.
    This entails converting the message into byte format,
    if required, padding it with zeros, and sequentially
    concatenating all the pertinent data into a unified variable.
    """
    global data
    global padded_data 
    
    #padding and reverse - d
    d =int(data[5]) 
    d_bytes = d.to_bytes(2, byteorder='big')      
    padded_d = (d_bytes.ljust(16//8,b'\x00'))[::-1]    
    padded_data[1] = padded_d
    
    #padding and reverse - L
    L = int(data[6])
    L_bytes = L.to_bytes(1, byteorder='big')  
    #padding and reverse
    padded_L = (L_bytes.ljust(8//8,b'\x00'))[::-1]    
    padded_data[3] = padded_L
    
    #padding and reverse - r
    if(data[2]=="YES"):
        r = int(data[7])
    else:
        r =40 + d//4
    r_bytes = r.to_bytes(2, byteorder='big')
    padded_r = (r_bytes.ljust(16//8,b'\x00'))[::-1]
    padded_data[4] = padded_r

    #concatenation the data for transmit
    p = padded_data[0]+padded_data[1]+padded_data[2]+padded_data[3]+padded_data[4]+padded_data[5]+padded_data[6]+padded_data[7]
    return p


def save_data(answers):
    """The role of the function is to receive the data
       from the user and save it"""
    
    global data
    global Error
    
    #save the data 
    for d in answers:
        if not d.get():
            Error = "YES"
            return 
    for d in answers:
        data.append(d.get())

def save_data_2(parent, answers,words):   
    """The role of the function is to receive the message and the key
       and save them, and prepare them for transmiting"""
    global data
    global wi
    global Error
    
    type_data_M = data[3]
    type_data_K = data[4]
    
    #The diagnosis of the data and the creation of consumed data
    try:
        if (words=="K"):
            if(data[0]== "YES"):
                if not answers.get("1.0", "end-1c"):
                    Error = "YES"
                    return 
                K = answers.get("1.0", "end-1c")
                if(type_data_K == "ascii"):
                    if(len(K)>64):
                        raise ValueError('The key is larger than 512 bits!')
                    len_K = len(K) 
                    K_bytes = K.encode('utf-8')
                
                elif(type_data_K == "bin"):
                    if(len(K)>512):
                        raise ValueError('The key is larger than 512 bits!')
                    len_K = len(K)//8 if (len(K)%8 == 0) else ((len(K)//8) + 1)
                    K_bytes = int(K, 2).to_bytes((len(K) + 7) // 8, byteorder='big')
                else:
                    if(len(K)>128):
                        raise ValueError('The key is larger than 512 bits!')
                    len_K = len(K)//2 
                    K_bytes = bytes.fromhex(K) 
            else:
                len_K = 0
                K_bytes = b'\x00'
    
            keylen =len_K.to_bytes(1, byteorder='big')
            
            #padding and reverse
            padded_K = K_bytes.ljust(512//8,b'\x00')
            padded_keylen = (keylen.ljust(8//8,b'\x00'))[::-1]      
            
            #save the data 
            padded_data[2] = padded_K
            padded_data[5] = padded_keylen       

        elif (words=="M"): 
            if not answers.get("1.0", "end-1c"):
                Error = "YES"
                return 
            M = answers.get("1.0", "end-1c")
            if(type_data_M == "ascii"):
                if(len(M)>wi*512):
                    raise ValueError('The information is larger than wi*4096 bits!')#t
                len_M = len(M)*8
                M_bytes = M.encode('utf-8')
            elif(type_data_M == "bin"):
                if(len(M)>wi*4096):
                    raise ValueError('The information is larger than wi*4096 bits!')
                len_M = len(M)
                M_bytes = int(M, 2).to_bytes((len(M) + 7) // 8, byteorder='big')  #t
            else:
                if(len(M)>wi*1024):
                    raise ValueError('The information is larger than wi*4096 bits!')
                len_M = len(M)*4 
                M_bytes = bytes.fromhex(M)
            
            zero_M = wi*4096-len_M
            len_padded_M = zero_M.to_bytes(2, byteorder='big')
            
            
            #index_M = (len_M//512)
            #if(len_M*8 % 4096==0):
            #    index_M =index_M-1
            index_M = 0
            index_M_bytes = index_M.to_bytes(1, byteorder='big')
            
            #padding and reverse
            padded_M = M_bytes.ljust(wi*4096//8,b'\x00')                 
            padded_zero_M = (len_padded_M.ljust(16//8,b'\x00'))[::-1]
            padded_index_M = (index_M_bytes.ljust(8//8,b'\x00'))[::-1]
            
            #save the data 
            padded_data[0] = padded_M
            padded_data[6] = padded_zero_M
            padded_data[7] = padded_index_M
    except ValueError:
        Error="YES" 

#Function for creating TK templates

def create_combobox_default(parent, default , x, y):
    """The role of the function is to create a combobox in windows without
       the possibility of entering information"""
    
    #Create the Combobox widget
    combobox = ttk.Combobox(parent)
    combobox.set(default)
    combobox.configure(font=("Arial", 15), width=10, height=100,state='disabled')
    combobox.place(x=x, y=y)    
    return combobox
      
def create_combobox(parent, choices, x, y):
    """The role of the function is to create a combobox in windows"""
   
    #Create the Combobox widget
    combobox = ttk.Combobox(parent, values=choices)
    combobox.configure(font=("Arial", 15), width=10, height=100, state="readonly")
    combobox.config(postcommand=lambda:combobox.configure(height=5))
    combobox.place(x=x, y=y)
    return combobox

def create_label(parent, text, x, y):
    """The role of the function is to create text in windows"""
    
    #create_label
    label = tk.Label(parent, text=text, font=("Ariel", 15),bg="white")
    label.place(x=x, y=y)

def create_button(parent, text,answers):
    """The role of the function is to create a button for the windows of d,L,r and com  """
    
    #create_button
    button = tk.Button(parent, text=text, width=12, height=3, font=("Arial", 15),relief="groove",bg="#2BC3BC")
    button.configure(command=lambda: (save_data(answers), parent.destroy()))
    button.place(x=550, y=420)

    parent.wait_window()

def create_button_2(parent, text, answers,words):
    """The role of the function is to create a button for the message and key windows """

    #create_button
    button = tk.Button(parent, text=text, width=12, height=3, font=("Arial", 15),relief="groove", bg="#2BC3BC")
    button.configure(command=lambda: (save_data_2(parent,answers,words), parent.destroy()))
    button.place(x=550, y=420)
    parent.wait_window()
    
    
#Window formatting functions

def window_definition(parent,text):
    """ The role of the function is to design and configure the windows"""
    
    #title
    parent.title("MD6 Hash")
    parent.iconbitmap("chip.ico")

    #delete protocol
    parent.protocol("WM_DELETE_WINDOW", lambda: None)
    
    #size of windows
    parent.geometry("700x550")
    screen_width = root.winfo_screenwidth()
    screen_height = root.winfo_screenheight()

    # calculate the x and y coordinates of the center of the screen

    x = int((screen_width/2) - (700/2))
    y = int((screen_height/2) - (550/2))

    # set the window position to the center of the screen
    parent.geometry("+{}+{}".format(x, y))

    parent.resizable(False, False)

    # window design
    canvas = tk.Canvas(parent, width=700, height=100, bg="#2BC3BC")
    canvas.place(x=0, y=0)
    
    canvas.create_text(350, 50,text=text, font=("Imprint MT Shadow", 20,"bold"),fill="#0B07AB")
    
    frame = tk.Frame(parent, width=700, height=450, bg="white")
    frame.place(x=0, y=100)

#Windows functions
def window_7(hashed_data):
    """The window for receiving the hashed data from the user"""
    
    global root
    global data
    
    #create new window  
    window_7 = tk.Toplevel(root)
       
    #window_definition
    window_definition(window_7,"The hashed message")
    
    #M_data
    txt_hash = "the hashed message" 
    create_label(window_7, txt_hash, 10, 120)
    
    Hash = tk.Text(window_7)
    str_hash = hashed_data.decode('utf-8')
    Hash.insert("1.0",str_hash)
    Hash.configure(font=("Arial", 15), bg="white",state="disabled")
    Hash.place(x=10, y=180,width=600,height=180)
    
    #Button - finish
    button = tk.Button(window_7, text="finish", width=12, height=3, font=("Arial", 15), bg="#2BC3BC")
    button.configure(command=window_7.destroy)
    button.place(x=550, y=420)
    window_7.wait_window()
    return

def window_6(data_to_send):
    """The function is designed to receive the designated com
       port from the user, and transmit the data through the UART,
       and receive the hashed information back by the board"""
    global data
    global Baud_rate
    global root
    
    while True:
        try:
            #create new window  
            window_6 = tk.Toplevel(root)
               
            #window_definition
            window_definition(window_6,"COM number")

            #com
            choise_com = [f"COM{i}" for i in range(1,256)]
            
            txt_com = "Enter your com - COM{number} " 
            create_label(window_6, txt_com, 10, 120)
            com = create_combobox(window_6, choise_com, 550,120)    
            
            #Button - transmit
            create_button(window_6,"transmit", [com])
            num_com = data[8]
        
            ser = serial.Serial(num_com, Baud_rate) 
            
            break
        #Error for incorrect com
        except serial.SerialException:
                messagebox.showerror("ERROR", "The number of COM you gave is not appropriate! Enter again!")
                del data[8]
      
    # Transmit data to the FPGA board
    ser.write(data_to_send)
    d=int(data[5])
    
    # Read the response from the FPGA board
    received_data = ser.read(d//8) 
    hex_data = binascii.hexlify(received_data) 
 
    #print('Received encrypted data: ', hex_data)
    return hex_data 

def window_5():
    """The purpose of the function is to receive the
       d&L&r from the user and prepare it for sending"""
    global root
    global data
    global Error
    input_L_a,input_r_a = data[1],data[2]

    while True:
        Error = "NO"
        #create new window  
        window_5 = tk.Toplevel(root)
        
        #window_definition
        window_definition(window_5,"d & L & r")
        
        #choice boxes
        choices_d = [224,256,384,512]
        choices_L = [ i for i in range(0, 65)]
        choices_r = [ i for i in range(1, 169)]
        
        #d_data 
        txt_d = "Choose the length of the hashed port - d"
        create_label(window_5, txt_d, 10, 120)
        d_a = create_combobox(window_5, choices_d, 550,120)
        
        #L_data 
        txt_L = "Choose the model control - L"
        create_label(window_5, txt_L, 10, 180)
        if(input_L_a=="YES"):
            L_a = create_combobox(window_5, choices_L, 550,180)
        else:
            L_a = create_combobox_default(window_5, 64, 550,180)
            
        #r_data 
        txt_r = "Choose the number of rounds - r "
        create_label(window_5, txt_r, 10, 240)
    
        if(input_r_a=="YES"):
            r_a = create_combobox(window_5, choices_r, 550,240)
        else:
            r_a = create_combobox_default(window_5,"40+d/40" , 550,240)
          
        answers =[d_a,L_a,r_a]
        
        #Button - Next
        create_button(window_5,"next", answers)
        
        if(Error == "NO"):
            break    
        
        #error message
        messagebox.showerror("ERROR!", "You didn't fill in all the options!")
        
    return
 
def window_4():
    """The purpose of the function is to receive the key K
       from the user and prepare it for sending"""
    while True:
        global root
        global data
        global Error
        input_K_a = data[0]
        Error = "NO"
        #create new window  
        window_4 = tk.Toplevel(root)
           
        #window_definition
        window_definition(window_4,"The key - K")
        
        #K_data
        txt_K = "Enter the key value - K: "
        create_label(window_4, txt_K, 10, 120)
        if(input_K_a=="YES"):
            K_a = tk.Text(window_4,font=("Arial", 15), bg="white")
            K_a.place(x=10, y=180,width=600,height=180)
        else:
            K_a = create_combobox_default(window_4, 0 ,550,120)
               
        answers = K_a
        
        #Button - Next
        create_button_2(window_4,"next", answers,"K")
        if(Error == "NO"):
            break         
        
        #error message
        messagebox.showerror("ERROR", "The K you gave is not appropriate! Enter again!")
    return

def window_3():
    """The purpose of the function is to receive the message M
       from the user and prepare it for sending"""
    while True:
        global root
        global Error
        Error = "NO"
        
        #create new window  
        window_3 = tk.Toplevel(root)
               
        #window_definition
        window_definition(window_3,"The message - M")
    
        #M_data
        txt_M = "Enter the message - M" 
        create_label(window_3, txt_M, 10, 120)
    
        
        M_a = tk.Text(window_3,font=("Arial", 15), bg="white")
        M_a.place(x=10, y=180,width=600,height=180)
        
        answers= M_a
        create_button_2(window_3,"next", answers,"M")
        if(Error == "NO"):
            break    
                
        #error message
        messagebox.showerror("ERROR", "The M you gave is not appropriate! Enter again!")


    return
   
def window_2():
    """Algorithm definition questions window """
    global root
    global Error
    
    while True:
        Error = "NO"
        
        # create new window
        window_2 = tk.Toplevel(root)

        #window_definition
        window_definition(window_2,"Definition questions")
        
        #combobox
        choices_yes_or_no = ["YES", "NO"]
        choices_type = ["hex", "bin", "ascii"]
    
        #input_K_q
        input_K_q = "Would you want to set a key - K ?"
        create_label(window_2, input_K_q, 10, 120)
        input_K_a = create_combobox(window_2, choices_yes_or_no, 550,120)
    
        #input_L_q
        input_L_q = "Would you want to set a mode control - L ?"
        create_label(window_2, input_L_q, 10, 180)
        input_L_a = create_combobox(window_2, choices_yes_or_no, 550,180)
    
        #input_r_q
        input_r_q = "Would you want to set a number of rounds - r ?"
        create_label(window_2, input_r_q, 10, 240)
        input_r_a = create_combobox(window_2, choices_yes_or_no, 550,240)
    
        #input_type_data_m
        type_data_q =  "What type is your message of ?"
        create_label(window_2, type_data_q, 10, 300)
        type_data_M=create_combobox(window_2, choices_type, 550,300)
        
        #input_type_data_k
        type_data_q =  "What type is your key of ?"
        create_label(window_2, type_data_q, 10, 360)
        type_data_K=create_combobox(window_2, choices_type, 550,360)
        
        answers =[input_K_a,input_L_a,input_r_a,type_data_M,type_data_K]
        
        #button - next
        create_button(window_2,"next", answers)
        if(Error == "NO"):
            break    
        
        #error message
        messagebox.showerror("ERROR!", "You didn't fill in all the options!")
    return

def window_1b():
    """Algorithm instructions window """
    
    global root
    global wi
    global w
    # create new window
    window_1b = tk.Toplevel(root)
    
    #window_definition
    window_definition(window_1b,"INSTRUCTIONS")
    
    # create a frame for the text and scrollbar
    frame = tk.Frame(window_1b, bd=2, relief="sunken")
    frame.place(x=10, y=120, width=680, height=300)

    # create a scrollbar for the frame
    scrollbar = tk.Scrollbar(frame)
    scrollbar.pack(side="right", fill="y")

    # create a text widget for the text
    text = tk.Text(frame, wrap="word",font=("Arial", 15),padx=10,pady=10, yscrollcommand=scrollbar.set)
    text.pack(side="left", fill="both", expand=True)

    # add text to the widget
    text.insert("end",
    "1. Reset Button: To reset the algorithm, press the button - 'BTNU' on the board.\n\n"
    "2. Definition Questions Window: In this window, you will need to answer some questions"
    " to adjust the data entry. The questions are: Which of the optional data"
    " (K, L, r) do you want to enter? In what format do you want to enter the message - M and"
    " the key - K? (Note that K is optional, So when you decide not to insert a key - no matter"
    "  what you choose from the options.)\n\n"
    "3. Data entry windows: In these windows, you will need to enter your data."
    " Please note that if you enter incorrect data (in terms of data size or format) or do"
    " not fill in all the options, the software will require you to enter them again.\n\n"
    "4. COM port: the data is transferred to the board via UART serial communication."
    "To select the correct COM port, check the number of your COM port and select it from"
    " the options. If you choose an incorrect COM port, the program will prompt you to choose"
    " again.\n\n"
    "5. Sending and receiving data: Click the 'Send' button. To get the hashed data,"
    " check that the LD0 to LD7 leds are lit and press the button - 'BTNC' on the board.\n"
    "The hashed data will appear in a new window.")

    # configure scrollbar to work with the text widget
    scrollbar.config(command=text.yview)
    
    #button - next
    button = tk.Button(window_1b, text="next", width=12, height=3, font=("Arial", 15), bg="#37BBA2")
    button.configure(command=window_1b.destroy)
    button.place(x=550, y=420)
    window_1b.wait_window()
    return

def window_1a():
    """Algorithm introduction window"""
    global root
    global wi
    global w

    # create new window
    window_1a = tk.Toplevel(root)
    
    # window_definition
    window_definition(window_1a, "INTRODUCTION")

    # create a frame for the text and scrollbar
    frame = tk.Frame(window_1a, bd=2, relief="sunken")
    frame.place(x=10, y=120, width=680, height=300)

    # create a scrollbar for the frame
    scrollbar = tk.Scrollbar(frame)
    scrollbar.pack(side="right", fill="y")

    # create a text widget for the text
    text = tk.Text(frame, wrap="word",font=("Arial", 15),padx=10,pady=10, yscrollcommand=scrollbar.set)
    text.pack(side="left", fill="both", expand=True)

    # add text to the widget
    text.insert("end", 
    "MD6 is a cryptographic hash function that takes a message M as input,"
    " and produces a fixed-size output called a hash. The hash can be used to verify the integrity"
    "and authenticity of the message, as well as to securely store and transmit sensitive data.\n\n"
    "To use MD6, you need to provide a message M that you want to hash, and optionally a key K"
    " for message authentication.\n\n"
    f"the maximum size for the message - m is {wi*4096} bits, and for the key - K it is 512 bits.\n\n"
    "The digest size d, maximum tree height L (optionally), and number of rounds r (optionally)"
    " are parameters that you can customize to meet your specific security, speed, and memory requirements.\n\n"
    "The digest size d specifies the number of bits in the output hash, and must be from"
    " the following values 224,256,384 and 512.\n\n"
    "The maximum tree height L determines the number of levels in the hash tree that is used to"
    " compute the hash, and must be an integer between 0 and 64.\n\n"
    "The number of rounds r determines the number of iterations of the basic MD6 compression"
    " function that are used to compute the hash, and must be an integer between 0 and 168.")

    # configure scrollbar to work with the text widget
    scrollbar.config(command=text.yview)
    
    #button - next
    button = tk.Button(window_1a, text="next", width=12, height=3, font=("Arial", 15), bg="#37BBA2")
    button.configure(command=window_1a.destroy)
    button.place(x=550, y=420)
    window_1a.wait_window()
    return

def window_0():

    global root    
    root = tk.Tk()
    lock_img = tk.PhotoImage(file="lock_b2.png")

    
    #title
    root.title("MD6 Hash")
    root.iconbitmap("chip.ico")
    
    #size of windows
    screen_width = root.winfo_screenwidth()
    screen_height = root.winfo_screenheight()
    root.geometry("%dx%d+0+0" % (screen_width, screen_height))
    root.resizable(False, False)
    
    # create canvas
    canvas = tk.Canvas(root, width=screen_width, height=screen_height, bg="#EEE35A")
    canvas.place(x=0, y=0)
    
    # create main text
    canvas.create_text(screen_width//2, 200,text="WELCOME TO THE MD6 HASH", font=("Imprint MT Shadow" ,50,"bold"),fill="#0B07AB")

    #button - start
    start_button = tk.Button(root,image=lock_img, width=225, height=225, command=windows,borderwidth=0 , highlightbackground="#EEE35A", activebackground="#EEE35A", bg="#EEE35A")
    start_button.place(relx=0.5, rely=0.7, anchor=tk.CENTER)
    
    root.mainloop()

def windows():
    global data
    global padded_data 
    window_1a()
    window_1b()
    window_2() 
    window_3()
    window_4()
    window_5()
    data_to_send = padded()
    hash_data = window_6(data_to_send)
    window_7(hash_data)
    root.mainloop()

#main
def main():
    global wi
    global w
    global Baud_rate
    global data
    global padded_data 

    wi = 1
    w = 64
    Baud_rate = 9600
    data = []
    padded_data = [None]*8    

    window_0()

if __name__ == "__main__":
    main()
    