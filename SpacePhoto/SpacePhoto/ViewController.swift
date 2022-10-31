//
//  ViewController.swift
//  SpacePhoto
//
//  Created by Rajveer Singh on 30/10/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    
    let photoInfoController = PhotoInfoController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = ""
        imageView.image = UIImage(systemName: "photo.on.rectangle")
        
        descriptionLabel.text = ""
        copyrightLabel.text = ""
        
        Task {
            
            do {
                
                let photoInfo = try await photoInfoController.fetchPhotoInfo()
                
                title = photoInfo.title
                descriptionLabel.text = photoInfo.description
                copyrightLabel.text = photoInfo.copyright
                
                updateUI(with: photoInfo)
            } catch {
                
                title = "Error Fetching Photo"
                imageView.image = UIImage(systemName: "exclamation.octagon")
                descriptionLabel.text = error.localizedDescription
                copyrightLabel.text = ""
            }
        }
    }

    func updateUI(with photoInfo: PhotoInfo) {
        
        Task {
            
            do {
                
                let image = try await photoInfoController.fetchImage(from: photoInfo.url)
                
                imageView.image = image
            } catch {
                
                imageView.image = UIImage(systemName: "exclamation.octagon")
            }
        }
    }
}
