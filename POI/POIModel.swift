//
//  POI.swift
//  POI
//
//  Created by Nicolas Besnard on 01/08/2014.
//  Copyright (c) 2014 Nicolas Besnard. All rights reserved.
//

import Foundation

class POIModel
{
    var collection: [POIVO] = []
    
    func addPOI(poi: POIVO)
    {
        addPOIFromArray([poi])
    }
    
    func addPOIFromArray(pois: [POIVO])
    {
        collection += pois
    }
}