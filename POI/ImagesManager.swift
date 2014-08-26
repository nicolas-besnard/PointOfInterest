//
//  ImagesManager.swift
//  POI
//
//  Created by Nicolas Besnard on 26/08/2014.
//  Copyright (c) 2014 Nicolas Besnard. All rights reserved.
//

import Foundation

class ImagesManager
{
    var collection = [String: UIImage]()
    
    subscript(key: String) -> UIImage
    {
        println("GET \(key)")
        return collection[key]!
    }
    
    func addImage(imageName: String, key: String)
    {
        collection[key] = UIImage(named: imageName)
    }
}