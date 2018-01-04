//
//  AJGamesTableViewController.swift
//  StickyScores
//
//  Created by Anca Julean on 28/12/2017.
//  Copyright © 2017 Anca Julean. All rights reserved.
//

import UIKit

class AJGamesTableViewController: UITableViewController {
    
    var dataController: AJDataController = (UIApplication.shared.delegate as! AppDelegate).dataController
    private var games: [AJGame]?
    private var selectedGame: AJGame?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
    
    private func loadData() {
        getData()
        tableView.reloadData()
    }
    
    private func getData() {
        games = dataController.getGames()
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath)

        // Configure the cell...
        var gameName = ""
        if let game = games?[indexPath.row] {
            gameName = "\(game.id) -- \(game.name ?? "")"
        }
        cell.textLabel?.text = gameName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedGame = games?[indexPath.row]
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let navCon = segue.destination as? UINavigationController {
            if let gameVC = navCon.topViewController as? AJGameCollectionViewController {
                gameVC.game = selectedGame
            }
        }
    }
 
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new game", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textfield) in
            textfield.becomeFirstResponder()
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] action in
            if let textField = alert.textFields?[0] {
                if let eneteredText = textField.text {
                    let newGame = self?.dataController.newGame(withName: eneteredText)
                    print(newGame?.description ?? "could not create new game")
                    
                    DispatchQueue.main.async {
                        self?.loadData()
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
        present(alert, animated: true, completion: nil)
    }
    
}
