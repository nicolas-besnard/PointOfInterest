//
//  POIAnnotation.swift
//  POI
//
//  Created by Nicolas Besnard on 08/08/2014.
//  Copyright (c) 2014 Nicolas Besnard. All rights reserved.
//

import UIKit
import MapKit

class POIAnnotation: NSObject, MKAnnotation
{
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var index: Int = 0
    
    var title: String = ""
    var subtitle: String = ""
}
