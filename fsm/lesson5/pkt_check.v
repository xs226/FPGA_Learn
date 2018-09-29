`define   SIMPLE

`ifdef  SIMPLE

module pkt_check(
    clk     ,
    rst_n   ,
    din     ,
    dout_vld,
    dout    ,
    dout_sop,
    dout_eop
         
    );

    //参数定义
    parameter      DATA_W = 8;

    parameter      HEAD   = 0;
    parameter      TYPE   = 1;
    parameter      LEN    = 2;
    parameter      DATA   = 3;
    parameter      FCS    = 4;
    parameter      CTRL_PKT_LEN=64;
    //输入信号定义
    input               clk    ;
    input               rst_n  ;
    input [DATA_W-1:0]  din    ;

    //输出信号定义
    output[DATA_W-1:0]  dout    ;
    output              dout_sop;
    output              dout_eop;
    output              dout_vld;

    //输出信号reg定义
    reg   [DATA_W-1:0]  dout    ;
    reg                 dout_sop;
    reg                 dout_eop;
    reg                 dout_vld;

    reg [ 2:0]          state_c;
    reg [ 2:0]          state_n;
    reg [ 3:0]          head_cnt;
    reg                 head_flag;
    reg[15:0]           data_cnt;
    reg                 len_cnt;
    reg[1:0]            fcs_cnt;

    always@(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            state_c <= HEAD;
        end
        else begin
            state_c <= state_n;
        end
    end

    always  @(*)begin
        case(state_c)
            HEAD  :begin
                       if(head_cnt==9 && din==8'hd5)begin
                           state_n = TYPE;
                       end
                       else begin
                           state_n = HEAD;
                       end
                   end
            TYPE  :begin
                      if(din==0)begin
                          state_n = DATA ;
                      end
                      else begin
                          state_n = LEN;
                      end
                   end
            LEN   :begin
                       if(len_cnt==1)begin
                           state_n = DATA;
                       end
                       else begin
                           state_n = LEN;
                       end
                   end
            DATA  :begin
                       if(data_cnt==0)begin
                           state_n = FCS;
                       end
                       else begin
                           state_n = DATA;
                       end
                   end                     
            FCS   :begin                              
                       if(fcs_cnt==3)begin
                           state_n = HEAD;
                       end
                       else begin
                           state_n = FCS;
                       end
                   end
            default: state_c = HEAD;
        endcase
    end


    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            head_cnt <= 0;
        end
        else if(state_c==HEAD) begin
            if(head_flag==0) begin
                if(din==8'h55)begin
                    head_cnt <= head_cnt + 1;
                end
                else begin
                    head_cnt <= 0;
                end
            end
            else if(head_flag==1)begin
                if(din==8'hd5)begin
                    if(head_cnt==9)begin
                        head_cnt <= 0;
                    end
                    else begin
                        head_cnt <= head_cnt + 1; 
                    end
                end
                else if(din==8'h55) begin
                    head_cnt <= 1;
                end
                else begin
                    head_cnt <= 0;
                end
            end
        end
        else begin
                head_cnt <= 0;
        end
    end

    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            head_flag <= 1'b0;
        end
        else if(state_c==HEAD) begin
            if(head_flag==1'b0)begin
                if(din==8'h55)
                    head_flag <= 1'b1;
            end
            else begin
                if(din==8'h55)begin
                    head_flag <= 1'b1;
                end
                else begin
                    head_flag <= 1'b0;
                end
            end
        end
        else begin
            head_flag <= 1'b0;
        end
    end


    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            data_cnt <= 0;
        end
        else if(state_c==TYPE && din==0) begin
            data_cnt <= CTRL_PKT_LEN-1;
        end
        else if(state_c==LEN)begin
            if(len_cnt==0)begin
                data_cnt <= {data_cnt[7:0],din};
            end
            else begin
                 data_cnt <= {data_cnt[7:0],din}-1;
            end
        end
        else if(data_cnt!=0)begin
            data_cnt <= data_cnt - 1;
        end
    end

    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            len_cnt <= 1'b0;
        end
        else if(state_c==LEN) begin
            len_cnt <= ~ len_cnt;
        end
        else begin
            len_cnt <= 1'b0;
        end
    end


    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            fcs_cnt <= 0;
        end
        else if(state_c==FCS)begin
            if(fcs_cnt==3)
                fcs_cnt <= 0;
            else
                fcs_cnt <= fcs_cnt + 1;
        end
    end

    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            dout <= 0;
        end
        else begin
            dout <= din;
        end
    end

    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            dout_vld <= 1'b0;
        end
        else if(state_c != HEAD) begin
            dout_vld <= 1'b1;
        end
        else begin
            dout_vld <= 1'b0;
        end
    end

    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            dout_sop <= 1'b0;
        end
        else if(state_c==TYPE) begin
            dout_sop <= 1'b1;
        end
        else begin
            dout_sop <= 1'b0;
        end
    end

    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            dout_eop <= 1'b0;
        end
        else if(state_c==FCS && fcs_cnt==3) begin
            dout_eop <= 1'b1;
        end
        else begin
            dout_eop <= 1'b0;
        end
    end


endmodule



`else

module pkt_check(
    clk     ,
    rst_n   ,
    din     ,
    dout_vld,
    dout    ,
    dout_sop,
    dout_eop
         
    );

    //参数定义
    parameter      DATA_W = 8;

    parameter      HEAD   = 0;
    parameter      TYPE   = 1;
    parameter      LEN    = 2;
    parameter      DATA   = 3;
    parameter      FCS    = 4;
    parameter      CTRL_PKT_LEN=64;
    //输入信号定义
    input               clk    ;
    input               rst_n  ;
    input [DATA_W-1:0]  din    ;

    //输出信号定义
    output[DATA_W-1:0]  dout    ;
    output              dout_sop;
    output              dout_eop;
    output              dout_vld;

    //输出信号reg定义
    reg   [DATA_W-1:0]  dout    ;
    reg                 dout_sop;
    reg                 dout_eop;
    reg                 dout_vld;

    reg [ 2:0]          state_c;
    reg [ 2:0]          state_n;
    reg [ 3:0]          head_cnt;
    wire                add_head_cnt;
    wire                end_head_cnt;
    wire                get_55      ;
    reg                 head_flag;
    reg[15:0]           data_len ;
    reg[15:0]           x        ;
    reg[15:0]           cnt;
    wire                add_cnt;
    wire                end_cnt;
    wire                head2type_start;
    wire                type2len_start;
    wire                type2data_start;
    wire                len2data_start ;
    wire                data2fcs_start;
    wire                fcs2head_start;


    always@(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            state_c <= HEAD;
        end
        else begin
            state_c <= state_n;
        end
    end

    always  @(*)begin
        case(state_c)
            HEAD  :begin
                       if(head2type_start)begin
                           state_n = TYPE;
                       end
                       else begin
                           state_n = state_c;
                       end
                   end
            TYPE  :begin
                      if(type2data_start)begin
                          state_n = DATA ;
                      end
                      else if(type2len_start) begin
                          state_n = LEN;
                      end
                      else begin
                          state_n = state_c;
                      end
                   end
            LEN   :begin
                       if(len2data_start)begin
                           state_n = DATA;
                       end
                       else begin
                           state_n = state_c;
                       end
                   end
            DATA  :begin
                       if(data2fcs_start)begin
                           state_n = FCS;
                       end
                       else begin
                           state_n = state_c;
                       end
                   end                     
            FCS   :begin                              
                       if(fcs2head_start)begin
                           state_n = HEAD;
                       end
                       else begin
                           state_n = state_c;
                       end
                   end
            default: state_c = HEAD;
        endcase
    end

    assign  head2type_start = state_c==HEAD && end_head_cnt;
    assign  type2len_start  = state_c==TYPE && din!=0;
    assign  type2data_start = state_c==TYPE && din==0;
    assign  len2data_start  = state_c==LEN  && end_cnt;
    assign  data2fcs_start  = state_c==DATA && end_cnt;
    assign  fcs2head_start  = state_c==FCS  && end_cnt;
    

    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            head_cnt <= 0;
        end
        else if(add_head_cnt)begin
            if(end_head_cnt)
                head_cnt <= 0;
            else
                head_cnt <= head_cnt + 1;
        end
        else if(get_55)begin
            head_cnt <= 1;
        end
        else begin
            head_cnt <= 0;
        end
    end

    assign add_head_cnt = (head_flag==0 && din==8'h55) || (head_flag && din==8'hd5);       
    assign end_head_cnt = add_head_cnt && head_cnt==10-1 ;
    assign get_55       = din==8'h55;   


    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            head_flag <= 1'b0;
        end
        else if(state_c==HEAD && din==8'h55) begin
            head_flag <= 1'b1;
        end
        else begin
            head_flag <= 1'b0;
        end
    end

    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            cnt <= 0;
        end
        else if(add_cnt)begin
            if(end_cnt)
                cnt <= 0;
            else
                cnt <= cnt + 1;
        end
    end

    assign add_cnt = state_c==LEN || state_c==DATA || state_c==FCS;       
    assign end_cnt = add_cnt && cnt==x-1 ;

    always  @(*)begin
        if(state_c==LEN)
            x = 2;
        else if(state_c==DATA)
            x = data_len;
        else
            x = 4;
    end

    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            data_len <= 0;
        end
        else if(type2data_start) begin
            data_len <= 64;
        end
        else if(state_c==LEN)begin
            data_len[(2-cnt)*8-1 -:8] <= din;
        end
    end


    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            dout <= 0;
        end
        else begin
            dout <= din;
        end
    end

    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            dout_vld <= 1'b0;
        end
        else if(state_c != HEAD) begin
            dout_vld <= 1'b1;
        end
        else begin
            dout_vld <= 1'b0;
        end
    end

    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            dout_sop <= 1'b0;
        end
        else if(state_c==TYPE) begin
            dout_sop <= 1'b1;
        end
        else begin
            dout_sop <= 1'b0;
        end
    end

    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            dout_eop <= 1'b0;
        end
        else if(fcs2head_start) begin
            dout_eop <= 1'b1;
        end
        else begin
            dout_eop <= 1'b0;
        end
    end


endmodule





`endif
