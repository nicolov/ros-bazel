#!/usr/bin/env python

"""
Simple node for testing the Python ROS libraries.
"""

import rospy
from other_msgs.msg import StampedHelloWithMessage

def callback(msg):
    print(msg)

def main():
    rospy.init_node("listener", anonymous=True)

    sub = rospy.Subscriber("chatter", StampedHelloWithMessage, callback)

    rospy.spin()

if __name__ == '__main__':
    main()
