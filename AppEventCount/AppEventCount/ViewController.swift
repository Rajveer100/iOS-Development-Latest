//
//  ViewController.swift
//  AppEventCount
//
//  Created by Rajveer Singh on 21/09/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var didFinishLaunchingLabel: UILabel!
    @IBOutlet weak var configurationForConnectingLabel: UILabel!
    @IBOutlet weak var sceneWillConnectLabel: UILabel!
    @IBOutlet weak var sceneDidBecomeActiveLabel: UILabel!
    @IBOutlet weak var sceneWillResignActiveLabel: UILabel!
    @IBOutlet weak var sceneWillEnterForegroundLabel: UILabel!
    @IBOutlet weak var sceneWillEnterBackgroundLabel: UILabel!
    @IBOutlet weak var sceneDidEnterBackgroundLabel: UILabel!
    
    var sceneWillConnectCount = 0
    var sceneDidBecomeActiveCount = 0
    var sceneWillResignActiveCount = 0
    var sceneWillEnterForegroundCount = 0
    var sceneWillEnterBackgroundCount = 0
    var sceneDidEnterBackgroundCount = 0
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }

    func updateView() {
        
        didFinishLaunchingLabel.text = "The App has launched \(appDelegate.launchCount) time(s)"
        configurationForConnectingLabel.text = "Configuration for connecting count is \(appDelegate.configurationForConnectingCount) time(s)"
        
        sceneWillConnectLabel.text = "Scene will connect count is \(sceneWillConnectCount) time(s)"
        
        sceneDidBecomeActiveLabel.text = "Scene did become active count is \(sceneDidBecomeActiveCount) time(s)"
        
        sceneWillResignActiveLabel.text = "Scene will resign active count is \(sceneWillResignActiveCount) time(s)"
        
        sceneWillEnterForegroundLabel.text = "Scene will enter foreground count is \(sceneWillEnterForegroundCount) time(s)"
        
        sceneWillEnterBackgroundLabel.text = "Scene will enter background connect count is \(sceneWillEnterBackgroundCount) time(s)"
        
        sceneDidEnterBackgroundLabel.text = "Scene did enter background count is \(sceneDidEnterBackgroundCount) time(s)"
    }
}

