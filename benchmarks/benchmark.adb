with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Calendar; use Ada.Calendar;

procedure Benchmark is
   function Fibonacci (N : Integer) return Long_Long_Integer is
   begin
      if N < 2 then
         return Long_Long_Integer (N);
      else
         return Fibonacci (N - 1) + Fibonacci (N - 2);
      end if;
   end Fibonacci;

   function Fibonacci_Iterative (N : Integer) return Long_Long_Integer is
      Prev : Long_Long_Integer := 0;
      Curr : Long_Long_Integer := 1;
   begin
      for I in 1 .. N loop
         declare
            Next_Value : constant Long_Long_Integer := Prev + Curr;
         begin
            Prev := Curr;
            Curr := Next_Value;
         end;
      end loop;
      return Prev;
   end Fibonacci_Iterative;

   function Count_Primes (Limit : Integer) return Long_Long_Integer is
      Is_Prime : array (0 .. Limit) of Boolean := (others => True);
      Total : Long_Long_Integer := 0;
   begin
      if Limit >= 0 then
         Is_Prime (0) := False;
      end if;
      if Limit >= 1 then
         Is_Prime (1) := False;
      end if;

      for Number in 2 .. Integer (Sqrt (Long_Long_Float (Limit))) loop
         if Is_Prime (Number) then
            for Multiple in Number * Number .. Limit loop
               exit when Multiple > Limit;
               Is_Prime (Multiple) := False;
            end loop;
         end if;
      end loop;

      for I in 0 .. Limit loop
         if Is_Prime (I) then
            Total := Total + 1;
         end if;
      end loop;

      return Total;
   end Count_Primes;

   function Sqrt (Value : Long_Long_Float) return Long_Long_Float is
      X : Long_Long_Float := Value;
      Y : Long_Long_Float := 1.0;
   begin
      while abs (X - Y) > 0.000001 loop
         X := (X + Y) / 2.0;
         Y := Value / X;
      end while;
      return X;
   end Sqrt;

   Fibonacci_Input : Integer := 37;
   Prime_Limit : Integer := 2_000_000;
   Numeric_Iterations : Integer := 2_000_000;
   Start : Time;
   Finish : Time;
   Fibonacci_Result : Long_Long_Integer;
   Prime_Result : Long_Long_Integer;
   Numeric_Result : Long_Long_Integer := 0;
   Fibonacci_Time : Long_Duration;
   Prime_Time : Long_Duration;
   Numeric_Time : Long_Duration;
begin
   Start := Clock;
   Fibonacci_Result := Fibonacci (Fibonacci_Input);
   Finish := Clock;
   Fibonacci_Time := Finish - Start;

   Start := Clock;
   Prime_Result := Count_Primes (Prime_Limit);
   Finish := Clock;
   Prime_Time := Finish - Start;

   Start := Clock;
   for I in 1 .. Numeric_Iterations loop
      Numeric_Result := Numeric_Result + Fibonacci_Iterative (Fibonacci_Input);
   end loop;
   Finish := Clock;
   Numeric_Time := Finish - Start;

   Put (Long_Float (Fibonacci_Time), Fore => 6, Aft => 6, Exp => 0);
   Put (",");
   Put (Long_Float (Prime_Time), Fore => 6, Aft => 6, Exp => 0);
   Put (",");
   Put (Long_Float (Numeric_Time), Fore => 6, Aft => 6, Exp => 0);
   Put (",");
   Put (Long_Long_Integer'Image (Fibonacci_Result), 1);
   Put (",");
   Put (Long_Long_Integer'Image (Prime_Result), 1);
   Put (",");
   Put (Long_Long_Integer'Image (Numeric_Result), 1);
   New_Line;
end Benchmark;
