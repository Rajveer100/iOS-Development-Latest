//
//  BookTableViewCell.swift
//  FavoriteBooks
//
//  Created by Rajveer Singh on 28/09/22.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(with book: Book) {
        
        titleLabel.text = book.title
        authorLabel.text = book.author
        genreLabel.text = book.genre
        descriptionLabel.text = book.description
    }
}
