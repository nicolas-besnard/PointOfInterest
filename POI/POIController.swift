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
    
    init()
    {}
    
    func setup()
    {
        poiModel = context().poiModel
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "didAskForPOI:",
            name: Notification.AskForPOI.toRaw(),
            object: nil)
    }
    
    func didAskForPOI(notification: NSNotification)
    {
        searchNearbyPOI()
    }
    
    func searchNearbyPOI()
    {
        for service: POIServiceProtocol in context().poiServices
        {
            service.searcWithCoordinate(CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), completionBlock: {(pois:Array<POIVO>) in
                self.poiModel.addPOIFromArray(pois)
            })
        }
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
