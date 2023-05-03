//
//  StandingsController.swift
//  Sports Updates
//
//  Created by Vamsi Revanth Vema on 4/11/23.
//

import UIKit
import DropDown
import Alamofire
import MBProgressHUD

class StandingsController: UIViewController {
    
    @IBOutlet weak var standingtableview: UITableView!
    
    private var NFLStanding_data : [StandingStruct]?
    private var MLBStanding_data : [MLBStandingStruct]?
    var year : String = ""
    var type : String = ""
    
    @IBOutlet weak var YearView: UIView!
    @IBOutlet weak var YearButton: UIButton!
    @IBOutlet weak var yearlabel: UILabel!
    
    @IBOutlet weak var sessiontypeView: UIView!
    @IBOutlet weak var sessiontypeButton: UIButton!
    @IBOutlet weak var sessiontypelabel: UILabel!
    
    let myDropDown = DropDown()
    let sessiontypedropDown = DropDown()
    let YearArray = ["2022", "2021", "2020", "2019", "2018","2017","2016","2015"]
    let sessiontypeArray = ["REG","PRE", "POST"]
    
    
    
    @IBAction func Yeardropdown(_ sender: Any) {
        myDropDown.show()
    }
    
    @IBAction func sessiontypedown(_ sender: Any) {
        sessiontypedropDown.show()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        year = "2022"
        type = ""
        self.StandingAPI()
        self.standingtableview.reloadData()
        myDropDown.anchorView = YearView
        myDropDown.dataSource = YearArray
        
        myDropDown.bottomOffset = CGPoint(x: 0, y: 35)
        myDropDown.topOffset = CGPoint(x: 0, y: 35)
        myDropDown.direction = .bottom
        
        myDropDown.selectionAction = { (index: Int, item: String) in
            self.yearlabel.text = self.YearArray[index]
            self.year = self.YearArray[index]
            print("year",self.yearlabel.text)
            
            self.StandingAPI()
            self.MLBStandingAPI()
            self.standingtableview.reloadData()
            self.yearlabel.textColor = .black
        }
        
        sessiontypedropDown.anchorView = sessiontypeView
        sessiontypedropDown.dataSource = sessiontypeArray
        
        sessiontypedropDown.bottomOffset = CGPoint(x: 0, y: 35)
        sessiontypedropDown.topOffset = CGPoint(x: 0, y: 35)
        sessiontypedropDown.direction = .bottom
        
        sessiontypedropDown.selectionAction = { [self] (index: Int, item: String) in
            self.sessiontypelabel.text = self.sessiontypeArray[index]
            self.type = self.sessiontypeArray[index]
            
            print(self.sessiontypelabel.text)
            
            self.StandingAPI()
            self.MLBStandingAPI()
            self.standingtableview.reloadData()
            self.sessiontypelabel.textColor = .black
        }
        
    }
    

    @IBOutlet weak var gamesegment: UISegmentedControl!
    
    @IBAction func gamevalue(_ sender: Any) {
        if gamesegment.selectedSegmentIndex == 0
        {
            StandingAPI()
            self.standingtableview.reloadData()
        }
        if gamesegment.selectedSegmentIndex == 1
        {
            MLBStandingAPI()
            self.standingtableview.reloadData()
        }
        
        
    }
    
    private func StandingAPI()  {
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.label.text = "Loading..."
        
        let headers: HTTPHeaders = [
            "Ocp-Apim-Subscription-Key": "79dd48b3bb1e474f83a056869874b61b"
        ]
        
        let api = "https://api.sportsdata.io/v3/nfl/scores/json/Standings/" + year + type
        Alamofire.request(api, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                // Handle success response
                if let jsonArray = value as? [[String: Any]] {
                    let objects = try? JSONDecoder().decode([StandingStruct].self, from: JSONSerialization.data(withJSONObject: jsonArray))
                    print("Objects: \(objects)")
                    self.NFLStanding_data = objects
                    self.standingtableview.reloadData()
                    progressHUD.hide(animated: true)
                    
                }
            case .failure(let error):
                // Handle error response
                print("error api",error.localizedDescription)
            }
        }
    }
    private func MLBStandingAPI()
    {
        
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.label.text = "Loading..."
        
        let headers: HTTPHeaders = [
            "Ocp-Apim-Subscription-Key": "004a094d32cf471daf653958a46d539c"
        ]
        
        let api = "https://api.sportsdata.io/v3/mlb/scores/json/Standings/" + year + type
        Alamofire.request(api, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                // Handle success response
                if let jsonArray = value as? [[String: Any]] {
                    let objects = try? JSONDecoder().decode([MLBStandingStruct].self, from: JSONSerialization.data(withJSONObject: jsonArray))
                    print("MLBObjects: \(String(describing: objects))")
                    self.MLBStanding_data = objects
                    self.standingtableview.reloadData()
                    progressHUD.hide(animated: true)
                    
                }
            case .failure(let error):
                // Handle error response
                print("error api",error.localizedDescription)
            }
        }
    }
    
}

extension StandingsController: UITableViewDelegate,  UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return self.NFLStanding_data?.count ?? 0
        var value = 0
        switch gamesegment.selectedSegmentIndex
        
        {
            
        case 0:
            value = self.NFLStanding_data?.count ?? 0
            
            break
        case 1:
            value = self.MLBStanding_data?.count ?? 0
            break
            
        default:
            break
        }
        
        return value
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StandingCell", for: indexPath) as! StandingCell
        
        switch gamesegment.selectedSegmentIndex
        
        {
        case 0:
            cell.team.text = self.NFLStanding_data?[indexPath.row].Team!
            cell.name.text = self.NFLStanding_data?[indexPath.row].Name!
            cell.div.text = self.NFLStanding_data?[indexPath.row].Division!
            
            let win_int = self.NFLStanding_data?[indexPath.row].Wins!
            let win_string = "\(win_int!)"
            cell.win.text = win_string
            
            let loss_int = self.NFLStanding_data?[indexPath.row].Losses!
            let loss_string = "\(loss_int!)"
            cell.loss.text = loss_string
            
            let divwin_int = self.NFLStanding_data?[indexPath.row].DivisionWins!
            let divwin_string = "\(divwin_int!)"
            cell.divwin.text = divwin_string
            
            let divloss_int = self.NFLStanding_data?[indexPath.row].DivisionLosses!
            let divloss_string = "\(divloss_int!)"
            cell.divloss.text = divloss_string
            
            let percentage_int = self.NFLStanding_data?[indexPath.row].Percentage!
            let percentage_string = "\(percentage_int!)"
            cell.percentage.text = percentage_string
            
            

            break
            
        case 1:
            cell.team.text = self.MLBStanding_data?[indexPath.row].Key!
            cell.name.text = self.MLBStanding_data?[indexPath.row].Name!
            cell.div.text = self.MLBStanding_data?[indexPath.row].Division!
            
            let win_int = self.MLBStanding_data?[indexPath.row].Wins!
            let win_string = "\(win_int!)"
            cell.win.text = win_string
            
            let loss_int = self.MLBStanding_data?[indexPath.row].Losses!
            let loss_string = "\(loss_int!)"
            cell.loss.text = loss_string
            
            let divwin_int = self.MLBStanding_data?[indexPath.row].DivisionWins!
            let divwin_string = "\(divwin_int!)"
            cell.divwin.text = divwin_string
            
            let divloss_int = self.MLBStanding_data?[indexPath.row].DivisionLosses!
            let divloss_string = "\(divloss_int!)"
            cell.divloss.text = divloss_string
            
            let percentage_int = self.MLBStanding_data?[indexPath.row].Percentage!
            let percentage_string = "\(percentage_int!)"
            cell.percentage.text = percentage_string
            
            
            break
            
        default:
            break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
}
