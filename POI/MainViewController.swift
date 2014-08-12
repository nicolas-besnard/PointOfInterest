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
    
    var annotations: [POIAnnotation] = []
    
    var mapIsCentered: Bool!
    
    var lastCenteredLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
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
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!)
    {
        println("ERROR LOCATIONMANAGER")
        println(error.localizedDescription)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        var location = locations[0] as CLLocation
        
        if mapIsCentered == false
        {
            println("Center map to \(locationManager.location.coordinate)")
            centerMapToCoordinate(locationManager.location.coordinate)
            mapIsCentered = true
            
            let region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate, 1000, 1000)
            
            mapView.setRegion(region, animated: true)
            NSNotificationCenter.defaultCenter().postNotificationName(Notification.RetrievePOIFromServices.toRaw(), object: nil, userInfo: ["latitude": location.coordinate.latitude, "longitude": location.coordinate.longitude])
        }
    }

    // MAP VIEW
    
    func initMapView()
    {
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
    }
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool)
    {
        for annotation: POIAnnotation in self.annotations
        {
            let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
            
            if MKMapRectContainsPoint(mapView.visibleMapRect, annotationPoint)
            {
                mapView.addAnnotation(annotation)
                println("add")
            }
            else
            {
                mapView.removeAnnotation(annotation)
            }
        }
        (mapView.annotations as [MKAnnotation])
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView!
    {
        // Don't handle user location pin
        if annotation.isKindOfClass(MKUserLocation)
        {
            return nil
        }

        var pin = self.mapView.dequeueReusableAnnotationViewWithIdentifier(MapAnnotation.POIAnnotation.toRaw())
        
        if !pin
        {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: MapAnnotation.POIAnnotation.toRaw())
            
            let rightButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
            rightButton.setTitle(annotation.title, forState: UIControlState.Normal)

            pin.rightCalloutAccessoryView = rightButton
            pin.canShowCallout = true
        }
        else
        {
            pin.annotation = annotation
        }
        let restaurantAnnotation = annotation as POIAnnotation
        let poiIndex = restaurantAnnotation.index as Int
        var restaurantVO: RestaurantPOIVO = poiModel.collection[poiIndex] as RestaurantPOIVO
        
        if restaurantVO.isOpened
        {
            pin.image = UIImage(named: "starbucks_open")
        }
        else
        {
            pin.image = UIImage(named: "starbucks_close")
        }
        
        pin.sizeThatFits(CGSize(width: 0, height: 0))

        return pin
    }

    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!)
    {
        if view.annotation.isKindOfClass(MKUserLocation)
        {
            return
        }
        
        let poiIndex = (view.annotation as POIAnnotation).index
        
        centerMapToCoordinate(view.annotation.coordinate)
        
        let notification : NSNotification = NSNotification.notificationWithName(Notification.ShowPOIDetailsViewController.toRaw(), object: self, sourceViewController: self, poi: self.poiModel.collection[poiIndex])
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!)
    {
        let poiIndex = (view.annotation as POIAnnotation).index
        println("Posting notification with VO : \(poiIndex)")
        
        centerMapToCoordinate(view.annotation.coordinate)

        let notification : NSNotification = NSNotification.notificationWithName(Notification.ShowPOIDetailsViewController.toRaw(), object: self, sourceViewController: self, poi: self.poiModel.collection[poiIndex])
        
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }

    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!)
    {
        var delay: Double = 0.0
        
        for view: MKAnnotationView in views as [MKAnnotationView]
        {
            if view.annotation.isKindOfClass(MKUserLocation)
            {
                return
            }
            
            let endFrame = view.frame
            view.frame = CGRect(x: endFrame.origin.x, y: endFrame.origin.y, width: 0, height: 0)
            UIView.animateWithDuration(0.75,
                delay: delay,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.1,
                options: UIViewAnimationOptions.CurveEaseIn,
                animations: { () in
                    view.frame = CGRect(x: endFrame.origin.x, y: endFrame.origin.y, width: endFrame.size.width, height: endFrame.size.height)
                },
                completion: { (finished: Bool) in
                }
            )
            delay += 0.05
        }
    }
    
    func centerMapToCoordinate(coordinate: CLLocationCoordinate2D)
    {
        if lastCenteredLocation.latitude != coordinate.latitude
           || lastCenteredLocation.longitude != coordinate.longitude
        {
            lastCenteredLocation = coordinate
        }

        mapView.setCenterCoordinate(lastCenteredLocation, animated: true)
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

        var annotations: [POIAnnotation] = []
        
        for (index, poi: POIVO) in enumerate(poiModel.collection)
        {
            let point = POIAnnotation()
            
            point.coordinate = poi.coordinate
            point.title = poi.id
            point.subtitle = "subtitle"
            point.index = index
        
            annotations += [point]
        }
//        self.mapView.addAnnotations(annotations)
        self.annotations = annotations
    }
    
    deinit
    {
        self.poiModel.removeObserver(self, forKeyPath: "collection")
    }
}

