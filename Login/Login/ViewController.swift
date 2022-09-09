//
//  ViewController.swift
//  Login
//
//  Created by Rajveer Singh on 08/09/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var forgotUserNameButton: UIButton!
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func forgotUserNameButtonTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "forgotUserNameOrPassword", sender: sender)
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "forgotUserNameOrPassword", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let sender = sender as? UIButton else {
            
            return
        }

        if sender == forgotUserNameButton {
            
            segue.destination.navigationItem.title = forgotUserNameButton.titleLabel!.text
        } else if sender == forgotPasswordButton {
            
            segue.destination.navigationItem.title = forgotPasswordButton.titleLabel!.text
        } else {
            
            segue.destination.navigationItem.title = userNameTextField.text
        }
    }
}

