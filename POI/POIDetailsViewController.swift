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
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var isOpenedLabel: UILabel!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var closeTimeLabel: UILabel!
    
    var poiDetailsController: POIDetailsController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        poiDetailsView().moveToDefaultPosition()
        
        poiDetailsController = context().poiDetailsController
    }
    
    func setDetails(poi: RestaurantPOIVO)
    {
        println("set details")
        distanceLabel.text = NSString(format: "%.2f", poi.distance)
        isOpenedLabel.text = (poi.isOpened ? "Yes" : "False")
        openTimeLabel.text = poi.openTime
        closeTimeLabel.text = poi.closeTime
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
