import random
import numpy as np
from PIL import Image
from cocotb.types import Bit, Logic, LogicArray

class driver_monitor ():

    def __init__(self, hdl):
        self.hdl = hdl
        self._up_valid_probability = 50               #Change up_valid probability here
        self._down_ready_probability = 50             #Change down_ready probability here
        self._max_active_pops = 768                   #Change max number of active POPs here
        self._max_xpointer = 63
        self._max_ypointer = 47
        self._outputpic_size_x = 32
        self._outputpic_size_y = 24
        self._mode = 0
        self._pointer = 0
        self._xpointer = 0
        self._ypointer = 0
        self._xpointer_produce = 0
        self._ypointer_produce = 0
        self._prevpush = False
        self._activepops = 0
        self.keepsim = True

        img = Image.open('greyscale_orig.png' )
        self._inputpic = np.array( img, dtype='uint8' )
        self._max_xpointer = int(self._inputpic.shape[1] - 1)
        self._max_ypointer = int(self._inputpic.shape[0] - 1)
        self._max_active_pops = int(self._inputpic.shape[1] * self._inputpic.shape[0] / 4)

        self._outputpic_size_y = int(self._inputpic.shape[0] / 2)
        self._outputpic_size_x = int(self._inputpic.shape[1] / 2)
        self._outputpic = np.zeros([self._outputpic_size_y, self._outputpic_size_x], dtype='uint8')


    def __del__(self):
        pass

    def gen_up_valid_data_no_tlast (self):
        if (self.hdl.up_valid.value.binstr == "1" and self._prevpush == False):
            self.hdl.up_valid.value = Bit("1")            #unconfirmed valid must remain up as per AXI
        else:
            if (random.randrange (1, 100) <= self._up_valid_probability):
                self.hdl.up_valid.value = Bit("1")        #bring new valid data, tlast, tuser
                print("POINTER", self._pointer)
                self.hdl.up_data.value = LogicArray("10101010")
                self.hdl.up_tlast.value = Bit("1")
                self.hdl.up_tuser.value = Bit("0")
            else:
                self.hdl.up_valid.value = Bit("0")

    def gen_up_valid_data (self):
        if (self.hdl.up_valid.value.binstr == "1" and self._prevpush == False):
            self.hdl.up_valid.value = Bit("1")            #unconfirmed valid must remain up as per AXI
        else:
            if (random.randrange (1, 100) <= self._up_valid_probability):
                self.hdl.up_valid.value = Bit("1")        #bring new valid data, tlast, tuser
                print("X_Y_POINTER", self._xpointer, self._ypointer)
                self.hdl.up_data.value = LogicArray('{0:08b}'.format(self._inputpic[self._ypointer][self._xpointer]))
                if (self._xpointer == self._max_xpointer):
                    self.hdl.up_tlast.value = Bit("1")
                else:
                    self.hdl.up_tlast.value = Bit("0")
                if (self._xpointer == 0 and self._ypointer == 0):
                    self.hdl.up_tuser.value = Bit("1")
                else:
                    self.hdl.up_tuser.value = Bit("0")
            else:
                self.hdl.up_valid.value = Bit("0")


    def gen_down_ready (self):
        if (random.randrange (1, 100) <= self._down_ready_probability):
            self.hdl.down_ready.value = Bit("1")    #ready may go up or down as per AXI
        else:
            self.hdl.down_ready.value = Bit("0")


    def setinterfacesignals (self):
        if (self._mode == 0):                        #Set meaningful signal values
            self.hdl.rst.value = Bit("0")
            self.hdl.up_valid.value = Bit("0")
            self.hdl.up_data.value = LogicArray("00000000")
            self.hdl.up_tlast.value = Bit("0")
            self.hdl.up_tuser.value = Bit("0")
            self.hdl.down_ready.value = Bit("0")

        elif (self._mode == 1):                      #Assert reset
            self.hdl.rst.value = Bit("1")

        elif (self._mode == 2):                      #Remove reset
            self.hdl.rst.value = Bit("0")
            self.hdl.up_valid.value = Bit("0")

        elif (self._mode == 3):                      #Generate empty string before SOF
            self.gen_up_valid_data_no_tlast()
            self.gen_down_ready()

        elif (self._mode == 4):                      #Generate frame
            self.gen_up_valid_data()
            self.gen_down_ready()

        elif (self._mode == 5):                      #Wait till last Activepop
            self.hdl.up_valid.value = Bit("0")
            self.gen_down_ready()

        elif (self._mode == 6):                      #Wait few cycles
            self.hdl.up_valid.value = Bit("0")
            self.gen_down_ready()

        else:
            pass


    def checkpush(self):
        if (self._mode == 0):                        #Set meaningful signal values
            if (self._pointer == 20):                #For 20 cycles
                self._pointer = 0
                self._mode = 1
                print("GotoMode1")
            else:
                self._pointer = self._pointer + 1
        elif (self._mode == 1):                      #Assert reset
            if (self._pointer == 3):                 #For 3 cycles
                self._pointer = 0
                self._mode = 2
                print("GotoMode2")
            else:
                self._pointer = self._pointer + 1
        elif (self._mode == 2):                      #Remove reset
            if (self._pointer == 2):                 #For 2 cycles
                self._pointer = 0
                self._mode = 3
                print("GotoMode3")
            else:
                self._pointer = self._pointer + 1

        elif (self._mode == 3):                      #Generate empty string prior to SOF
            if (self.hdl.up_valid.value.binstr == "1" and self.hdl.up_ready.value.binstr == "1"):
                print("SKIPPEDPUSH_WAIT_SOF, ", self._pointer, self.hdl.up_data.value.binstr, self.hdl.up_tlast.value.binstr, self.hdl.up_tuser.value.binstr)
                self._prevpush = True
                if (self._pointer == 20):
                    self._pointer = 0
                    self._mode = 4
                    print("GotoMode4")
                else:
                    self._pointer = self._pointer + 1
            else:
                print("NO_SKIPPEDPUSH_WAIT_SOF")
                self._prevpush = False

        elif (self._mode == 4):                      #Generate frame
            if (self.hdl.up_valid.value.binstr == "1" and self.hdl.up_ready.value.binstr == "1"):
                print("PUSH, ", self._pointer, self.hdl.up_data.value.binstr, self.hdl.up_tlast.value.binstr, self.hdl.up_tuser.value.binstr)
                self._prevpush = True
                if (self._xpointer == self._max_xpointer and self._ypointer == self._max_ypointer):
                    self._xpointer = 0
                    self._ypointer = 0
                    self._mode = 5
                    print("GotoMode5")
                elif (self._xpointer == self._max_xpointer and self._ypointer != self._max_ypointer):
                    self._xpointer = 0
                    self._ypointer = self._ypointer + 1
                elif (self._xpointer != self._max_xpointer):
                    self._xpointer = self._xpointer + 1
                else:
                    pass
            else:
                print("NO_PUSH")
                self._prevpush = False

        elif (self._mode == 5):                      #Wait till last POP
            if (self._activepops == self._max_active_pops):
                print("Reached maximum number of POPs:", self._max_active_pops)
                self._mode = 6
                print("GotoMode6")
            else:
                pass

        elif (self._mode == 6):                      #Wait few cycles
            if (self._pointer == 10):
                self._pointer = 0
                self.keepsim = False                 #Do exit here
                print("GotoExit")
            else:
                self._pointer = self._pointer + 1

        else:
            pass

    def checkpop(self):
        if (self.hdl.down_valid.value.binstr == "1" and self.hdl.down_ready.value.binstr == "1"):
            self._outputpic[self._ypointer_produce][self._xpointer_produce] = int(self.hdl.down_data.value.binstr, 2)
            if (self.hdl.down_tlast.value.binstr == "1"):
                self._xpointer_produce = 0
                self._ypointer_produce = self._ypointer_produce + 1
            else:
                self._xpointer_produce = self._xpointer_produce + 1
            self._activepops = self._activepops + 1

    def produceimg(self):
        print("Saving Final Image")
        image = Image.fromarray(self._outputpic, mode="L")
        image.save('greyscale_min.png')
