// Playground - noun: a place where people can play

import UIKit

var hour_s = "20:00:00"

var date = NSDateFormatter()
date.dateFormat = "hh:mm:ss"
date.dateFromString(hour_s)