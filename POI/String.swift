//
//  String.swift
//  POI
//
//  Created by Nicolas Besnard on 14/08/2014.
//  Copyright (c) 2014 Nicolas Besnard. All rights reserved.
//

extension String
   {
    func deleteLastCharacter(n: Int) -> String
    {
        let stringLength = countElements(self)
        let substringIndex = stringLength - n
        return self.substringToIndex(advance(self.startIndex, substringIndex))
    }
}