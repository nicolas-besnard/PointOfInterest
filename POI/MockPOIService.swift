//
//  MockPOIService.swift
//  POI
//
//  Created by Nicolas Besnard on 01/08/2014.
//  Copyright (c) 2014 Nicolas Besnard. All rights reserved.
//

import Foundation
import MapKit

class MockPOIService : POIServiceProtocol
{
    func searcWithCoordinate(coordinate: CLLocationCoordinate2D, completionBlock: POIServiceCompletionBlock)
    {
        var rest1 = RestaurantPOIVO()
        var rest2 = RestaurantPOIVO()

        var array = [rest1, rest2]
        
        completionBlock(poi: array)
    }
}