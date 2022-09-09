//
//  ViewController.swift
//  Traffic Segues
//
//  Created by Rajveer Singh on 07/09/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var segueSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func yellowButtonTapped(_ sender: Any) {
        
        if segueSwitch.isOn {
            
            performSegue(withIdentifier: "Yellow", sender: nil)
        }
    }
    
    @IBAction func greenButtonTapped(_ sender: Any) {
        
        if segueSwitch.isOn {
            
            performSegue(withIdentifier: "Green", sender: nil)
        }
    }
}

