//
//  Notification.swift
//  POI
//
//  Created by Nicolas Besnard on 01/08/2014.
//  Copyright (c) 2014 Nicolas Besnard. All rights reserved.
//

import Foundation
import UIKit

enum Notification: String
{
    case RetrievePOIFromServices = "RetrievePOIFromServices"
    case ShowPOIDetailsViewController = "ShowPOIDetailsViewController"
    case HidePOIDetailsViewController = "HidePOIDetailsViewController"
}

let _sourceViewControllerKey : String = "_sourceViewControllerKey"
let _poiKey : String = "_poiKey"

extension NSNotification
{
    class func notificationWithName(name:NSString, object:AnyObject, sourceViewController:UIViewController, poi:POIVO) -> NSNotification
    {
        var userInfo = Dictionary<String, AnyObject>()
        userInfo[_sourceViewControllerKey] = sourceViewController
        userInfo[_poiKey] = poi

        let notification : NSNotification = NSNotification(name: name, object: object, userInfo: userInfo)
        return notification
    }
    
    func sourceViewController() -> UIViewController?
    {
        if let info = userInfo
        {
            return info[_sourceViewControllerKey] as? UIViewController
        }
        return nil
    }
    
    func poi() -> RestaurantPOIVO?
    {
        if let info = userInfo
        {
            return info![_poiKey] as? RestaurantPOIVO
        }
        return nil
    }
}
    
