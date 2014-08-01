//
//  POIService.swift
//  POI
//
//  Created by Nicolas Besnard on 01/08/2014.
//  Copyright (c) 2014 Nicolas Besnard. All rights reserved.
//

import Foundation
import MapKit


typealias POIServiceCompletionBlock = (poi:Array<POIVO>) -> Void

protocol POIServiceProtocol
{
    func searchWithLat(lat: CLLocationDegrees, lon: CLLocationDegrees, completionBlock: POIServiceCompletionBlock)
}
