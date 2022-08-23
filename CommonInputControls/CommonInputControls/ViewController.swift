//
//  ViewController.swift
//  CommonInputControls
//
//  Created by Rajveer Singh on 14/08/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var toggle: UISwitch!
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        print("Button was tapped!")
        
        if toggle.isOn {
            
            print("The switch is on!")
        } else {
            
            print("The switch if off!")
        }
        
        print("The slider is set to \(slider.value)")
    }
    
    @IBAction func switchToggled(_ sender: UISwitch) {
        
        if sender.isOn {
            
            print("The switch is on.")
        } else {
            
            print("The switch is off.")
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        print(sender.value)
    }

    @IBAction func keyboardReturnKeyTapped(_ sender: UITextField) {
        
        if let text = sender.text {
            
            print(text)
        }
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        
        if let text = sender.text {
            
            print(text)
        }
    }
    
    @IBAction func respondToTapGesture(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: view)
        
        print(location)
    }
}

