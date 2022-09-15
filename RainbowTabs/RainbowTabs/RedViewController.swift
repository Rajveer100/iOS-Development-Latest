//
//  ViewController.swift
//  RainbowTabs
//
//  Created by Rajveer Singh on 10/09/22.
//

import UIKit

class RedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarItem.badgeValue = "!"
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        tabBarItem.badgeValue = nil
    }
}

