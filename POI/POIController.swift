//
//  POIController.swift
//  POI
//
//  Created by Nicolas Besnard on 01/08/2014.
//  Copyright (c) 2014 Nicolas Besnard. All rights reserved.
//

import Foundation
import MapKit

class POIController : ControllerBase
{
    var poiModel: POIModel!
    
    func setup()
    {
        poiModel = context().poiModel
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "searchNearbyPOI:",
            name: Notification.RetrievePOIFromServices.toRaw(),
            object: nil)
    }
    
    func searchNearbyPOI(notification: NSNotification)
    {
        let latitude = notification.userInfo["latitude"]! as CLLocationDegrees
        let longitude = notification.userInfo["longitude"]! as CLLocationDegrees
        
        for service: POIServiceProtocol in context().poiServices
        {
            service.searcWithCoordinate(CLLocationCoordinate2D(latitude: latitude, longitude: longitude), completionBlock: {(pois:Array<POIVO>) in
                self.poiModel.addPOIFromArray(pois)
            })
        }
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
