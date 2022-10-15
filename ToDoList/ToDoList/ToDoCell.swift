//
//  ToDoCell.swift
//  ToDoList
//
//  Created by Rajveer Singh on 15/10/22.
//

import UIKit

protocol ToDoCellDelegate: AnyObject {
    
    func checkmarkTapped(sender: ToDoCell)
}

class ToDoCell: UITableViewCell {

    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var delegate: ToDoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    @IBAction func checkmarkTapped(_ sender: Any) {
        
        delegate?.checkmarkTapped(sender: self)
    }
    
}
