// Playground - noun: a place where people can play

import UIKit

var collection: [Int] = [1, 2, 3]

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

