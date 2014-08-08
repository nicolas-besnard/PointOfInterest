//
//  POIDetails.swift
//  POI
//
//  Created by Nicolas Besnard on 04/08/2014.
//  Copyright (c) 2014 Nicolas Besnard. All rights reserved.
//

import UIKit

class POIDetailsView: UIView
{
    var viewIsShown = false
    
    func playAppearAnimation()
    {
        UIView.transitionWithView(self, duration: 0.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            let frame = self.frame
            let x = frame.origin.x
            let y = UIScreen.mainScreen().bounds.size.height / 1.5
            let width = frame.width
            let height = frame.height
            self.frame = CGRect(x: x, y: y, width: width, height: height)
        },
        completion: { (finished: Bool) -> () in
            self.viewIsShown = true
        })
    }
    
    func playDisappearAnimation()
    {
        UIView.transitionWithView(self, duration: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            let frame = self.frame
            let x = frame.origin.x
            let y = frame.origin.y + frame.height
            let width = frame.width
            let height = frame.height
            self.frame = CGRect(x: x, y: y, width: width, height: height)
        }, completion: { (fininshed: Bool) -> () in
            self.viewIsShown = false
        })
    }
    
    func moveToDefaultPosition()
    {
        let height = UIScreen.mainScreen().bounds.size.height
        let width = UIScreen.mainScreen().bounds.size.width

        self.frame = CGRect(x: 0, y: height, width: width, height: height)
    }
}