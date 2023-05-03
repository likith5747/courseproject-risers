//
//  SelectedViewCell.swift
//  Sports Updates
//
//  Created by Sowmya  on 4/17/23.
//

import UIKit

class SelectedViewCell: UITableViewCell {
    
    @IBOutlet weak var Favoriteteam: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
