virtual type { IDLE S1 S2} FSM_TYPE
virtual function -install /fsm_tb/uut -env /fsm_tb/uut { (FSM_TYPE)/uut/current_state} current_state_n
