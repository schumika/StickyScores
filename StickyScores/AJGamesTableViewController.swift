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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    private func loadData() {
        getData()
        tableView.reloadData()
    }
    
    private func getData() {
        games = dataController.getGames()
    }

    // MARK: - Table view data source & delegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games != nil ? games!.count : 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath)

        // Configure the cell...
        var gameName = ""
        if let game = games?[indexPath.row] {
            gameName = "\(game.id) -- \(game.name ?? "")"
        }
        cell.textLabel?.text = gameName
        
        // add double tap gesture recogniser
        let longTapGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(AJGamesTableViewController.handleCellLongTap(_:)))
        longTapGestureRecognizer.cancelsTouchesInView = true
        longTapGestureRecognizer.delaysTouchesBegan = true
        cell.addGestureRecognizer(longTapGestureRecognizer)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedGame = games?[indexPath.row]
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedGame = nil
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if let gameToDelete = games?[indexPath.row] {
                dataController.deleteGame(game: gameToDelete)
                games = dataController.getGames()
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let navCon = segue.destination as? UINavigationController {
            if let gameVC = navCon.topViewController as? AJGameCollectionViewController {
                gameVC.game = nil//selectedGame
            }
        }
    }
 
    // MARK: - Actions
    
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
    
    @IBAction func editButtonClicked(_ sender: UIBarButtonItem) {
        let editing =  tableView.isEditing
        navigationItem.leftBarButtonItem = tableView.isEditing ?
            UIBarButtonItem.init(title: "Edit", style: .plain, target: self, action:#selector(AJGamesTableViewController.editButtonClicked(_:))) :
            UIBarButtonItem.init(title: "Done", style: .done, target: self, action:#selector(AJGamesTableViewController.editButtonClicked(_:)))
        tableView.setEditing(!editing, animated: true)
    }
    
    @objc private func handleCellLongTap(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .recognized {
            if let cell = gesture.view as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)
                
                if let editedGame = games?[indexPath!.row] {
                    
                    let alert = UIAlertController(title: "Edit game name", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addTextField { (textfield) in
                        textfield.text = editedGame.name
                        textfield.becomeFirstResponder()
                    }
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] action in
                        if let textField = alert.textFields?[0] {
                            if let enteredText = textField.text {
                                if (enteredText as NSString).length != 0 {
                                    self?.dataController.changeGameName(editedGame, to: enteredText)
                                    DispatchQueue.main.async {
                                        self?.loadData()
                                    }
                                } else {
                                    let errorAlert = UIAlertController(title: "Error", message: "Game name cannot be empty", preferredStyle: UIAlertControllerStyle.alert)
                                    errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                    self?.present(errorAlert, animated: true, completion: nil)
                                }
                            }
                        }
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
