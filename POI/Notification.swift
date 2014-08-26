//
//  Notification.swift
//  POI
//
//  Created by Nicolas Besnard on 01/08/2014.
//  Copyright (c) 2014 Nicolas Besnard. All rights reserved.
//

import Foundation
import UIKit
import MapKit

enum Notification: String
{
    case RetrievePOIFromServices = "RetrievePOIFromServices"
    case ShowPOIDetailsViewController = "ShowPOIDetailsViewController"
    case HidePOIDetailsViewController = "HidePOIDetailsViewController"
}

let _sourceViewControllerKey = "_sourceViewControllerKey"
let _poiKey = "_poiKey"
let _currentUserLocationKey = "_currentUserLocation"

extension NSNotification
{
    class func notificationWithName(name:NSString, object:AnyObject, sourceViewController:UIViewController, poi:POIVO, currentLocation: CLLocation) -> NSNotification
    {
        var userInfo = Dictionary<String, AnyObject>()

        userInfo[_sourceViewControllerKey] = sourceViewController
        userInfo[_poiKey] = poi
        userInfo[_currentUserLocationKey] = currentLocation
        
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

    func currentLocation() -> CLLocation?
    {
        if let info = userInfo
        {
            return info[_currentUserLocationKey] as? CLLocation
        }
        return nil
    }
    
    func poi() -> RestaurantPOIVO?
    {
        if let info = userInfo
        {
            return info[_poiKey] as? RestaurantPOIVO
        }
        return nil
    }
}
    
