with Text_Io;
procedure Blocks is
   
   -- Packages
   package Float_Io is new Text_Io.Float_Io(Float);
   package Int_Io is new Text_Io.Integer_Io(Integer);
   use Text_Io;
   use Float_Io, Int_Io;


   -- ------TYPES-------------
   type Coord is 
      record 
         X : Integer range -2 .. 2;
         Y : Integer range -2 .. 2;
      end record;

   type Shape_Coord is array (0 .. 3) of Coord;


   type Float_Array is array (0 .. 3) of Float;
   

   -- ------CONSTANTS--------
   Instructions : constant String := "a:left,d:right,w:drop,x:down,k:cw,l OR s:cw,";
   Rtn : Integer := 0;
   Shape_Coord_I : constant Shape_Coord := ((0,1), (0,0), (0,-1), (0,-2));
   Shape_Coord_J : constant Shape_Coord := ((0,1), (0,0), (0,-1), (-1,-1));
   Shape_Coord_L : constant Shape_Coord := ((0,1), (0,0), (0,-1), ( 1,-1));
   Shape_Coord_S : constant Shape_Coord := ((-1,0), (0,0), (0,1), (1,1));
   Shape_Coord_Z : constant Shape_Coord := ((-1,1), (0,0), (0,1), (1,0));
   Shape_Coord_O : constant Shape_Coord := ((1,0), (0,0), (0, 1), ( 1,1));
   Shape_Coord_T : constant Shape_Coord := ((-1,0), (0,0), (1,0), (0,1));

   Lttrs : constant String := "IJLSZOT";

   Up : constant Coord := (0,1);
   Down : constant Coord := (0,-1);
   Left : constant Coord := (-1,0);
   Right : constant Coord := (1, 0);

   Space : Character := '.';
   N_Spaces : constant Integer := 10;
   Range_Spaces : constant array(0 .. 9) of Integer := (0,1,2,3,4,5,6,7,8,9);
   Block : constant Character := 'O';
   N_Rows : constant Integer := 20;
   
   Matrix_Field : constant array(0 .. 19, 0 .. 9) of Character := (others => (others => Space));
   Range_Rows : constant array(0 .. 19) of Integer:= (0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19);
   
   -- -------FUNCTIONS -----------
   function Rotation_CW(Input_Coord : Coord) return Coord is
      New_Coord : Coord;
   begin
      New_Coord.X := Input_Coord.Y;
      New_Coord.Y := -1 * Input_Coord.Y;
      return New_Coord;
   end Rotation_CW;

   function Rotation_CCW(Input_Coord : Coord) return Coord is
      New_Coord : Coord;
   begin
      New_Coord.X := -1 * Input_Coord.Y;
      New_Coord.Y := Input_Coord.Y;
      return New_Coord;
   end Rotation_CCW;

   -- -------PACKAGES -----------
   package Shape is
      Rel_Coords : Coord;
      Coords : Coord;
      Ctr : Integer;
      function Init return Integer;
      function Update_Coords return Integer;
      function Rotate return Integer;
      function Translate return Integer;
   end Shape;

   package body Shape is
      Rtn : Integer := 0;
      function Init return Integer is
         Rtn : Integer := 0;
      begin
         Put_Line("DEBUG.Shape_Init");
         return Rtn;
      end Init;

      function Update_Coords return Integer is
         Rtn : Integer := 0;
      begin
         Put_Line("DEBUG.Shape_Update_Coords");
         return Rtn;
      end Update_Coords;

      function Rotate return Integer is
         Rtn : Integer := 0;
      begin
         Put_Line("DEBUG.Shape_Rotate");
         return Rtn;
      end Rotate;

      function Translate return Integer is
         Rtn : Integer := 0;
      begin
         Put_Line("DEBUG.Shape_Translate");
         return Rtn;
      end Translate;

   end Shape;

   -- ------Rows-----------
   package Rows is
      Rtn : Integer := 0;
      function Update_Coords return Integer;
   end Rows;
   package body Rows is
      function Update_Coords return Integer is
      begin
         Put_Line("DEBUG.Rows_Update_Coords");
         return Rtn;
      end Update_Coords;
   end Rows;

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
   function Main return Integer is

      Rtn : Integer :=  0;
      Key : Character  := 'x'; 
      Ctr : Integer :=  0;
      Score : Integer := 0;
      Lttr : Character := 'L';
      
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

   end Main;

begin
   -- Gather User Inputs
   Put_Line("INFO. Instructions:" & Instructions );
   New_Line;
   Rtn := Main;
   
end Blocks;