//
//  RestaurantPOIVO.swift
//  POI
//
//  Created by Nicolas Besnard on 01/08/2014.
//  Copyright (c) 2014 Nicolas Besnard. All rights reserved.
//

import Foundation
import MapKit

class RestaurantPOIVO : POIVO
{    
    init(id: String, coordinate: CLLocationCoordinate2D)
    {
        super.init()
        self.id = id
        self.coordinate = coordinate
    }
}