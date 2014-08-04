//
//  POIDetailsController.swift
//  POI
//
//  Created by Nicolas Besnard on 04/08/2014.
//  Copyright (c) 2014 Nicolas Besnard. All rights reserved.
//

import Foundation
import UIKit

class POIDetailsController : ControllerBase
{
    var viewIsShown = false
    
    func setup()
    {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "ShowPOIDetailsViewController:",
            name: Notification.ShowPOIDetailsViewController.toRaw(),
            object: nil)
    }
    
    func ShowPOIDetailsViewController(notification: NSNotification)
    {
        if let poi = notification.poi()?
        {
            println("did ask : \(poi.coordinate.latitude)")
        }
        else
        {
            println("No POI provided, create notification using notificationWithName(name:,object:, sourceViewController:, poi:)")
        }

        println("POI DETAILS")

        let poiDetailsViewController = context().newPOIDetailsViewController()
        UIApplication.sharedApplication().keyWindow.rootViewController.addChildViewController(poiDetailsViewController)
        UIApplication.sharedApplication().keyWindow.rootViewController.view.addSubview(poiDetailsViewController.view)
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}