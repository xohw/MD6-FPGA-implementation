import serial
import random
import secrets
import string
import pandas as pd




class hardware_class:
    
    def M_fun(self,M,type_data):
        
        if(type_data == "ascii"):
            len_M = len(M)*8
            M_bytes = M.encode('utf-8')
        
        elif(type_data == "binary"):
            len_M = len(M)
            M_bytes = int(M, 2).to_bytes((len(M) + 7) // 8, byteorder='big')  #t
        else:
            len_M = len(M)*4 
            M_bytes = bytes.fromhex(M)
        zero_M = wi*4096-len_M
        len_padded_M = zero_M.to_bytes(2, byteorder='big')
        

        index_M = 0
        #index_M = (len_M//4096)
        #if(len_M % 4096 ==0):
        #    index_M =index_M-1
        index_M_bytes = index_M.to_bytes(1, byteorder='big')
        
        
        padded_M = M_bytes.ljust(wi*4096//8,b'\x00')                 
      
        padded_zero_M = (len_padded_M.ljust(16//8,b'\x00'))[::-1]
          
        padded_index_M = (index_M_bytes.ljust(8//8,b'\x00'))[::-1]
        
        return [padded_M,padded_zero_M,padded_index_M]

    def d_fun(self,d):
        
        d_bytes = d.to_bytes(2, byteorder='big')      
        padded_d = (d_bytes.ljust(16//8,b'\x00'))[::-1]            
        return padded_d

    def K_fun(self,K,type_data):
        if(K != None):
            if(type_data == "ascii"):
                len_K = len(K) 
                K_bytes = K.encode('utf-8')
            
            elif(type_data == "binary"):
                len_K = len(K)//8 if (len(K)%8 == 0) else ((len(K)//8) + 1)
                K_bytes = int(K, 2).to_bytes((len(K) + 7) // 8, byteorder='big')
      
            else:
                len_K = len(K)//2 
                K_bytes = bytes.fromhex(K) 
        else:
            len_K = 0
            K_bytes = b'\x00'

        keylen =len_K.to_bytes(1, byteorder='big')

        padded_K = K_bytes.ljust(512//8,b'\x00')
        padded_keylen = (keylen.ljust(8//8,b'\x00'))[::-1]      
            
        return [padded_K,padded_keylen]

    def L_fun(self,L):
        L_bytes = L.to_bytes(1, byteorder='big')  
        padded_L = (L_bytes.ljust(8//8,b'\x00'))[::-1]      
        
        return padded_L

    def r_fun(self,r):
        r_bytes = r.to_bytes(2, byteorder='big')
        padded_r = (r_bytes.ljust(16//8,b'\x00'))[::-1]
        return padded_r

    def input_data(self):
        #vector = [type_M,type_K,M,d,K,L,r]
        type_M,type_K = vector[0],vector[1]
        M,d,K,L,r = vector[2],vector[3],vector[4],vector[5],vector[6]

        #M
        data_M = self.M_fun(M,type_M)
        padded_M,padded_zero_M,padded_index_M = data_M[0],data_M[1],data_M[2]
        
        #d
        padded_d = self.d_fun(d)
                   
        #K                
        data_K = self.K_fun(K,type_K)
        padded_K,padded_keylen = data_K[0],data_K[1]
               
        #L      
        padded_L = self.L_fun(L)     
        #r
        padded_r = self.r_fun(r)
            
        #all the information
        data_to_send = padded_M + padded_d + padded_K + padded_L + padded_r + padded_keylen + padded_zero_M + padded_index_M 
        #print(binascii.hexlify(data_to_send))
        
        return data_to_send
        
    def uart(self,data_to_send,d):
        
        ser = serial.Serial(num_com, br) 
        
        ser.write(data_to_send)
        
        received_data = ser.read(d//8) 
         
        hex_data = '0x' + received_data.hex()
        hard_hash.append(hex_data)
        print('HARDWARE: ', hex_data)
        
        return
    
    def __init__(self):
        data = self.input_data()
        reset = input("reset! ")
        data_to_send = data
        self.uart(data_to_send,vector[3])
        
class software_class:


    def V_fun(self):
        
        zero = '0'*4
        z = "0001"
        padd_m = len(self.M_binary) if (type_M != "binary") else len(M)
        p = (64*w -padd_m)
        p_pad = (bin(p)[2:]).rjust(16, '0')
        V = zero + self.r_pad +  self.L_pad + z + p_pad + self.keylen_pad + self.d_pad
        return V

    def U_fun(self):
        ell = "00000001"
        i = '0'*56
        U = ell+i
        return U

    def N_fun(self):
        self.N = [None]*89
        #Q
        for i in range (0,15):
            self.N[i]=int(bin(Q[i])[2:],2)
        #K
        for i in range(0,8):
            self.N[i+15] = int(self.K_pad[(0+w*i):(64+w*i)],2)
        #U
        U = self.U_fun()
        self.N[23] = int(U,2)
        #V
        V = self.V_fun()
        self.N[24] = int(V,2)
        #B
        for i in range(0,64):
            self.N[i+25] = int(self.M_pad[(0+w*i):(64+w*i)],2)

    def CF(self):
        
        t=r*c 
        A = [None]*(n+t)
        self.B = [None]*(n+t)

        for i in range(0,n):
            A[i]=self.N[i]
            self.B[i]=hex(A[i])

        for j in range(0,r):
            for i in range(n+j*c,n+(j+1)*c):
                x = S[j]^A[i-n]^A[i-t0]
                x = x^(A[i-t1]&A[i-t2])^(A[i-t3]&A[i-t4])
                x = x^(x>>r_shift[(i-n)%16])
                x = x^(x<<l_shift[(i-n)%16])
                A[i] = x&((1 << w)-1)
                self.B[i] = hex(A[i]).lstrip("0x").zfill(16)   
        #print(self.B)
        

    def data_hash(self):
                
        C = [None]*((d//64)+1)
        for i in range (1,d//64 + 2):
            C[-i]=(self.B[-i])
        C_str = [i for i in C]
        C_d =''.join(C_str)
        C_d = "0x" + C_d[-(d//4):] 

        print('SOFTWARE: ',C_d)
        return C_d

    def M_fun(self):
        
        if(type_M == "ascii"):
            self.M_binary = ''.join(format(ord(char), '08b') for char in M)
               
        elif(type_M == "binary"):
            self.M_binary = (8-len(M)%8)*'0'+ M
            
        elif(type_M == "hex"):
            self.M_binary=''.join(bin(int(M[i:i+2], 16))[2:].zfill(8) for i in range(0, len(M), 2))

        self.M_pad = self.M_binary.ljust(64*w, '0')
       

    def d_fun(self):
        self.d_pad = (bin(d)[2:]).rjust(12, '0')
        
        

    def K_fun(self):
            
        if(K != None):        
            if(type_K == "ascii"):
                K_binary = ''.join(format(ord(char), '08b') for char in K)
                   
            elif(type_K == "binary"):
                K_binary = (8-len(K)%8)*'0'+ K
        
            elif(type_K == "hex"):
                K_binary=''.join(bin(int(K[i:i+2], 16))[2:].zfill(8) for i in range(0, len(K), 2))

            keylen = len(K_binary)//8 
            #print(keylen)
            self.keylen_pad = (bin(keylen)[2:]).rjust(8, '0')
            self.K_pad = K_binary.ljust(8*w, '0')
        else:
            keylen = 0
            self.keylen_pad = '0'*8
            self.K_pad = '0'*8*w
        
        

    def L_fun(self):
        self.L_pad = (bin(L)[2:]).rjust(8, '0')
        

    def r_fun(self):
        self.r_pad = (bin(r)[2:]).rjust(12, '0')
        

    def data_input(self):
        global type_M,type_K
        global M,d,K,L,r
        type_M,type_K = vector[0],vector[1]
        M,d,K,L,r = vector[2],vector[3],vector[4],vector[5],vector[6]

    def data(self):
        self.data_input()
        self.M_fun()
        self.d_fun()      
        self.K_fun()
        self.L_fun()
        self.r_fun()    

    def __init__(self):
        
        self.data()
        self.N_fun() 
        self.CF()
        C = self.data_hash()
        soft_hash.append(C)
        

class md6_class:
    
    def constant(self):
        
        global wi,w,c,n
        global t0,t1,t2,t3,t4
        global r_shift,l_shift
        global Q,S
        global br
        
        br = 9600

        wi = 1
        w = 64
        c = 16
        n = 89
        t0,t1,t2,t3,t4 = 17,18,21,31,67
        
        r_shift = [10,5,13,10,11,12,2,7,14,15,7,13,11,7,6,12]
        
        l_shift = [11,24,9,16,15,9,27,15,6,2,29,8,15,5,31,9]
        
        Q = [ 
        0x7311c2812425cfa0, 0x6432286434aac8e7, 0xb60450e9ef68b7c1, 0xe8fb23908d9f06f1,
        0xdd2e76cba691e5bf, 0x0cd0d63b2c30bc41, 0x1f8ccf6823058f8a, 0x54e5ed5b88e3775d,
        0x4ad12aae0a6d6031, 0x3e7f16bb88222e0d, 0x8af8671d3fb50c2c, 0x995ad1178bd25c31,
        0xc878c1dd04c4b633, 0x3b72066c7a1552ac, 0x0d6f3522631effcb ]
        
        S = [
        0x0123456789abcdef, 0x0347cace1376567e, 0x058e571c26c8eadc, 0x0a1cec3869911f38,
        0x16291870f3233150, 0x3e5330e1c66763a0, 0x4eb7614288eb84e0, 0xdf7f828511f68d60,
        0xedee878b23c997e1, 0xbadd8d976792a863, 0x47aa9bafeb25d8e7, 0xcc55b5def66e796e,
        0xd8baeb3dc8f8bbfd, 0xe165147a91d1fc5b, 0xa3cb28f523a234b7, 0x6497516b67646dcf,
        0xa93fe2d7eaec961e, 0x736e072ef5fdaa3d, 0x95dc0c5dcfdede5a, 0x3aa818ba9bb972b5,
        0x475031f53753a7ca, 0xcdb0636b4aa6c814, 0xda7084d795695829, 0xe6f1892e2ef3f873,
        0xaff2925c79c638c7, 0x7cf5a6b8d388790f, 0x89facff1a710bb1e, 0x12e55d626a21fd3d,
        0x37cbfac4f462375a, 0x5c963709cce469b4, 0xe93c6c129dec9ac8, 0xb36898253ffdbf11,
        0x55d1b04b5bdef123, 0xfab2e097b7b92366, 0x877501ae4b5345ed, 0x0dfb03dc96a7ce7b,
        0x1ae70539296a52d6, 0x27cf0a7372f4e72c, 0x6c9f16e7c5cd0978, 0xb92f2f4e8f9f1bd0,
        0x435f5c9d1b3b3c21, 0xc5aff9bb36577462, 0xca5e33f748abace5, 0xd6ac656f9176d56b,
        0xff588ade22c96ff7, 0x8da1973c6593904f, 0x1a42ac78ef26a09f, 0x2685d8f1fa69c1be,
        0x6f0a7162d4f242dc, 0xbd14a2c5adc4c738, 0x4b39c70a7f8d4951, 0xd5624c14db1fdba2,
        0xfbc4d829b63a7ce5, 0x848970524854b56b, 0x0913a0a490adeff7, 0x1336c1c9217e104e,
        0x357d431362d8209c, 0x5bebc427e5b041b8, 0xe4d6484eef40c2d0, 0xa9bcd09dfa814721,
        0x726961bad503c963, 0x96d383f5ae065be6, 0x3fb6856a7808fc6d, 0x4c7d8ad4d01134fa,
        0xd8ea9729a0236d54, 0xe1d5ac52606797a9, 0xa2bad8a4e0eaa8f3, 0x676571c9e1f5d947,
        0xadcba312e3ce7b8e, 0x7a96c425e798bc9d, 0x873d484aeb31f5ba, 0x0d6bd095f6422ed5,
        0x1bd661aac884532a, 0x24bc83d5910ce574, 0x6969852a221d0fc8, 0xb3d28a54643f1010,
        0x54b596a8ec5b2021, 0xf97aafd1fcb74062, 0x83e5dd22dd4bc0e5, 0x04ca7a45be96416b,
        0x0994b68a5928c3f6, 0x1239ef94b271444c, 0x36621da944c3cc98, 0x5ec43bd38d8655b0,
        0xef8875261f08eec0, 0xbc10aa4c3a111301, 0x4831d69854232503, 0xd0726fb0ac674f06,
        0xf0f49de17cebd10d, 0x91f9bb43ddf6631b, 0x32e2f486bfc88537, 0x57c5298d5b918f4e,
        0xfc8b539bb722919c, 0x8917e5b64a65a2b9, 0x133e0bec94eec7d3, 0x356c15592df94826,
        0x5bd82ab37fd3d86c, 0xe4a057e7dba678f8, 0xa940ed4eb768b951, 0x73811a9d4af1fba3,
        0x940337bb95c23ce6, 0x38076df62f84756d, 0x400f9b6c7b0caffa, 0xc01eb4d8d61dd054,
        0xc02de931a83e60a9, 0xc05a1262705881f3, 0xc0a426c4c0b18247, 0xc1484f098142868f,
        0xc390dc1202858b9f, 0xc4317824050e9cbf, 0xc873b0480e19b5df, 0xd0f6e0901832ee3f,
        0xf1fd01a03045125f, 0x92eb03c0408f26bf, 0x37d70500811b4bdf, 0x5cbf0a010237dc3e,
        0xe96f1603044a745c, 0xb3df2e070c94acb9, 0x54af5e0f1d2dd5d3, 0xf95ffe1f3e7e6e26,
        0x83ae3e3f58d8926d, 0x045c7e7fb1b1a6fb, 0x08a8befe4342cb56, 0x1151ff7c86855dac,
        0x33b23cf9090ff6f8, 0x54747973121a2b50, 0xf8f8b2e724345da0, 0x81e1e74f6c4cf6e1,
        0x02c20c9ffc9d2b63, 0x078419bedd3f5de6, 0x0c0833fdbe5bf66c, 0x1810657a58b62af8,
        0x20308af4b1485f50, 0x607197694290f1a0, 0xa0f2acd3852122e0, 0x61f5d9260e634761,
        0xa2fa724c18e7c9e2, 0x67e4a69831ea5a65, 0xacc9cfb043f4feea, 0x79925de087cd3375,
        0x8234fb410b9f65ca, 0x06793483173b8e15, 0x0ee369872a56922a, 0x1fc7938f74a9a674,
        0x2c8ea59fcd72cac8, 0x791dcbbe9ec55f10, 0x832a55fd398ff120, 0x0554eb7b531a2361,
        0x0bb914f7a63445e2, 0x1463296e684cce64, 0x38c752dcf09d52e8, 0x418fe739c13fe770,
        0xc21e0c72825a09c0, 0xc62c18e504b41a01, 0xce58314b0d4c3e03, 0xdea062971e9c7207,
        0xef4087af393ca60f, 0xbd818ddf525dca1f, 0x4a029b3fa4be5e3f, 0xd605b47e6d58f25e,
        0xfe0ae8fcfeb126bd, 0x8e151179d9434bdb, 0x1e3b22f2b287dc37, 0x2e674765450a744e,
        0x7ecfcccb8e14ac9c, 0x8f9e5916182dd5b8, 0x1c2cf22c307e6ed1, 0x2859265840d89322 ]
    
    
    def num_vectors(self):
        #num_vectors = 10
        while True:
            try:
                num_vectors = int(input("Select the number of test vectors you want to test: ")) 
                break
            except ValueError:
                print("You did not choose a whole number!")
        return num_vectors

    def com(self):
        global num_com
        while True:
            try:
                num_com = input("Enter your com (for example 'COM4'): ") 
                if (num_com not in {f"COM{i}" for i in range(256)}):
                    raise ValueError("The value you entered for 'num_com' does not match!")
                break
            except ValueError:
                print("The answer you gave is not appropriate! Enter again! ")
    
    def generate_random_hex(self,num_bits):
        num_bytes = (num_bits + 7) // 8  
        num_hex_digits = num_bytes * 2  
        random_bytes = secrets.token_bytes(num_bytes)
        random_hex = random_bytes.hex()[:num_hex_digits]
        return random_hex

    def generate_random_binary(self,num_bits):
        random_binary = bin(secrets.randbelow(2**num_bits))[2:]
        return random_binary.zfill(num_bits)

    def generate_random_ascii(self,num_bytes):
        characters = string.ascii_letters + string.digits + string.punctuation
        random_ascii = ''.join(secrets.choice(characters) for _ in range(num_bytes))
        return random_ascii

    def Random_M_K(self,type_data,max_size):
        
        type_functions = {
        "hex":    self.generate_random_hex,
        "binary": self.generate_random_binary,
        "ascii":  self.generate_random_ascii,
        }
        
        if type_data in type_functions:
            if type_data == "hex":
                max_size //= 4
            elif type_data == "ascii":
                max_size //= 8
        
            random_size = secrets.randbelow(max_size) + 1
            random_info = type_functions[type_data](random_size)
            return(random_info)
        
    def test_vector(self):
        #[type_M,type_K,M,d,K,L,r]
        type_data = ["binary","hex","ascii",None]
        size_d = [224,256,384,512]
        
        type_M = random.choice(type_data[0:3])
        type_K = random.choice(type_data)
        
        M = self.Random_M_K(type_M,64*w)
        K = self.Random_M_K(type_K,8*w) if (type_K != None) else None
        
        d = random.choice(size_d)
        L = secrets.randbelow(65)
        r = secrets.randbelow(169)
        
        vector = [type_M,type_K,M,d,K,L,r]
        return  vector
    
    def send(self,vector_array, soft_hash, hard_hash):
        equal = ["True" if soft_hash[i] == hard_hash[i] else "false" for i in range(len(soft_hash))]
        data_send = {"Vector": vector_array, "Software": soft_hash, "Hardware": hard_hash, "Comparison Result": equal}
        df = pd.DataFrame(data_send)
        results = 'results.csv'
        df.to_csv(results, index=False)



    def __init__(self):
        global vector
        global vectors
        global soft_hash
        global hard_hash
        vectors = []
        soft_hash = []
        hard_hash = []
        self.com()
        num_random = self.num_vectors()
        self.constant()
        for i in range(num_random):
            vector = self.test_vector()
            vectors.append(vector)
            software_class()
            hardware_class()
        vector_array = [f"vector-{i}" for i in range(1, num_random+1)]
        self.send(vector_array,soft_hash,hard_hash)


if __name__ == "__main__":
   md6_class()
    
    