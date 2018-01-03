//
//  AJGame+PropertiesExtension.swift
//  StickyScores
//
//  Created by Anca Julean on 03/01/2018.
//  Copyright © 2018 Anca Julean. All rights reserved.
//

import Foundation
import CoreData

extension AJGame {
    public func printDescription() {
        print("Game with name: \(name ?? "") and id: \(id)")
    }
}
