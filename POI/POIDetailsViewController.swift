//
//  POIDetailsViewController.swift
//  POI
//
//  Created by Nicolas Besnard on 04/08/2014.
//  Copyright (c) 2014 Nicolas Besnard. All rights reserved.
//

import UIKit

class POIDetailsViewController: UIViewController
{
    var poiDetailsController: POIDetailsController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        poiDetailsView().moveToDefaultPosition()
        
        poiDetailsController = context().poiDetailsController
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        poiDetailsView().playAppearAnimation()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didPushOnCloseButton(sender: AnyObject)
    {
        poiDetailsView().playDisappearAnimation()
    }
    
    func poiDetailsView() -> POIDetailsView
    {
        return self.view as POIDetailsView
    }
}
