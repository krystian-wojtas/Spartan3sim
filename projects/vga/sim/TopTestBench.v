module TopTestBench (
    // color control
    output reg BTN_NEXT = 1'b0,
    output reg BTN_PREV = 1'b0
);

    initial begin

       // nastepny kolor
        #300;
        BTN_NEXT = 1'b1;
        #250;
        BTN_NEXT = 1'b0;

       // nastepny kolor
        #500;
        BTN_NEXT = 1'b1;
        #250;
        BTN_NEXT = 1'b0;

       // poprzedni kolor
        #300;
        BTN_PREV = 1'b1;
        #250;
        BTN_PREV = 1'b0;

    end

endmodule
