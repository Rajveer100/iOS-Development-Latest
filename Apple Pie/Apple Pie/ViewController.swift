//
//  ViewController.swift
//  Apple Pie
//
//  Created by Rajveer Singh on 23/08/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var treeImageView: UIImageView!
    @IBOutlet var letterButtons: [UIButton]!
    @IBOutlet weak var correctWordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var listOfWords = ["programming", "logic", "math", "swift", "xcode", "development"]
    let incorrectMovesAllowed = 7
    
    var totalWins = 0 {
        
        didSet {
            
            newRound()
        }
    }
    var totalLosses = 0 {
        
        didSet {
        
            newRound()
        }
    }
    
    var currentGame: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newRound()
    }
    
    @IBAction func letterButtonPressed(_ sender: UIButton) {
        
        sender.isEnabled = false
        
        let letterString = sender.configuration!.title!
        let letter = Character(letterString.lowercased())
        
        currentGame.playerGuessed(letter: letter)
        
        updateGameState()
    }
    
    func newRound() {
        
        if !listOfWords.isEmpty {
            
            let newWord = listOfWords.removeFirst()
            currentGame = Game(word: newWord,
                               incorrectMovesRemaining: incorrectMovesAllowed,
                               guessedLetters: [])
            
            enableLetterOfButtons(true)
            updateUI()
        } else {
            
            enableLetterOfButtons(false)
        }
    }
    
    func enableLetterOfButtons(_ enable: Bool) {
        
        for button in letterButtons {
            
            button.isEnabled = enable
        }
    }
    
    func updateUI() {
        
        var letters = [String]()
        
        for letter in currentGame.formattedWord {
            
            letters.append(String(letter))
        }
        
        let wordWithSpacing = letters.joined(separator: " ")
        
        correctWordLabel.text = wordWithSpacing
        scoreLabel.text = "Wins: \(totalWins), Losses: \(totalLosses)"
        treeImageView.image = UIImage(named: "Tree \(currentGame.incorrectMovesRemaining)")
    }
    
    func updateGameState() {
        
        if currentGame.incorrectMovesRemaining == 0 {
            
            totalLosses += 1
        } else if currentGame.word == currentGame.formattedWord {
            
            totalWins += 1
        } else {
            
            updateUI()
        }
    }
}

