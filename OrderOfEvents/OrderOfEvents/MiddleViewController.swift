//
//  MiddleViewController.swift
//  OrderOfEvents
//
//  Created by Rajveer Singh on 13/09/22.
//

import UIKit

class MiddleViewController: UIViewController {

    @IBOutlet weak var middleViewLabel: UILabel!
    var eventNumber = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addEvent(from: "viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        addEvent(from: "viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        addEvent(from: "viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        addEvent(from: "viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        addEvent(from: "viewDidDisappear")
    }
    
    func addEvent(from: String) {
        
        if let existingText = middleViewLabel.text {
            
            middleViewLabel.text = "\(existingText)\nEvent Number \(eventNumber) was \(from)"
            eventNumber += 1
        }
    }
}
