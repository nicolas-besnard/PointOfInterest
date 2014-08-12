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
    var distance: Double!
    var isOpened = false
    
    init(id: String, coordinate: CLLocationCoordinate2D)
    {
        super.init()
        self.id = id
        self.coordinate = coordinate
    }
    
    class func initWithJson(json: AnyObject!) -> [RestaurantPOIVO]
    {
        var restaurants: [RestaurantPOIVO] = []
        
        let dict_json = json as NSDictionary
        
        for restaurant: NSDictionary in dict_json["items"] as Array<NSDictionary>
        {
            var json = JSONValue(restaurant)

            let id        = json["store"]["id"].string!
            let latitude  = json["store"]["coordinates"]["latitude"].double!
            let longitude = json["store"]["coordinates"]["longitude"].double!
            let distance  = json["distance"].double!
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
          
            var tmp_restaurant: RestaurantPOIVO = RestaurantPOIVO(id: id, coordinate: coordinate)
            
            if json["store"]["today"]["opensIn"].string == nil
            {
                tmp_restaurant.isOpened = true
            }
            
            tmp_restaurant.distance = distance
            restaurants.append(tmp_restaurant)
        }
        
        return restaurants
    }
}