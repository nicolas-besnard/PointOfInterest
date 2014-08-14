//
//  CLLocationCoordinate2D.swift
//  
//
//  Created by Nicolas Besnard on 14/08/2014.
//
//

import MapKit

func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool
{
    return (lhs.latitude == rhs.latitude) && (lhs.longitude == rhs.longitude)
}

func !=(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool
{
    return !(lhs == rhs)
}



