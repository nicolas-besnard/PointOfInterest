//
//  ViewController.swift
//  POI
//
//  Created by Nicolas Besnard on 01/08/2014.
//  Copyright (c) 2014 Nicolas Besnard. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var poiModel: POIModel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        initLocationManager()
    
        poiModel = context().poiModel
        
        NSNotificationCenter.defaultCenter().postNotificationName(Notification.AskForPOI.toRaw(), object: nil)
        
        setupObserver()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // LOCATION MANAGER
    
    func initLocationManager()
    {
        locationManager.delegate = self
        
        locationManager.distanceFilter = 0.0
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if status == CLAuthorizationStatus.NotDetermined
        {
            println("LocamationManager Request")
            manager.requestWhenInUseAuthorization()
        }
        else if status == CLAuthorizationStatus.AuthorizedWhenInUse
        {
            println("Locatinmanager Authorized")
            locationManager.startUpdatingLocation()
            initMapView()
        }
        else
        {
            println("Error on locationManager")
        }
    }
    
    
    // MAP VIEW
    
    func initMapView()
    {
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    // OBSERVER 
    
    func setupObserver()
    {
        self.poiModel.addObserver(self, forKeyPath: "collection", options: NSKeyValueObservingOptions.Initial, context: nil)
    }

    override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafePointer<()>)
    {
        if keyPath == "collection"
        {
            poiModelCollectionChanged()
        }
        else
        {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }

    }
    
    func poiModelCollectionChanged()
    {
        //reload data
        println("POI model collectino changed : \(poiModel.collection.count)")
    }
    
    deinit
    {
        self.poiModel.removeObserver(self, forKeyPath: "collection")
    }
}

