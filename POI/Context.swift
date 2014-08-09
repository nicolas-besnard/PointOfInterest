//
//  Context.swift
//  POI
//
//  Created by Nicolas Besnard on 01/08/2014.
//  Copyright (c) 2014 Nicolas Besnard. All rights reserved.
//

import Foundation
import UIKit

class Context
{
    // MODEL
    var poiModel: POIModel
    
    // CONTROLLER
    var poiController: POIController!
    
    // VIEW CONTROLLER
    var poiDetailsController: POIDetailsController!
    
    // SERVICES
    var poiServices: [POIServiceProtocol]
    
    init()
    {
        poiModel = POIModel()
        poiController = POIController()
        poiServices = [StartbucksPOIService(), MockPOIService()]
        poiDetailsController = POIDetailsController()
    }
    
    func setup()
    {
        poiController.setup()
        poiDetailsController.setup()
    }
    
    func newPOIDetailsViewController() -> POIDetailsViewController
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier("POIDetailsViewControllerId") as POIDetailsViewController
    }
}