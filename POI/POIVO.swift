//
//  POIVO.swift
//  POI
//
//  Created by Nicolas Besnard on 01/08/2014.
//  Copyright (c) 2014 Nicolas Besnard. All rights reserved.
//

import Foundation
import MapKit

enum POIType
{
    case Unknown;
    case Starbucks;
}

class POIVO
{
    var id: String = "";
    var lat: CLLocationDegrees = 0.0;
    var lon: CLLocationDegrees = 0.0;
    var type: POIType = POIType.Unknown;
}
