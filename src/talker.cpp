#include <ros/ros.h>
#include <other_msgs/StampedHelloWithMessage.h>

#include <sstream>

int main(int argc, char **argv) {
  ros::init(argc, argv, "talker");

  ros::NodeHandle n;
  ros::Publisher chatter_pub = n.advertise<other_msgs::StampedHelloWithMessage>("chatter", 1000);

  ros::Rate loop_rate(10);

  int count = 0;
  while (ros::ok()) {
    other_msgs::StampedHelloWithMessage msg;

    std::stringstream ss;
    ss << "hello world " << count;
    msg.message = ss.str();

    std::cout << msg << "\n";

    chatter_pub.publish(msg);

    ros::spinOnce();

    loop_rate.sleep();
    ++count;
  }

  return 0;
}
