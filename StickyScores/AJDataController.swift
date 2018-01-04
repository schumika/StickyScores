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
    
    var context: NSManagedObjectContext  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveChanges() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    // get data
    func getGames() -> [AJGame] {
        var games = [AJGame]()
        
        do {
            let gamesFetchRequest: NSFetchRequest<AJGame> = AJGame.fetchRequest()
            gamesFetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "id", ascending: false)]
            games = try context.fetch(gamesFetchRequest)
        } catch {
            print("fetching failed")
        }
        return games
    }
    
    // insert data
    private func newGame(withId id:Int16, andName name: String) -> AJGame? {
        let game = AJGame(context: context)
        game.id = id
        game.name = name
        saveChanges()
        
        return game
    }
    
    func newGame(withName name: String) -> AJGame? {
        let gameId = getMaxGameId() + 1
        return newGame(withId: Int16(gameId), andName: name)
    }
    
    func getMaxGameId() -> Int16 {
        var maxId: Int16 = 0
        do {
            let gamesFetchRequest: NSFetchRequest<AJGame> = AJGame.fetchRequest()
            gamesFetchRequest.predicate = NSPredicate.init(format: "id=max(id)")
            gamesFetchRequest.fetchLimit = 1
            let games = try context.fetch(gamesFetchRequest)
            if games.count > 0 {
                maxId = games[0].id
            }
        } catch {
            print("fetching failed")
        }
        
        return maxId
    }
}
