//
//  ResultsViewController.swift
//  PersonalityQuiz
//
//  Created by Rajveer Singh on 15/09/22.
//

import UIKit

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var resultAnswerLabel: UILabel!
    @IBOutlet weak var resultDefinitionLabel: UILabel!
    
    
    var responses: [Answer]

    init?(coder: NSCoder, responses: [Answer]) {
        
        self.responses = responses
        
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
    
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        navigationItem.hidesBackButton = true
        calculatePersonalityResult()
    }

    func calculatePersonalityResult() {
        
        let frequencyOfAnswers = responses.reduce(into: [:]) { (counts, answer) in
            
            counts[answer.type, default: 0] += 1
        }
        
        let mostCommonAnswer = frequencyOfAnswers.sorted { (pair1, pair2) in
            
            return pair1.value > pair2.value
        }.first!.key
        
        print(mostCommonAnswer)
        resultAnswerLabel.text = "You are a \(mostCommonAnswer.rawValue)"
        resultDefinitionLabel.text = mostCommonAnswer.definition
    }
}
