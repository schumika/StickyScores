//
//  AJPlayer+PropertiesExtension.swift
//  StickyScores
//
//  Created by Anca Julean on 03/01/2018.
//  Copyright © 2018 Anca Julean. All rights reserved.
//

import Foundation

extension AJPlayer {
    public func printDescription() {
        print("Player with name: \(name ?? "") and id: \(id)")
    }
}
