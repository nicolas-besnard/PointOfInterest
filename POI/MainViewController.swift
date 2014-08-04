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
        
        println("To raw \(Notification.RetrievePOIFromServices.toRaw())")
        NSNotificationCenter.defaultCenter().postNotificationName(Notification.RetrievePOIFromServices.toRaw(), object: nil)
        
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
            println("LocatoinManager Authorized")
            locationManager.startUpdatingLocation()
        }
        else
        {
            println("Error on locationManager \(status.hashValue)")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        if mapIsCentered == false
        {
            goToUserLocation()
            mapIsCentered = true
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
//        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(MapAnnotation.POIAnnotation.toRaw())
        
//        if !annotationView
//        {
//            println("ici")
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: MapAnnotation.POIAnnotation.toRaw())
//            
//            let rightButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
//            rightButton.setTitle(annotation.title, forState: UIControlState.Normal)
//
//            annotationView
//            annotationView.rightCalloutAccessoryView = rightButton as UIView
//            annotationView.canShowCallout = true
//            
//            annotationView.
//        }
//        else
       
//        return annotationView
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!)
    {
        //NSNotificationCenter.defaultCenter().postNotificationName(Notification.ShowPOIDetailsViewController.toRaw(), object: nil)
        println("Posting notification with VO : \(self.poiModel.collection[0])")
        let notification : NSNotification = NSNotification.notificationWithName(Notification.ShowPOIDetailsViewController.toRaw(), object: self, sourceViewController: self, poi: self.poiModel.collection[0])
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
        println("POI model collection changed : \(poiModel.collection.count)")
        for poi: POIVO in poiModel.collection
        {
            let point: MKPointAnnotation = MKPointAnnotation()
            
            point.coordinate = poi.coordinate
            point.title = poi.id
            point.subtitle = "subtiltee"
            
            self.mapView.addAnnotation(point)
        }
    }
    
    deinit
    {
        self.poiModel.removeObserver(self, forKeyPath: "collection")
    }
}

