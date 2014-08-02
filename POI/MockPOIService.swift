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
        var rest1 = RestaurantPOIVO(id: "1", coordinate: CLLocationCoordinate2D(latitude: 48, longitude: 2.32))
        var rest2 = RestaurantPOIVO(id: "2", coordinate: CLLocationCoordinate2D(latitude: 48, longitude: 2.34))
        var rest3 = RestaurantPOIVO(id: "3", coordinate: CLLocationCoordinate2D(latitude: 48, longitude: 2.35))
        var array = [rest1, rest2, rest3]
        
        completionBlock(poi: array)
    }
}