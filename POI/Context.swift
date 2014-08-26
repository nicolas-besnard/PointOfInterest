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
    var poiDetailsController: POIDetailsController!
    
    // VIEW CONTROLLER
    var poiDetailsViewController: POIDetailsViewController!
    
    // SERVICES
    var poiServices: [POIServiceProtocol]
    
    // MANAGER
    var imagesManager: ImagesManager!
    
    init()
    {
        poiModel = POIModel()
        poiController = POIController()
        poiServices = [StartbucksPOIService()]
        poiDetailsController = POIDetailsController()
        poiDetailsViewController = newPOIDetailsViewController()
        imagesManager = ImagesManager()
        addImagesToImagesManager()
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
    
    private func addImagesToImagesManager()
    {
        imagesManager.addImage("location_blue", key: "locationBlue")
        imagesManager.addImage("location_grey", key: "locationGrey")
        imagesManager.addImage("starbucks_open", key: "starbucksOpened")
        imagesManager.addImage("starbucks_close", key: "starbucksClosed")
    }
}