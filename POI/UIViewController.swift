//
//  UIViewController.swift
//  POI
//
//  Created by Nicolas Besnard on 01/08/2014.
//  Copyright (c) 2014 Nicolas Besnard. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    func context() -> Context
    {
        return appDelegate().context
    }
    
    private func appDelegate() -> AppDelegate
    {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }
}