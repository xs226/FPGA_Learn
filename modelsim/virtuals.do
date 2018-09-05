virtual type { IDLE S1 S2} FSM_TYPE
virtual function -install /fsm_tb/uut -env /fsm_tb/uut { (FSM_TYPE)/uut/current_state} current_state_n
virtual type { \
IDLE\
HEAD\
TYPE_DATA\
TYPE_CMD\
DATA_LEN\
DATA\
DATA_CRC\
} SEG_DATA2
virtual type { \
DATA0\
HEAD\
TYPE_DATA\
TYPE_CMD\
DATA_LEN\
DATA\
DATA_CRC\
} SEG_DATA
virtual function -install /fsm_tb/uut -env /fsm_tb { (SEG_DATA)/uut/current_state} c_state
virtual function -install /fsm_tb/uut -env /fsm_tb { (SEG_DATA2)/uut/current_state} c_state001
virtual function -install /fsm_tb/uut -env /fsm_tb { (SEG_DATA2)/uut/current_state} c_state002
virtual function -install /fsm_tb/uut -env /fsm_tb { (SEG_DATA2)/uut/current_state} c_state003
virtual type { IDLE HEAD TYPE_DATA TYPE_CMD DATA_LEN DATA DATA_CRC} SEG_DATA2
virtual function -install /fsm_tb/uut -env /fsm_tb { (SEG_DATA2)/uut/current_state} c_state
