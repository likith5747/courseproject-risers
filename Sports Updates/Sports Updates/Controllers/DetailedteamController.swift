//
//  DetailedteamController.swift
//  Sports Updates
//
//  Created by Sowmya  on 4/17/23.
//

import UIKit
import Alamofire
import MBProgressHUD

class DetailedteamController: UIViewController {
    
    var teamname: String?
    
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var conferenec: UILabel!
    @IBOutlet weak var division: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var headcoach: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.DetailedfavoriteAPI()
        
        print("teamname",teamname)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.DetailedfavoriteAPI()
    }
    
    private func DetailedfavoriteAPI()
    {
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.label.text = "Loading..."
        
        let api = "https://api.sportsdata.io/v3/nfl/scores/json/Teams?key=79dd48b3bb1e474f83a056869874b61b"
        
        Alamofire.request(api).responseJSON { response in
            switch response.result {
            case .success(let value):
                // Handle success response
                if let jsonArray = value as? [[String: Any]] {
                    let objects = try? JSONDecoder().decode([FavoriteStruct].self, from: JSONSerialization.data(withJSONObject: jsonArray))
                    print("newsObjects: \(objects)")
                    for i in 0...objects!.count-1
                    {
                        if(objects![i].Key == self.teamname)
                        {
                            self.fullname.text = objects![i].FullName
                            self.conferenec.text = objects![i].Conference
                            self.headcoach.text = objects![i].HeadCoach
                            self.position.text = objects![i].Key
                            self.division.text = objects![i].Division
                        }
                    }
                    progressHUD.hide(animated: true)
                }
            case .failure(let error):
                // Handle error response
                print("error api",error.localizedDescription)
            }
        }
    }
}
