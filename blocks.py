#!C:\Program Files\Python312\python
import random
import copy
import argparse
import time
from datetime import datetime
import msvcrt

########### UTILS ##################
# Constants
INSTRUCTIONS = "a:left,d:right,w:drop,x:down,k:cw,l OR s:cw,"
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
N_ROWS = 20
MATRIX = [copy.deepcopy(ROW) for x in range(N_ROWS)]
RANGE_ROWS = range(N_ROWS)
KEYS_TRANSLATIONS = {
    "a": "left",
    "d": "right",
    "e": "up",
    "w": "down",
    "x": "down",
}
KEYS_ROTATIONS = {
    "l": "ccw",
    "k": "cw",
    "s": "cw",
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

# Classes
class Shape(object):

    def __init__(self, rel_coords):
        self.rel_coords = rel_coords
        self.coords = copy.deepcopy(rel_coords)
        self.ctr = [5,16]
        self.update_coords()

    def update_coords(self):
        for ii, coord in enumerate(self.coords):

            self.coords[ii][0] = self.ctr[0] + self.rel_coords[ii][0]
            self.coords[ii][1] = self.ctr[1] + self.rel_coords[ii][1]

    def rotate(self, _dir):
        if _dir == "cw":
            for ii, rel_coord in enumerate(self.rel_coords):
                self.rel_coords[ii] = unit_rotation_cw(self.rel_coords[ii])
        elif _dir == "ccw":
            for ii, rel_coord in enumerate(self.rel_coords):
                self.rel_coords[ii] = unit_rotation_ccw(self.rel_coords[ii])

        self.update_coords()

    def translate(self, card):
        if card in KEYS_TRANSLATIONS.values():
            self.ctr[0] += CARD[card][0]
            self.ctr[1] += CARD[card][1]

        self.update_coords()

class MatrixRows(object):
    def __init__(self):
        self.coords =  [[x,-1] for x in RANGE_ROWS]
        self.coords += [[x, 0] for x in [0,1,2,3,5,6,7,8,9]]
        self.coords += [[x, 1] for x in [1,2,6,7,8]]
        self.updated = False

    def update_coords(self, new_coords):
        self.coords += new_coords

######################################## MAIN CLASS  ########################################
class Blocks(object):
    
    def __init__(self, args):
        self.matrix = copy.deepcopy(MATRIX)
        self.rows = MatrixRows()
        self.complete_row = []
        self.score = 0
        self.next_letter = random.choice(NORM_LTTR_COORD_KEYS)
        
    def move_shape(self, key):
            if key in KEYS_TRANSLATIONS.keys():
                move = KEYS_TRANSLATIONS[key]
                self.shape.translate(move)
            elif key in KEYS_ROTATIONS.keys():
                move = KEYS_ROTATIONS[key]
                self.shape.rotate(move)

    def check_shape_landed(self):
            for rc in self.rows.coords:
                for tc in self.shape.coords:
                    if tc[0] == rc[0] and tc[1] == rc[1]:
                        self.move_shape("e")
                        return True

    def add_shape_to_rows(self):
        self.rows.update_coords(self.shape.coords)

    def remove_full_rows(self):
        rows_dict = {}
        self.complete_row = []
        for coord in self.rows.coords:
            if coord[1] < 0:
                continue
            if coord[1] not in rows_dict.keys():
                rows_dict[coord[1]] = []
            rows_dict[coord[1]].append(coord)

        new_coords = [[x,-1] for x in RANGE_ROWS]
        skeys = sorted(rows_dict.keys())
        new_y = min(skeys)
        for y in skeys:
            if y < 0 or len(rows_dict[y]) < 10:
                for ii in range(len(rows_dict[y])):
                    rows_dict[y][ii][1] = new_y
                new_coords += rows_dict[y]
                new_y += 1
            else:
                self.complete_row += rows_dict[y]
                
                self.score += 10

        if len(self.complete_row) > 0:
            print("INFO: line(s) removed!")
            self.update_matrix()
            time.sleep(0.5)
            self.complete_row = []
            
        self.rows.coords = new_coords

    def get_new_shape(self):
        self.shape = Shape(copy.deepcopy(LTTR_COORD[self.next_letter]))
        self.next_letter = random.choice(NORM_LTTR_COORD_KEYS)

    def update_matrix(self):

        self.matrix = copy.deepcopy(MATRIX)
                
        for coord in self.shape.coords:

            x = coord[0]
            y = coord[1]
            if x in RANGE_SPACES and y in RANGE_ROWS:
                self.matrix[y][x] = "O"

        for coord in self.rows.coords:

            x = coord[0]
            y = coord[1]

            if x in RANGE_SPACES and y in RANGE_ROWS:
                self.matrix[y][x] = "H"

        for coord in self.complete_row:

            x = coord[0]
            y = coord[1]
            if x in RANGE_SPACES and y in RANGE_ROWS:
                self.matrix[y][x] = "+"
            
        self.print_matrix()
        
    def print_matrix(self):
        print("Score:", self.score,"Next:", self.next_letter)
        for y in range(N_ROWS):
            row_str ="                " +  "".join(self.matrix[N_ROWS - 1 - y])
            print(row_str)

    def run(self):
        key = "x"
        ctr = 0
        self.get_new_shape()
        time1 = datetime.now()
        while key != "q":
            self.move_shape(key)   
            if self.check_shape_landed():
                self.add_shape_to_rows()
                self.remove_full_rows()
                self.get_new_shape()
                key = "x"
                self.score += 1

            self.update_matrix()
            if key != "w":
                if ctr % 2 == 0:
                    key = getch()
                else:
                    if time2 > 0.5:
                        key = "x"
                    else:
                        key = "n"
            ctr += 1
            time2 = (datetime.now() - time1).total_seconds()
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
    



    
