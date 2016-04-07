global out_msg;
global raw_data;
global run_gp;
global publisher;
global object;

node = rosmatlab.node('NODE',[],[],'rosIP','127.0.0.1');
%subscriber = rosmatlab.subscriber('/takktile_throttled/average_contacts','takktile_ros/Touch',1,node);
subscriber = rosmatlab.subscriber('/takktile_throttled/raw','takktile_ros/Raw',1,node);
publisher = rosmatlab.publisher('/takktile/gp_results', 'std_msgs/Float64MultiArray', node);
subscriber.setOnNewMessageListeners({@takktile_callback});

out_msg = rosmatlab.message('std_msgs/Float64MultiArray', node);
object = 'debrie'


%rosrun topic_tools throttle messages takktile/raw 2 takktile_throttled/raw
%subscriber = rosmatlab.subscriber('/takktile_throttled/average_contact','takktile_ros/Touch',1,node);
