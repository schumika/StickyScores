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
        let gamesCount = (try? context.count(for: AJGame.fetchRequest())) ?? 0
        return newGame(withId: Int16(gamesCount), andName: name)
    }
    
    // delete data
    func deleteGame(game: AJGame) {
        context.delete(game)
        saveChanges()
    }
}
