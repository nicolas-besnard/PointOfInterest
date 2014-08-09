//
//  ViewController.swift
//  POI
//
//  Created by Nicolas Besnard on 01/08/2014.
//  Copyright (c) 2014 Nicolas Besnard. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var poiModel: POIModel!
    
    var mapIsCentered: Bool!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        mapIsCentered = false
        initLocationManager()
        initMapView()
    
        poiModel = context().poiModel
        
        setupObserver()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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
            println("LocationManager Request")
            manager.requestWhenInUseAuthorization()
        }
        else if status == CLAuthorizationStatus.AuthorizedWhenInUse
        {
            println("LocationManager Authorized")
            locationManager.startUpdatingLocation()
        }
        else
        {
            println("LocationManager error: \(status.hashValue)")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        var location = locations[0] as CLLocation
        
        if mapIsCentered == false
        {
            goToUserLocation()
            mapIsCentered = true
            println("To raw \(Notification.RetrievePOIFromServices.toRaw())")
            NSNotificationCenter.defaultCenter().postNotificationName(Notification.RetrievePOIFromServices.toRaw(), object: nil, userInfo: ["latitude": location.coordinate.latitude, "longitude": location.coordinate.longitude])
        }
    }
    
    // MAP VIEW
    
    func initMapView()
    {
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView!
    {
        // Don't handle user location pin
        if annotation.isKindOfClass(MKUserLocation)
        {
            return nil
        }

        var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(MapAnnotation.POIAnnotation.toRaw())
        
        if !pin
        {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: MapAnnotation.POIAnnotation.toRaw())
            
            let rightButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
            rightButton.setTitle(annotation.title, forState: UIControlState.Normal)
            
            pin.rightCalloutAccessoryView = rightButton
            pin.canShowCallout = true
        }
        return pin
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!)
    {
        //NSNotificationCenter.defaultCenter().postNotificationName(Notification.ShowPOIDetailsViewController.toRaw(), object: nil)
        let poiIndex = (view.annotation as POIAnnotation).index
        println("Posting notification with VO : \(poiIndex)")

        let notification : NSNotification = NSNotification.notificationWithName(Notification.ShowPOIDetailsViewController.toRaw(), object: self, sourceViewController: self, poi: self.poiModel.collection[poiIndex])
        
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
    
    func goToUserLocation()
    {
        mapView.setCenterCoordinate(locationManager.location.coordinate, animated: true)
        let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate, 3000, 3000)
        
        mapView.setRegion(region, animated: true)
    }
    
    // OBSERVER
    
    func setupObserver()
    {
        self.poiModel.addObserver(self, forKeyPath: "collection", options: NSKeyValueObservingOptions.Initial, context: nil)
    }

    override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<()>)
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
        println("POI model collection changed : \(poiModel.collection.count)")

        for (index, poi: POIVO) in enumerate(poiModel.collection)
        {
            let point = POIAnnotation()
            
            point.coordinate = poi.coordinate
            point.title = poi.id
            point.subtitle = "subtitle"
            point.index = index
            
            self.mapView.addAnnotation(point)
        }
    }
    
    deinit
    {
        self.poiModel.removeObserver(self, forKeyPath: "collection")
    }
}

