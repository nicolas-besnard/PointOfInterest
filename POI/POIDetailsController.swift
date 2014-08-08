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
        
        let containsVC = rootViewControllerContainsViewController(poiDetailsViewController)
        
        if let vc = containsVC as? POIDetailsViewController
        {
            if !vc.poiDetailsView().viewIsShown
            {
                vc.poiDetailsView().playAppearAnimation()
            }
        }
        else
        {
            UIApplication.sharedApplication().keyWindow.rootViewController.addChildViewController(poiDetailsViewController)
            UIApplication.sharedApplication().keyWindow.rootViewController.view.addSubview(poiDetailsViewController.view)
        }
    }
    
    func rootViewControllerContainsViewController(viewController: UIViewController) -> UIViewController!
    {
        for currentVC: UIViewController in UIApplication.sharedApplication().keyWindow.rootViewController.childViewControllers as [UIViewController]
        {
            if currentVC.isKindOfClass(viewController.classForCoder)
            {
                return currentVC
            }
        }
        return nil
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}