function takktile_callback(msg)
    global raw_data
    global run_gp
    global out_msg
    raw_data = msg.getPressure()';
    raw_data = raw_data(1:3);
    raw_data = double(raw_data) ./ 450.0
    
    if (run_gp == 1) 
        run_gp = 0;
        GPTEMPLATEVTRAIN
        
        global grasp_quality_probability;
        global grasp_uncertainty;
        global publisher
        out_msg.setData([grasp_quality_probability, grasp_uncertainty])
        publisher.publish(out_msg)
    end
end