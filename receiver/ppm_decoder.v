module PPM(
    clk,
    rst,
    din,
    dout,
    d_en,   // byte received
    f_en);  // frame start
       
    input clk,rst;
    input din;
    output [7:0] dout;
    output d_en,f_en;
    reg [7:0] dout;
    reg d_en,f_en;

    reg [3:0] count0;   // sample at count0 == 15
    reg [2:0] count1;   // get symbol at count1 == 8
    reg [2:0] count2;   // get byte at count2 == 4

    reg [7:0] reg1;  // PPM code
    reg [7:0] reg2;  // raw code
    reg cs,ns;
    // // debug -------
    // wire sample;
    // assign sample = count0 == 15;
    // // --- end debug
    parameter  SOF=8'b01111011,
               EOF=4'b1101,
               d_00=8'b10111111,
               d_01=8'b11101111,
               d_10=8'b11111011,
               d_11=8'b11111110,
               S0=1'b0,  // IDLE
               S1=1'b1;  // RECV DATA
// 1.      
always@(posedge clk or negedge rst) begin
    if(!rst)
        cs<=S0;
    else 
        cs<=ns;
end
// 2.
always@(cs or count0 or count1 or reg1) begin
    case(cs)
        S0:begin
            if((count0==15)&&(reg1==SOF)) begin
                ns=S1;
                f_en=1'b1;
            end else begin
                ns=S0;
                f_en=1'b0;
            end
        end
        S1:begin
            if((count0==15)&&(count1==3)&&(reg1[3:0]==EOF)) begin
                ns=S0;
                f_en=1'b0;
            end else begin
                ns=S1;
                f_en=1'b0;
            end
        end
        default:begin
            ns=ns;
            f_en=1'b0;
        end
    endcase          
end
// count0 should start at SOF negedge!
always@(posedge clk or negedge rst) begin
    if(!rst) begin
        count0<=0;
        reg1<=8'b00000000;
    end else begin 
        if(count0==15) begin
            reg1<={reg1[6:0],din};
            count0<=0;
        end else
            count0<=count0+1;   
    end
end

always@(posedge clk or negedge rst) begin
    if(!rst)
        count1<=0;
    else begin 
        if(cs==S1)
            if(count0==15)
                if(count1==7)
                    count1<=0;
                else
                    count1<=count1+1;
            else
                count1<=count1;
        else
            count1<=0;
    end
end
    
always@(posedge clk or negedge rst) begin
    if(!rst)
        count2<=0;
    else begin
        if((count0==15)&&(cs==S1)&&(count1==7))
            if(count2==3)
                count2<=0;
            else
                count2<=count2+1;
    end
end
reg d_en_d;
always@(posedge clk or negedge rst) begin
    if(!rst)
        d_en_d<=0;
    else begin
        if((count0==15)&&(count1==7)&&(cs==S1)&&(count2==3))  
            d_en_d<=1;
        else
            d_en_d<=0;
    end
end
always @(posedge clk or negedge rst) begin
    if(!rst)
        d_en <= 1'd0;
    else
        d_en <= d_en_d;
end
always@(posedge clk or negedge rst) begin
    if(!rst)
        reg2<=8'b00000000;
    else begin 
        if(cs==S1)
            if((count0==15)&&(count1==7)&&(count2<=3)) begin
                case(reg1)
                    d_00:reg2<={2'b00,reg2[7:2]};
                    d_01:reg2<={2'b01,reg2[7:2]};
                    d_10:reg2<={2'b10,reg2[7:2]};  
                    d_11:reg2<={2'b11,reg2[7:2]};
                    default:reg2<=reg2;
                endcase
            end else
                reg2<=reg2;
        else
            reg2<=0;     
  end
end        

always@(posedge clk or negedge rst) begin
    if(!rst)
        dout<=0;
    else begin
        if((d_en_d)&&(cs==S1))
            dout<=reg2;
        else if (cs==S0)
            dout<=0;
    end
end    

 endmodule 