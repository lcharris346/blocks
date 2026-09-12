with Text_Io;
procedure Blocks is
   
   -- Packages
   package Float_Io is new Text_Io.Float_Io(Float);
   package Int_Io is new Text_Io.Integer_Io(Integer);
   use Text_Io;
   use Float_Io, Int_Io;



   -- ------TYPES-------------
   type Type_Float_Array4 is array (0 .. 3) of Float;

   -- For Coordinates --
   type Type_Coord is 
      record 
         X : Integer range -2 .. 2;
         Y : Integer range -2 .. 2;
      end record;

   -- For Rows --
   type Type_Rows_Coords is array (0 .. 180) of Type_Coord;

   type Type_Rows is
      record
         Coords : Type_Rows_Coords;
         Count :  Integer;
      end record

   -- For Shapes --
   type Type_Shape_Coord is array (0 .. 3) of Type_Coord;

   type Type_Ltr_Shape_Coord is
      record
         Ltr : Character;
         Coord : Type_Shape_Coord;
      end record;

   type Type_Shape is 
      record
         Relative_Coords : Type_Shape_Coord;
         Coords : Type_Shape_Coord;
         Center_Coord : Type_Coord;

      end record;

   -- For Cardinal Directions  & Coordinates --
   type Type_String_Coord is
      record
         Str : String;
         Coord : Type_Coord;
      end record;

   -- For Key Translation and Rotation Coordinates --
   type Type_Char_String is
      record
         Char : Character;
         Str: String;
      end record;


   -- ------CONSTANTS--------
   Instructions : constant String := "a:left,d:right,w:drop,x:down,k:cw,l OR s:cw,";
   Rtn : Integer := 0;

   Ltr_Shape_Coord_Array      : array(0 .. 6) of Type_Ltr_Shape_Coord;
   Ltr_Shape_Coord_Array(0)   := ('I', (( 0, 1), (0,0), ( 0,-1), ( 0,-2)));
   Ltr_Shape_Coord_Array(1)   := ('J', (( 0, 1), (0,0), ( 0,-1), (-1,-1)));
   Ltr_Shape_Coord_Array(2)   := ('L', (( 0, 1), (0,0), ( 0,-1), ( 1,-1)));
   Ltr_Shape_Coord_Array(3)   := ('S', ((-1, 0), (0,0), ( 0, 1), ( 1, 1)));
   Ltr_Shape_Coord_Array(4)   := ('Z', ((-1, 1), (0,0), ( 0, 1), ( 1, 0)));
   Ltr_Shape_Coord_Array(5)   := ('O', (( 1, 0), (0,0), ( 0, 1), ( 1, 1)));
   Ltr_Shape_Coord_Array(6)   := ('T', ((-1, 0), (0,0), ( 1, 0), ( 0, 1)));

   Range_Ltrs : constant array(0 .. 6) of Integer := (0,1,2,3,4,5,6);

   Card : array(0 .. 6) of Type_String_Coord := (("up",( 0, 1)), ("down",( 0,-1)), ("right",( 1, 0)), ("left",( 1, 0)));

   Space : constant Character := '.';
   N_Spaces : constant Integer := 10;
   Range_Spaces : constant array(0 .. 9) of Integer := (0,1,2,3,4,5,6,7,8,9);
   Block : constant Character := 'O';

   N_Rows : constant Integer := 20;

   Coord_Reset : constant Type_Coord := ( -1, -1);
   
   Key_Translations  : array(0 .. 7) of Type_Char_String := ( ('a', "left"), ('l', "left"), ('d', "right), (''', "right"), ('w', "down"), ('p', "down"), ('x', "down"), ('/', "down"), ('u', "up"));
   Key_Rotations     : array(0 .. 2) of Type_Char_String := ( ('s', "cw"), (';', "ccw") );

   












   -- VARIABLES ----
   
   Shape : Type_Shape := ((),(),());

   Rows  : Type_Rows;
   Rows.Coords := (others => Coord_Reset); 
   Rows.Count  := 0;














   -- -------FUNCTIONS -----------
   -- Array Access


   -- Constants
   function Get_Lttr_Type_Coord(ltr : Character) return Type_Coord_Array4 is
      Lttr_Type_Coord : Type_Coord_Array4;
   begin
      case 

   end Get_Lttr_Type_Coord;










   function Rotation_CW(Input_Type_Coord : Type_Coord) return Type_Coord is
      New_Type_Coord : Type_Coord;
   begin
      New_Type_Coord.X := Input_Type_Coord.Y;
      New_Type_Coord.Y := -1 * Input_Type_Coord.Y;
      return New_Type_Coord;
   end Rotation_CW;

   function Rotation_CCW(Input_Type_Coord : Type_Coord) return Type_Coord is
      New_Type_Coord : Type_Coord;
   begin
      New_Type_Coord.X := -1 * Input_Type_Coord.Y;
      New_Type_Coord.Y := Input_Type_Coord.Y;
      return New_Type_Coord;
   end Rotation_CCW;

   -- -------PACKAGES -----------

   

   -- ----------Main Functions---------------
   function Get_New_Shape return Integer is
      Rtn : Integer := 0;
   begin
      Put_Line("DEBUG.Get_New_Shape");
      return Rtn;
   end Get_New_Shape;

   function Move_Shape return Integer is
      Rtn : Integer := 0;
   begin
      Put_Line("DEBUG.Move_Shape");
      return Rtn;
   end Move_Shape;

   function Check_Shape_Landed return BOOLEAN is
      Rtn : BOOLEAN := TRUE;
   begin
      Put_Line("DEBUG.Check_Shape_Landed");
      return Rtn;
   end Check_Shape_Landed;

   function Add_Shape_To_Rows return Integer is
      Rtn : Integer := 0;
   begin
      Put_Line("DEBUG.Add_Shape_To_Rows");
      return Rtn;
   end Add_Shape_To_Rows;

   function Remove_Full_Rows return Integer is
      Rtn : Integer := 0;
   begin
      Put_Line("DEBUG.Remove_Full_Rows");
      return Rtn;
   end Remove_Full_Rows;

   function Print_Matrix return Integer is
      Rtn : Integer := 0;
   begin
      Put_Line("DEBUG.Print_Matrix");
      return Rtn;
   end Print_Matrix;

   function Update_Matrix return Integer is
      Rtn : Integer := 0;
   begin
      Rtn := Print_Matrix;
      return Rtn;
   end Update_Matrix;

   

   -- -------------Main-----------------
   procedure Run is


      Key : Character  := 'x'; 
      Ctr : Integer :=  0;
      Score : Integer := 0;
      Lttr : Character := 'L';
      Matrix_Field : array(0 .. 19, 0 .. 9) of Character := (others => (others => Space));
      Rows : array(<>)
   begin
      Rtn := Get_New_Shape;

      While Key /= 'q' loop

         Rtn := Move_Shape;

         if Check_Shape_Landed then

            Rtn := Add_Shape_To_Rows;
            Rtn := Remove_Full_Rows;
            Rtn := Get_New_Shape;
            Key := 'x';
            Score := Score + 1;

         end if;

         Rtn := Update_Matrix;

         Put_Line("Score: " & Integer'Image(Score) & ", Next: " & Lttr);

         if Key /= 'w' then

            if Ctr mod 2 = 0 then

               Text_IO.Get_Immediate(Key);

            else 

               Key := 'x';

            end if;

         end if;

      end loop;

      return Rtn;

   end Run;

begin
   -- Gather User Inputs
   Put_Line("INFO. Instructions:" & Instructions );
   New_Line;
   Run;
   
end Blocks;