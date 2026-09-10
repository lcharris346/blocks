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
   Instructions : String := "a:left,d:right,w:drop,x:down,k:cw,l OR s:cw,";
   Rtn : Integer := 0;
   Shape_Coord_I : Shape_Coord := ((0,1), (0,0), (0,-1), (0,-2));
   Shape_Coord_J : Shape_Coord := ((0,1), (0,0), (0,-1), (-1,-1));
   Shape_Coord_L : Shape_Coord := ((0,1), (0,0), (0,-1), ( 1,-1));
   Shape_Coord_S : Shape_Coord := ((-1,0), (0,0), (0,1), (1,1));
   Shape_Coord_Z : Shape_Coord := ((-1,1), (0,0), (0,1), (1,0));
   Shape_Coord_O : Shape_Coord := ((1,0), (0,0), (0, 1), ( 1,1));
   Shape_Coord_T : Shape_Coord := ((-1,0), (0,0), (1,0), (0,1));

   Lttrs : String := "IJLSZOT";

   Up : Coord := (0,1);
   Up : Coord := (0,1);
   Up : Coord := (0,1);
   Up : Coord := (0,1);

   -- -------FUNCTIONS -----------

   -- ------Rows-----------

   function Rows_Update_Coords return Integer is
      Rtn : Integer := 0;
   begin
      Put_Line("DEBUG.Rows_Update_Coords");
      return Rtn;
   end Rows_Update_Coords;

   -- ------Shape---------
   function Shape_Init return Integer is
      Rtn : Integer := 0;
   begin
      Put_Line("DEBUG.Shape_Init");
      return Rtn;
   end Shape_Init;

   function Shape_Update_Coords return Integer is
      Rtn : Integer := 0;
   begin
      Put_Line("DEBUG.Shape_Update_Coords");
      return Rtn;
   end Shape_Update_Coords;

   function Shape_Rotate return Integer is
      Rtn : Integer := 0;
   begin
      Put_Line("DEBUG.Shape_Rotate");
      return Rtn;
   end Shape_Rotate;

   function Shape_Translate return Integer is
      Rtn : Integer := 0;
   begin
      Put_Line("DEBUG.Shape_Translate");
      return Rtn;
   end Shape_Translate;

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