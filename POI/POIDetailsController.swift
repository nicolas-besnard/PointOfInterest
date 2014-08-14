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
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "HidePOIDetailsViewController:",
            name: Notification.HidePOIDetailsViewController.toRaw(),
            object: nil)
    }
    
    func HidePOIDetailsViewController(notification: NSNotification)
    {
        let poiDetailsViewController = context().poiDetailsViewController

        if poiDetailsViewController.poiDetailsView().viewIsShown
        {
            poiDetailsViewController.poiDetailsView().playDisappearAnimation()
        }
    }
    
    func ShowPOIDetailsViewController(notification: NSNotification)
    {
        if let poi = notification.poi()?
        {
            println("did ask ShowPOIDetailsViewController")
            
            let sourceViewController: UIViewController! = notification.sourceViewController()!
            
            let poiDetailsViewController = context().poiDetailsViewController
            
            let containsVC = viewControllerContainsViewController(sourceViewController, contains: poiDetailsViewController)
            
            if containsVC == true
            {
                if !poiDetailsViewController.poiDetailsView().viewIsShown
                {
                    poiDetailsViewController.poiDetailsView().playAppearAnimation()
                }
            }
            else
            {
                sourceViewController.addChildViewController(poiDetailsViewController)
                sourceViewController.view.addSubview(poiDetailsViewController.view)
            }
            poiDetailsViewController.setDetails(poi)
        }
        else
        {
            println("No POI provided, create notification using notificationWithName(name:,object:, sourceViewController:, poi:)")
        }
    }
    
    private func viewControllerContainsViewController(viewController: UIViewController, contains: UIViewController) -> Bool
    {
        for currentVC: UIViewController in viewController.childViewControllers as [UIViewController]
        {
            if currentVC.isKindOfClass(contains.classForCoder)
            {
                return true
            }
        }
        return false
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}