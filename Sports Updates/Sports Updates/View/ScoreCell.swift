//
//  ScoreCell.swift
//  Sports Updates
//
//  Created by Likith Burugu on 4/12/23.
//

import UIKit

class ScoreCell: UITableViewCell {
    
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var week: UILabel!
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var first: UILabel!
    @IBOutlet weak var second: UILabel!
    @IBOutlet weak var third: UILabel!
    @IBOutlet weak var fourth: UILabel!
    @IBOutlet weak var total: UILabel!
    
    @IBOutlet weak var team1: UILabel!
    @IBOutlet weak var team1score1: UILabel!
    @IBOutlet weak var team1score2: UILabel!
    @IBOutlet weak var team1score3: UILabel!
    @IBOutlet weak var team1score4: UILabel!
    @IBOutlet weak var team1total: UILabel!
    
    @IBOutlet weak var team2: UILabel!
    @IBOutlet weak var team2score1: UILabel!
    @IBOutlet weak var team2score2: UILabel!
    @IBOutlet weak var team2score4: UILabel!
    @IBOutlet weak var team2score3: UILabel!
    @IBOutlet weak var team2total: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
