module Logs
#(
   parameter ERROR = 1,
   parameter INFO1 = 1,
   parameter INFO2 = 1,
   parameter INFO3 = 1,
   parameter INFO4 = 1,
   parameter INFO5 = 1
) ();

   localparam MSG_SIZE = 1023;

   task error
   (
      input [MSG_SIZE:0] msg
   );
      begin
         if( ERROR )
            $display("%t\t [ %m ] \t %s", $time, msg);
      end
   endtask

   task info1
   (
      input [MSG_SIZE:0] msg
   );
      begin
         if( INFO1 )
            $display("%t\t [ %m ] \t %s", $time, msg);
      end
   endtask

   task info2
   (
      input [MSG_SIZE:0] msg
   );
      begin
         if( INFO2 )
            $display("%t\t [ %m ] \t %s", $time, msg);
      end
   endtask

   task info3
   (
      input [MSG_SIZE:0] msg
   );
      begin
         if( INFO3 )
            $display("%t\t [ %m ] \t %s", $time, msg);
      end
   endtask

   task info4
   (
      input [MSG_SIZE:0] msg
   );
      begin
         if( INFO4 )
            $display("%t\t [ %m ] \t %s", $time, msg);
      end
   endtask

   task info5
   (
      input [MSG_SIZE:0] msg
   );
      begin
         if( INFO5 )
            $display("%t\t [ %m ] \t %s", $time, msg);
      end
   endtask

endmodule


