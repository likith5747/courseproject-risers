//
//  FavoriteViewCell.swift
//  Sports Updates
//
//  Created by Sowmya  on 4/13/23.
//

import UIKit

class FavoriteViewCell: UITableViewCell {
    
    @IBOutlet weak var city: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
