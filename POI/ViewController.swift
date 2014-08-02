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
            println("Error on locationManager \(status.hashValue)")
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
        println("test")
        
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

