//
//  StandingCell.swift
//  Sports Updates
//
//  Created by Vamsi Revanth Vema on 4/15/23.
//

import UIKit

class StandingCell: UITableViewCell {
    
    @IBOutlet weak var team: UILabel!
    
    @IBOutlet weak var div: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var win: UILabel!
    
    @IBOutlet weak var loss: UILabel!
    @IBOutlet weak var divwin: UILabel!
    @IBOutlet weak var percentage: UILabel!
    @IBOutlet weak var divloss: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
