module counter(
    clk     ,
    rst_n   ,
    din_vld ,
    dout    ,
    dout_vld 
    );

    //参数定义
    parameter      NUM =  3;

    //输入信号定义
    input               clk    ;
    input               rst_n  ;
    input               din_vld;

    //输出信号定义
    output[4*NUM-1:0]   dout   ;
    output              dout_vld  ;

    //输出信号reg定义
    reg   [4*NUM-1:0]   dout     ;
    wire  [4*NUM-1:0]   dout_temp;
    reg                 dout_vld ;
    wire  [3:0]         temp[NUM-1:0];
    wire                add_1_flag[NUM-1:0];

genvar ii;
generate
    for(ii=0;ii<NUM;ii=ii+1)begin:FLGA_BRK
        assign temp[ii]      = dout[(ii+1)*4-1 -:4];

        if(ii==0)
           assign  add_1_flag[ii] = din_vld;
        else
           assign  add_1_flag[ii] = (add_1_flag[ii-1] && temp[ii-1]==9);

        assign dout_temp[(ii+1)*4-1 -:4] = (add_1_flag[ii])?((temp[ii]==9)?0:(temp[ii]+1)):temp[ii];
    end
endgenerate

    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            dout <= 0;
        end
        else begin
            dout <= dout_temp;
        end
    end

    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            dout_vld <= 1'b0;
        end
        else begin
            dout_vld <= din_vld;
        end
    end

endmodule

