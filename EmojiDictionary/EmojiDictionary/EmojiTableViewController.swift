//
//  EmojiTableViewController.swift
//  EmojiDictionary
//
//  Created by Rajveer Singh on 26/09/22.
//

import UIKit

class EmojiTableViewController: UITableViewController {

    var emojis: [Emoji] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = editButtonItem
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        
        let retrievedEmojis = Emoji.loadFromFile()
        
        if retrievedEmojis.isEmpty {
            
            emojis = Emoji.sampleEmojis()
        } else {
            
            emojis = retrievedEmojis
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    @IBSegueAction func addEditEmoji(_ coder: NSCoder, sender: Any?) -> AddEditEmojiTableViewController? {
        
        guard let cell = sender as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell) else {
            
            return AddEditEmojiTableViewController(coder: coder, emoji: nil)
        }
        
        let emojiToEdit = emojis[indexPath.row]
        
        return AddEditEmojiTableViewController(coder: coder, emoji: emojiToEdit)
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        
        let tableViewEditingMode = tableView.isEditing
        
        tableView.setEditing(tableViewEditingMode, animated: true)
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToEmojiTableView(from segue: UIStoryboardSegue) {
        
        guard segue.identifier == "saveUnwind",
              let sourceViewController = segue.source as? AddEditEmojiTableViewController,
              let emoji = sourceViewController.emoji else {
            
            return
        }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            
            emojis[selectedIndexPath.row] = emoji
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            
            let newIndexPath = IndexPath(row: emojis.count, section: 0)
            emojis.append(emoji)
            
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        
        Emoji.saveToFile(emojis: emojis)
    }

    //MARK: TableView Data Source and Delegate Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return emojis.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell", for: indexPath) as! EmojiTableViewCell
        let emoji = emojis[indexPath.row]
        
        cell.update(with: emoji)
        cell.showsReorderControl = true
        
        return cell
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let movedEmoji = emojis.remove(at: sourceIndexPath.row)
        
        emojis.insert(movedEmoji, at: destinationIndexPath.row)
        
        Emoji.saveToFile(emojis: emojis)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            emojis.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        Emoji.saveToFile(emojis: emojis)
    }
}
