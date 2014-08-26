//
//  POIDetailsViewController.swift
//  POI
//
//  Created by Nicolas Besnard on 04/08/2014.
//  Copyright (c) 2014 Nicolas Besnard. All rights reserved.
//

import UIKit
import MapKit

class POIDetailsViewController: UIViewController, UIActionSheetDelegate
{
    var poiCoordinate: CLLocationCoordinate2D!
    var currentLocation: CLLocationCoordinate2D!
    
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
    
    @IBAction func didTouchGoButton(sender: AnyObject)
    {
        let sheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Close", destructiveButtonTitle: nil)
        sheet.addButtonWithTitle("Plan")
        if canOpenGoogleMaps()
        {
            sheet.addButtonWithTitle("Google")
        }
        sheet.showInView(self.view)
    }
    
    private func canOpenGoogleMaps() -> Bool
    {
        let googleURLScheme = NSURL(string: "comgooglemaps-x-callback://")
        if UIApplication.sharedApplication().canOpenURL(googleURLScheme)
        {
            return true
        }
        return false;
    }
    
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int)
    {
        let from = "?saddr=\(currentLocation.latitude),\(currentLocation.longitude)"
        let to = "&daddr=\(poiCoordinate.latitude),\(poiCoordinate.longitude)"

        if buttonIndex == 1
        {
            let url = NSURL(string: "http://maps.apple.com/\(from)\(to)")
            UIApplication.sharedApplication().openURL(url)
            
        }
        else if buttonIndex == 2
        {
            let callback = "&x-success=poiCappie://?resume=true&x-source=POI"
            let url = NSURL(string: "comgooglemaps-x-callback://\(from)\(to)\(callback)")
            println("url \(from)\(to)\(callback)")
            UIApplication.sharedApplication().openURL(url)
        }
        println(buttonIndex)
    }
    
    func setDetails(poi: RestaurantPOIVO, currentLocation: CLLocation)
    {
        println("set details")
        distanceLabel.text = NSString(format: "%.2f", poi.distance)
        isOpenedLabel.text = (poi.isOpened ? "Yes" : "False")
        openTimeLabel.text = poi.openTime
        closeTimeLabel.text = poi.closeTime
        poiCoordinate = poi.coordinate
        self.currentLocation = currentLocation.coordinate
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
