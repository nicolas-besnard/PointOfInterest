//
//  POIController.swift
//  POI
//
//  Created by Nicolas Besnard on 01/08/2014.
//  Copyright (c) 2014 Nicolas Besnard. All rights reserved.
//

import Foundation

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
            name: "AskForPOI",
            object: nil)
    }
    
    func didAskForPOI(notification: NSNotification)
    {
        println("COUCOU")
        searchNearbyPOI()
    }
    
    func searchNearbyPOI()
    {
        for service: POIServiceProtocol in context().poiServices
        {
            service.searchWithLat(0.0, lon: 0.0, completionBlock: {(pois:Array<POIVO>) in
                self.poiModel.addPOIFromArray(pois)
            })
        }
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
