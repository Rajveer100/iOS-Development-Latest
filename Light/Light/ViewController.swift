//
//  ViewController.swift
//  Light
//
//  Created by Rajveer Singh on 13/06/22.
//

import UIKit

class ViewController: UIViewController {

    var lightOn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        updateUI()
    }

    fileprivate func updateUI() {
        
        view.backgroundColor = lightOn ? .white : .black
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        lightOn.toggle()
        
        updateUI()
    }
    
}

