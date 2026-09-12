#!C:\Program Files\Python312\python
import random
import copy
import argparse
import time
from datetime import datetime
import msvcrt

########### UTILS ##################
# Constants
INSTRUCTIONS = "a OR ;=left,s OR '=right,x OR /=down,w OR p=drop,d OR l:cw,f or k:cw,"
LTTR_COORD = {
    "I":[[ 0,1], [0,0], [0,-1], [ 0,-2]],
    "J":[[ 0,1], [0,0], [0,-1], [-1,-1]],
    "L":[[ 0,1], [0,0], [0,-1], [ 1,-1]],
    "S":[[-1,0], [0,0], [0, 1], [ 1, 1]],
    "Z":[[-1,1], [0,0], [0, 1], [ 1, 0]],
    "O":[[ 1,0], [0,0], [0, 1], [ 1, 1]],
    "T":[[-1,0], [0,0], [1, 0], [ 0, 1]],
}
NORM_LTTR_COORD_KEYS = "IJLSZOT"
CARD = {
    "up": [0,1], "down": [0, -1],"right": [1,0], "left": [-1,0],
}
SPACE = "."

N_SPACES = 10
RANGE_SPACES = range(N_SPACES)
ROW = [SPACE for x in RANGE_SPACES]
BLOCK = "O"
ROWS_BLOCK = "H"
N_ROWS = 20
RANGE_ROWS = range(N_ROWS)
MATRIX = [copy.deepcopy(ROW) for x in range(N_ROWS)]

KEYS_TRANSLATIONS = {
    "a": "left",
    "l": "left",

    "d": "right",
    "'": "right",
    
    "w": "down",
    "p": "down",

    "x": "down",
    "/": "down",

    "u": "up"
}
KEYS_ROTATIONS = {
    "s": "cw",

    ";": "ccw",
}
# Functions

def unit_rotation_cw(xy):

    orig_x = xy[0]
    orig_y = xy[1]
    new_x = orig_y
    new_y = -1*orig_x

    return (new_x, new_y)

def unit_rotation_ccw(xy):

    orig_x = xy[0]
    orig_y = xy[1]
    new_x = -1*orig_y
    new_y = orig_x

    return (new_x, new_y)

def getch():
    key_char = "x"
    # Check if a keypress is waiting in the buffer
    while 1:
        if msvcrt.kbhit():
            # Read the key character (returns a byte string like b'a')
            key = msvcrt.getch()
            
            # Decode bytes to a string
            key_char = key.decode('utf-8', errors='ignore')
            #print(f"INFO. You pressed: {key_char} (Raw: {key})")
            break
    
    return key_char.lower()

################## CLASSES ######################

class Shape(object):
    def __init__(self):
        self.relative_coords = []
        self.coords = []
        self.center_coord = []


######################################## MAIN CLASS  ########################################
class Blocks(object):
    
    def __init__(self, args):
        self.score = 0
        self.rows = copy.deepcopy(MATRIX);
        self.shape = Shape()
        self.next_letter = "I" # random.choice(NORM_LTTR_COORD_KEYS)
        

    def update_coords(self):
        for ii, coord in enumerate(self.shape.coords):

            self.shape.coords[ii][0] = self.shape.center_coord[0] + self.shape.relative_coords[ii][0]
            self.shape.coords[ii][1] = self.shape.center_coord[1] + self.shape.relative_coords[ii][1]

    def rotate(self, _dir):
            if _dir == "cw":
                for ii, rel_coord in enumerate(self.shape.relative_coords):
                    self.shape.relative_coords[ii] = unit_rotation_cw(self.shape.relative_coords[ii])
            elif _dir == "ccw":
                for ii, rel_coord in enumerate(self.shape.relative_coords):
                    self.shape.relative_coords[ii] = unit_rotation_ccw(self.shape.relative_coords[ii])
    
            self.update_coords()
    
    def translate(self, card):
        if card in KEYS_TRANSLATIONS.values():
            self.shape.center_coord[0] += CARD[card][0]
            self.shape.center_coord[1] += CARD[card][1]

        self.update_coords()

    def move_shape(self, key):
            if key in KEYS_TRANSLATIONS.keys():
                move = KEYS_TRANSLATIONS[key]
                self.translate(move)
            elif key in KEYS_ROTATIONS.keys():
                move = KEYS_ROTATIONS[key]
                self.rotate(move)

    def shape_touched_down(self):
        shape_touched_down = False
        for coord in self.shape.coords:
            x,y = coord
            if y < 0 or self.rows[y][x] == ROWS_BLOCK:
                self.move_shape("u")
                shape_touched_down = True
                break

        return shape_touched_down

    def update_rows(self):
        
        for coord in self.shape.coords:
            x,y = coord
            self.rows[y][x] = ROWS_BLOCK
        
    def remove_full_rows(self):
        rows_dict = {}
        new_y = 0
        complete_row = [ROWS_BLOCK for x in RANGE_SPACES]
        new_rows = copy.deepcopy(self.rows)

        for old_y in RANGE_ROWS:

            new_rows[new_y] = copy.deepcopy(self.rows[old_y])

            if self.rows[old_y] == complete_row:
                self.score += 10
            else:
                new_y += 1
            
            old_y += 1
            
        
        self.rows = copy.deepcopy(new_rows)
        
    def print_matrix(self):
        # print matrix to screen
        print("\n\n\n\n\n\n\n\nScore:", self.score,"Next:", self.next_letter)

        for y in range(N_ROWS):
            y2 = N_ROWS - 1 - y
            row = copy.deepcopy(ROW)
            for x in range(N_SPACES):
                if [x,y2] in self.shape.coords:
                    row[x] = BLOCK
                elif self.rows[y2][x] == ROWS_BLOCK:
                    row[x] = ROWS_BLOCK
            row_str ="                " +  "".join(row)
            print(row_str)

    def get_new_shape(self):
        self.shape.relative_coords = copy.deepcopy(LTTR_COORD[self.next_letter])
        self.shape.coords = copy.deepcopy(self.shape.relative_coords)
        self.shape.center_coord = [4,17]
        self.update_coords()
        self.next_letter = random.choice(NORM_LTTR_COORD_KEYS)

    def run(self):

        key = "n"
        ctr = 1
        time1 = datetime.now()
        time_diff = 0
        self.get_new_shape()
        
        while key != "q":

            self.move_shape(key)   

            if self.shape_touched_down():
                # Add shape to rows
                self.update_rows()
                self.remove_full_rows()
                self.get_new_shape()
                key = "x"
                self.score += 1

            self.print_matrix()
            
            if key not in ("w","p"):
                if ctr % 2 == 0:
                    key = getch()
                    print("DEBUG. Key", key)
                    
                else:
                    if time_diff > 0.5:
                        key = "x"
                    else:
                        key = "n"

            ctr += 1
            time_diff = (datetime.now() - time1).total_seconds()
            time1 = datetime.now()

            

# Main Function
def main(args):
    print("INFO. Instructions:", INSTRUCTIONS)
    ch = Blocks(args)
    ch.run()

# Command-line Execution
if __name__=="__main__":
    parser = argparse.ArgumentParser(description="Blocks" + INSTRUCTIONS)
    args = parser.parse_args()
    main(args)
    



    
