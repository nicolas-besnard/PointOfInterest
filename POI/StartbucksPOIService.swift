//
//  StartbucksPOIService.swift
//  POI
//
//  Created by Nicolas Besnard on 08/08/2014.
//  Copyright (c) 2014 Nicolas Besnard. All rights reserved.
//

import Foundation
import MapKit

class StartbucksPOIService : POIServiceProtocol
{
    func searcWithCoordinate(coordinate: CLLocationCoordinate2D, completionBlock: POIServiceCompletionBlock)
    {
        var rest1 = RestaurantPOIVO(id: "1", coordinate: CLLocationCoordinate2D(latitude: 48, longitude: 2.32))
        var rest2 = RestaurantPOIVO(id: "2", coordinate: CLLocationCoordinate2D(latitude: 48, longitude: 2.34))
        var rest3 = RestaurantPOIVO(id: "3", coordinate: CLLocationCoordinate2D(latitude: 48, longitude: 2.35))
        var array = [rest1, rest2, rest3]
        

        let manager = AFHTTPRequestOperationManager()
        
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        
        let endpoint = "https://openapi.starbucks.com/location/v1/stores?&format=json&radius=10&limit=15&brandCode=SBUX&latLng=\(latitude)%2C\(longitude)&apikey=7b35m595vccu6spuuzu2rjh4"
        
        manager.GET(endpoint,
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("success")

                let restaurants = RestaurantPOIVO.initWithJson(responseObject)

                completionBlock(poi: restaurants)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                println("fail")
                println(error.localizedDescription)
                println(endpoint)
            }
        )
        
//        completionBlock(poi: array)
    }
    
}