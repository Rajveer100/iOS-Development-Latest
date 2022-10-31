//
//  ViewController.swift
//  Contest
//
//  Created by Rajveer Singh on 22/10/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func submitButtonTapped() {
        
        if !emailTextField.text!.isEmpty {
            
            performSegue(withIdentifier: "registeredSegue", sender: nil)
        } else {
            
            UIView.animateKeyframes(withDuration: 0.1, delay: 0, animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2, animations: {
                    
                    UIView.animate(withDuration: 0.1, animations: {
                        
                        self.emailTextField.transform = CGAffineTransform(translationX: 5, y: 0)
                    }) { (_) in
                        
                        UIView.animate(withDuration: 0.1, animations: {
                            
                            self.emailTextField.transform = CGAffineTransform(translationX: -5, y: 0)
                        }) { (_) in
                            
                            self.emailTextField.transform = CGAffineTransform.identity
                        }
                    }
                })
            })
        }
    }
}

