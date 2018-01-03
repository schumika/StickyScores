//
//  AJDataController.swift
//  StickyScores
//
//  Created by Anca Julean on 03/01/2018.
//  Copyright © 2018 Anca Julean. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AJDataController {
    private var appDelegate: AppDelegate! {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
    private var context: NSManagedObjectContext {
        get {
            return appDelegate.persistentContainer.viewContext
        }
    }
    
    func saveChanges() {
        appDelegate.saveContext()
    }
    
    // get data
    func getGames() -> [AJGame] {
        var games = [AJGame]()
        
        do {
            games = try context.fetch(AJGame.fetchRequest())
        } catch {
            print("fetching failed")
        }
        return games
    }
    
    // insert data
    func newGame(withId id:Int16, andName name: String) -> AJGame? {
        let game = AJGame(context: context)
        game.id = id
        game.name = name
        saveChanges()
        
        return game
    }
}
