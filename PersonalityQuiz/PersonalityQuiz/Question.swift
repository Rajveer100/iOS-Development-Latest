//
//  Question.swift
//  PersonalityQuiz
//
//  Created by Rajveer Singh on 15/09/22.
//

import Foundation

struct Question {
    
    var text: String
    var type: ResponseType
    var answers: [Answer]
}

struct Answer {
    
    var text: String
    var type: AnimalType
}

enum ResponseType {
    
    case single
    case multiple
    case ranged
}

enum AnimalType: Character {
    
    case dog = "🐶"
    case cat = "🐱"
    case rabbit = "🐰"
    case turtle = "🐢"
    
    var definition: String {
        
        switch self {
            
        case .dog:
            
            return "You are incredibly outgoing. You surround yourself with the people you love and enjoy activities with your friends."
            
        case .cat:
            
            return "Mischeivous, yet mild-tempered, you enjoy doing things on your own terms."
            
        case .rabbit:
            
            return "You love everything that's soft. You are healthy and full of energy."
            
        case .turtle:
            
            return "You are wise beyond your years, and you focus on the details. Slow and steady wins the race."
        }
    }
}
