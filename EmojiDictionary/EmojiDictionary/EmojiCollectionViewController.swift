// EmojiDictionary

import UIKit

private let reuseIdentifier = "Item"

class EmojiCollectionViewController: UICollectionViewController {

    var emojis: [Emoji] = [
        Emoji(symbol: "π", name: "Grinning Face", description: "A typical smiley face.", usage: "happiness"),
        Emoji(symbol: "π", name: "Confused Face", description: "A confused, puzzled face.", usage: "unsure what to think; displeasure"),
        Emoji(symbol: "π", name: "Heart Eyes", description: "A smiley face with hearts for eyes.", usage: "love of something; attractive"),
        Emoji(symbol: "π§βπ»", name: "Developer", description: "A person working on a MacBook (probably using Xcode to write iOS apps in Swift).", usage: "apps, software, programming"),
        Emoji(symbol: "π’", name: "Turtle", description: "A cute turtle.", usage: "something slow"),
        Emoji(symbol: "π", name: "Elephant", description: "A gray elephant.", usage: "good memory"),
        Emoji(symbol: "π", name: "Spaghetti", description: "A plate of spaghetti.", usage: "spaghetti"),
        Emoji(symbol: "π²", name: "Die", description: "A single die.", usage: "taking a risk, chance; game"),
        Emoji(symbol: "βΊοΈ", name: "Tent", description: "A small tent.", usage: "camping"),
        Emoji(symbol: "π", name: "Stack of Books", description: "Three colored books stacked on each other.", usage: "homework, studying"),
        Emoji(symbol: "π", name: "Broken Heart", description: "A red, broken heart.", usage: "extreme sadness"),
        Emoji(symbol: "π€", name: "Snore", description: "Three blue \'z\'s.", usage: "tired, sleepiness"),
        Emoji(symbol: "π", name: "Checkered Flag", description: "A black-and-white checkered flag.", usage: "completion")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(70)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        collectionView.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard section == 0 else { return 0 }
        
        return emojis.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EmojiCollectionViewCell
        
        let emoji = emojis[indexPath.item]

        cell.update(with: emoji)

        return cell
    }

    @IBSegueAction func addEditEmoji(_ coder: NSCoder, sender: Any?) -> AddEditEmojiTableViewController? {
        
        if let cell = sender as? UICollectionViewCell,
           let indexPath = collectionView.indexPath(for: cell) {
            
            let emojiToEdit = emojis[indexPath.row]
            
            return AddEditEmojiTableViewController(coder: coder, emoji: emojiToEdit)
        } else {
            
            return AddEditEmojiTableViewController(coder: coder, emoji: nil)
        }
    }
    
    @IBAction func unwindToEmojiTableView(segue: UIStoryboardSegue) {
        
        guard segue.identifier == "saveUnwind",
              let sourceViewController = segue.source as? AddEditEmojiTableViewController,
              let emoji = sourceViewController.emoji else { return }
        
        if let indexPath = collectionView.indexPathsForSelectedItems?.first {
            
            emojis[indexPath.item] = emoji
            collectionView.reloadItems(at: [indexPath])
        } else {
            
            let newIndexPath = IndexPath(row: emojis.count, section: 0)
            
            emojis.append(emoji)
            collectionView.insertItems(at: [newIndexPath])
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (elements) -> UIMenu? in
            
            let delete = UIAction(title: "Delete") { (action) in
                
                self.deleteEmoji(at: indexPaths.first!)
            }
            
            return UIMenu(title: "", image: nil, identifier: nil, options: [], children: [delete])
        }
        
        return config
    }
    
    func deleteEmoji(at indexPath: IndexPath) {
        
        emojis.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
    }
}
