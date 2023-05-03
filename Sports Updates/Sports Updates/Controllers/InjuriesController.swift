//
//  InjuriesController.swift
//  Sports Updates
//
//  Created by amati akiti on 4/11/23.
//

import UIKit
import DropDown
import Alamofire
import MBProgressHUD

class InjuriesController: UIViewController {
    
    private var NFLInjuries_data : [InjuriesStruct]?
    private var MLBInjuries_data : [MLBInjuriesStruct]?
    
    @IBOutlet weak var gamesegment: UISegmentedControl!
    @IBOutlet weak var Injuriestableview: UITableView!
    @IBOutlet weak var sign2: UIImageView!
    @IBOutlet weak var sign1: UIImageView!
    
    var year : String = ""
    var week : String = ""
    
    @IBOutlet weak var YearView: UIView!
    @IBOutlet weak var YearButton: UIButton!
    @IBOutlet weak var yearlabel: UILabel!
    
    @IBOutlet weak var WeekView: UIView!
    @IBOutlet weak var WeekButton: UIButton!
    @IBOutlet weak var Weeklabel: UILabel!
    
    let myDropDown = DropDown()
    let WeekdropDown = DropDown()
    let YearArray = ["2022", "2021", "2020", "2019", "2018","2017","2016","2015"]
    let WeekArray = ["1","2","3", "4"]
    
    @IBAction func Yeardropdown(_ sender: Any) {
        myDropDown.show()
    }
    
    @IBAction func Weekdown(_ sender: Any) {
        WeekdropDown.show()
    }
    
    
    @IBAction func gamevalue(_ sender: Any) {
        if gamesegment.selectedSegmentIndex == 0
        {
            yearlabel.isHidden = false
            Weeklabel.isHidden = false
            sign1.isHidden = false
            sign2.isHidden = false
            self.InjuriesAPI()
            self.Injuriestableview.reloadData()
        }
        if gamesegment.selectedSegmentIndex == 1
        {
            yearlabel.isHidden = true
            Weeklabel.isHidden = true
            sign1.isHidden = true
            sign2.isHidden = true
            self.MLBInjuriesAPI()
            self.Injuriestableview.reloadData()
        }
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        yearlabel.isHidden = false
        Weeklabel.isHidden = false
        sign1.isHidden = false
        sign2.isHidden = false
        
        year = "2022"
        week = "1"
        
        self.InjuriesAPI()
        self.Injuriestableview.reloadData()
        myDropDown.anchorView = YearView
        myDropDown.dataSource = YearArray
        
        myDropDown.bottomOffset = CGPoint(x: 0, y: 35)
        myDropDown.topOffset = CGPoint(x: 0, y: 35)
        myDropDown.direction = .bottom
        
        myDropDown.selectionAction = { (index: Int, item: String) in
            
            self.yearlabel.text = self.YearArray[index]
            self.year = self.YearArray[index]
            print("year",self.yearlabel.text)
            
            self.InjuriesAPI()
            self.Injuriestableview.reloadData()
            self.yearlabel.textColor = .black
        }
        
        WeekdropDown.anchorView = WeekView
        WeekdropDown.dataSource = WeekArray
        
        WeekdropDown.bottomOffset = CGPoint(x: 0, y: 35)
        WeekdropDown.topOffset = CGPoint(x: 0, y: 35)
        WeekdropDown.direction = .bottom
        
        WeekdropDown.selectionAction = { [self] (index: Int, item: String) in
            self.Weeklabel.text = self.WeekArray[index]
            self.week = self.WeekArray[index]
            
            print(self.Weeklabel.text)
            
            self.InjuriesAPI()
            self.Injuriestableview.reloadData()
            self.Weeklabel.textColor = .black
        }
    }
    
    private func InjuriesAPI() {
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.label.text = "Loading..."
        
        let headers: HTTPHeaders = [
            "Ocp-Apim-Subscription-Key": "79dd48b3bb1e474f83a056869874b61b"
        ]
        let api = "https://api.sportsdata.io/v3/nfl/stats/json/Injuries/" + year + "/" + week
        print("apilink",api)
        Alamofire.request(api, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                // Handle success response
                if let jsonArray = value as? [[String: Any]] {
                    let objects = try? JSONDecoder().decode([InjuriesStruct].self, from: JSONSerialization.data(withJSONObject: jsonArray))
                    print("Objects: \(objects)")
                    self.NFLInjuries_data = objects
                    self.Injuriestableview.reloadData()
                    progressHUD.hide(animated: true)
                    
                }
            case .failure(let error):
                // Handle error response
                print("error api",error.localizedDescription)
            }
        }
        
    }
    
    private func MLBInjuriesAPI()
    {
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.label.text = "Loading..."
        
        let headers: HTTPHeaders = [
            "Ocp-Apim-Subscription-Key": "004a094d32cf471daf653958a46d539c"
        ]
        let api = "https://api.sportsdata.io/v3/mlb/projections/json/PlayerGameProjectionStatsByDate/2017-JUL-31"
        print("apilink",api)
        Alamofire.request(api, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                // Handle success response
                if let jsonArray = value as? [[String: Any]] {
                    let objects = try? JSONDecoder().decode([MLBInjuriesStruct].self, from: JSONSerialization.data(withJSONObject: jsonArray))
                    print("Objects: \(objects)")
                    self.MLBInjuries_data = objects
                    self.Injuriestableview.reloadData()
                    progressHUD.hide(animated: true)
                    
                }
            case .failure(let error):
                // Handle error response
                print("error api",error.localizedDescription)
            }
        }
    }
    
}

extension InjuriesController: UITableViewDelegate,  UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        var value = 0
        switch gamesegment.selectedSegmentIndex
        
        {
            
        case 0:
            value = self.NFLInjuries_data?.count ?? 0
            print("MLBvalue", value)
            
            break
        case 1:
            value = self.MLBInjuries_data?.count ?? 0
            print("mlbvalue", value)
            break
            
        default:
            break
        }
        
        return value
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InjuriesViewCell", for: indexPath) as! InjuriesViewCell
        
        switch gamesegment.selectedSegmentIndex
        {
        case 0:
            cell.name.text = (self.NFLInjuries_data?[indexPath.row].Name!)! + "(" + (self.NFLInjuries_data?[indexPath.row].Team!)! + ")"
            cell.position.text = self.NFLInjuries_data?[indexPath.row].Position!
            
            let dateString = (self.NFLInjuries_data?[indexPath.row].Updated!)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let date = dateFormatter.date(from: dateString)
            
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "MMM d"
            let outputDateString = outputDateFormatter.string(from: date!)
            
            cell.date.text = outputDateString
            
            
            cell.status.text = self.NFLInjuries_data?[indexPath.row].Status!
            break
            
        case 1:
            cell.name.text = (self.MLBInjuries_data?[indexPath.row].Name!)! + "(" + (self.MLBInjuries_data?[indexPath.row].Team!)! + ")"
            cell.position.text = self.MLBInjuries_data?[indexPath.row].Position ?? "SP"
            
            let dateString = (self.MLBInjuries_data?[indexPath.row].DateTime!)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let date = dateFormatter.date(from: dateString)
            
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "MMM d"
            let outputDateString = outputDateFormatter.string(from: date!)
            
            cell.date.text = outputDateString
            
            
            cell.status.text = self.MLBInjuries_data?[indexPath.row].InjuryStatus!
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
        return 75
    }
    
}
