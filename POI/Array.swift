//
//  Array.swift
//  POI
//
//  Created by Nicolas Besnard on 12/08/2014.
//  Copyright (c) 2014 Nicolas Besnard. All rights reserved.
//

import Foundation

extension Array
{
    func contains <T: Equatable>(items: T...) -> Bool
    {
        return items.all { self.indexOf($0) >= 0 }
    }
    
    func all(test: (Element) -> Bool) -> Bool
    {
        for item in self
        {
            if !test(item)
            {
                return false
            }
        }
        return true
    }
    
    func indexOf <U: Equatable>(item: U) -> Int?
    {
        if item is Element
        {
            return find(unsafeBitCast(self, [U].self), item)
        }
        return nil
    }
}