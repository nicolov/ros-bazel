#include "src/test_msgs/test_msgs/Message1.h"
#include "src/test_msgs/test_msgs/Message2.h"

#include <iostream>

int main(){
    test_msgs::Message1 m1 = test_msgs::Message1();
    test_msgs::Message2 m2 = test_msgs::Message2();

    m1.auint64 = 13;
    m2.amsg1.auint64 = 42;
    m2.astr = "Hello World!";

    std::cout << m1 << m2 << std::endl;
}

