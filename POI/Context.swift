//
//  Context.swift
//  POI
//
//  Created by Nicolas Besnard on 01/08/2014.
//  Copyright (c) 2014 Nicolas Besnard. All rights reserved.
//

import Foundation

class Context
{
    // MODEL
    var poiModel: POIModel
    
    // CONTROLLER
    var poiController: POIController!
    
    // SERVICES
    var poiServices: [POIServiceProtocol]
    
    init()
    {
        poiModel = POIModel()
        poiController = POIController()
        poiServices = [MockPOIService()]
    }
    
    func setup()
    {
        poiController.setup()
    }
}