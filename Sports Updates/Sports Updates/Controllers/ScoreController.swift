//
//  ScoreControllerViewController.swift
//  Sports Updates
//
//  Created by Likith Burugu on 4/11/23.
//

import UIKit
import DropDown
import Alamofire
import MBProgressHUD
import FSCalendar

class ScoreController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    
    
    @IBOutlet weak var gamesegment: UISegmentedControl!

    @IBOutlet weak var scoretableview: UITableView!

    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var YearView: UIView!
    @IBOutlet weak var YearButton: UIButton!
    @IBOutlet weak var yearlabel: UILabel!
    
    @IBOutlet weak var sessiontypeView: UIView!
    @IBOutlet weak var sessiontypeButton: UIButton!
    @IBOutlet weak var sessiontypelabel: UILabel!
    
    @IBOutlet weak var sign1: UIImageView!
    @IBOutlet weak var sign2: UIImageView!
    
    private var NFLScore_data : [ScoreStruct]?
    private var MLBScor_data : [MLBScoreStruct]?
   
    let myDropDown = DropDown()
    let sessiontypedropDown = DropDown()
    
    let YearArray = ["2022", "2021", "2020", "2019", "2018","2017","2016","2015"]
    let sessiontypeArray = ["PRE", "POST", "STAR"]
    
    var year : String = ""
    var type : String = ""
    var MLB_date : String = ""

    @IBAction func Yeardropdown(_ sender: Any) {
        
        if gamesegment.selectedSegmentIndex == 0
        {
            myDropDown.show()
        }
    }
    
    @IBAction func sessiontypedown(_ sender: Any) {
        if gamesegment.selectedSegmentIndex == 0
        {
            sessiontypedropDown.show()
        }
    }
    
    var isViewHidden = true
    
    @IBAction func showcalender(_ sender: Any) {
        if( isViewHidden == true)
        {
            calendar.isHidden = false
            calendar.backgroundColor = UIColor.white
            calendar.appearance.titleFont = UIFont.systemFont(ofSize: 12)
            calendar.appearance.selectionColor = UIColor.blue
            isViewHidden = false
        }
        else
        {
            calendar.isHidden = true
            calendar.backgroundColor = UIColor.white
            calendar.appearance.titleFont = UIFont.systemFont(ofSize: 12)
            calendar.appearance.selectionColor = UIColor.blue
            isViewHidden = true
        }
        
    }
    
    @IBOutlet weak var showbutton: UIButton!
    
    @IBAction func gamevalue(_ sender: UISegmentedControl)
    {
        if gamesegment.selectedSegmentIndex == 0
        {
            ScoreAPI()
            
            self.scoretableview.reloadData()
            yearlabel.isHidden = false
            sessiontypelabel.isHidden = false
            calendar.isHidden = true
            sign1.isHidden = false
            sign2.isHidden = false
            showbutton.isHidden = true
        }
        
        if gamesegment.selectedSegmentIndex == 1
        {
            MLB_date = "2023-03-14"
            MLBScoreAPI()
            self.scoretableview.reloadData()
            yearlabel.isHidden = true
            sessiontypelabel.isHidden = true
            calendar.isHidden = true
            sign1.isHidden = true
            sign2.isHidden = true
            showbutton.isHidden = false
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showbutton.isHidden = true
        yearlabel.isHidden = false
        sessiontypelabel.isHidden = false
        calendar.isHidden = true
        sign1.isHidden = false
        sign2.isHidden = false
        year = "2022"
        type = ""
        
        MLB_date = ""
        
        ScoreAPI()
        
        self.scoretableview.reloadData()
        
        myDropDown.anchorView = YearView
        myDropDown.dataSource = YearArray
        
        myDropDown.bottomOffset = CGPoint(x: 0, y: 35)
        myDropDown.topOffset = CGPoint(x: 0, y: 35)
        myDropDown.direction = .bottom
        
        myDropDown.selectionAction = { (index: Int, item: String) in
            self.yearlabel.text = self.YearArray[index]
            self.year = self.YearArray[index]
            print("year",self.yearlabel.text)
            self.ScoreAPI()
            self.scoretableview.reloadData()
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
            self.ScoreAPI()
            self.scoretableview.reloadData()
            self.sessiontypelabel.textColor = .black
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        yearlabel.isHidden = false
        sessiontypelabel.isHidden = false
        calendar.isHidden = true
        sign1.isHidden = false
        sign2.isHidden = false
        showbutton.isHidden = true
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // Handle the selected date here
        print("MLB_dateMLB_date",date)
        let originalString = "\(date)"
        let datestring = originalString.split(separator: " ").first.map(String.init) ?? ""
        print("datestring",datestring) // Output: "John"
        MLB_date = datestring
        calendar.isHidden = true
        MLBScoreAPI()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        // Handle the page change event here
    }
    
    private func ScoreAPI()
    {
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.label.text = "Loading..."
        
        let headers: HTTPHeaders = [
            "Ocp-Apim-Subscription-Key": "79dd48b3bb1e474f83a056869874b61b"
        ]
        
        let api = "https://api.sportsdata.io/v3/nfl/scores/json/Scores/" + year + type
        Alamofire.request(api, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                // Handle success response
                if let jsonArray = value as? [[String: Any]] {
                    let objects = try? JSONDecoder().decode([ScoreStruct].self, from: JSONSerialization.data(withJSONObject: jsonArray))
                    print("Objects: \(objects)")
                    self.NFLScore_data = objects
                    self.scoretableview.reloadData()
                    progressHUD.hide(animated: true)
                }
            case .failure(let error):
                // Handle error response
                print(error.localizedDescription)
            }
        }
    }
    
    private func MLBScoreAPI(){
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.label.text = "Loading..."
        
        let headers: HTTPHeaders = [
            "Ocp-Apim-Subscription-Key": "004a094d32cf471daf653958a46d539c"
        ]
        
        let api = "https://api.sportsdata.io/v3/mlb/stats/json/BoxScores/" + MLB_date
        Alamofire.request(api, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                // Handle success response
                if let jsonArray = value as? [[String: Any]] {
                    let objects = try? JSONDecoder().decode([MLBScoreStruct].self, from: JSONSerialization.data(withJSONObject: jsonArray))
                    //print("mlbObjects: \(String(describing: objects))")
                    // print("mlbObjects0: \(String(describing: objects![0].Game))")
                    self.MLBScor_data = objects
                    self.scoretableview.reloadData()
                    progressHUD.hide(animated: true)
                    
                }
            case .failure(let error):
                // Handle error response
                print(error.localizedDescription)
            }
        }
    }
}

extension ScoreController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var value = 0
        
        switch gamesegment.selectedSegmentIndex
        {
        case 0:
            value = self.NFLScore_data?.count ?? 0
            print("nflvalue", value)
            
            break
            
        case 1:
            value = self.MLBScor_data?.count ?? 0
            print("mlbvalue", value)
            
            break
            
        default: break
            
        }
        return value
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath) as! ScoreCell
        
        switch gamesegment.selectedSegmentIndex
        {
        case 0:
            
            cell.first.text = "1"
            cell.second.text = "2"
            cell.third.text = "3"
            cell.fourth.text = "4"
            cell.total.text = "T"
            
            let week_int = self.NFLScore_data?[indexPath.row].Week!
            let week_string = "\(week_int!)"
            cell.week.text = "Week-" + week_string
            
            let dateString = (self.NFLScore_data?[indexPath.row].Date!)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let date = dateFormatter.date(from: dateString)
            
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "MMMM d, yyyy"
            let outputDateString = outputDateFormatter.string(from: date!)
            
            cell.date.text = outputDateString
            
            cell.team1.text = self.NFLScore_data?[indexPath.row].AwayTeam!
            cell.team2.text = self.NFLScore_data?[indexPath.row].HomeTeam!
            
            
            let team1score1_int = self.NFLScore_data?[indexPath.row].AwayScoreQuarter1!
            let team1score1_string = "\(team1score1_int!)"
            cell.team1score1.text = team1score1_string
            
            
            let team1score2_int = self.NFLScore_data?[indexPath.row].AwayScoreQuarter2!
            let team1score2_string = "\(team1score2_int!)"
            cell.team1score2.text = team1score2_string
            
            
            let team1score3_int = self.NFLScore_data?[indexPath.row].AwayScoreQuarter3!
            let team1score3_string = "\(team1score2_int!)"
            cell.team1score3.text = team1score2_string
            
            
            let team1score4_int = self.NFLScore_data?[indexPath.row].AwayScoreQuarter4!
            let team1score4_string = "\(team1score4_int!)"
            cell.team1score4.text = team1score4_string
            
            
            
            let team2score1_int = self.NFLScore_data?[indexPath.row].HomeScoreQuarter1!
            let team2score1_string = "\(team2score1_int!)"
            cell.team2score1.text = team2score1_string
            
            let team2score2_int = self.NFLScore_data?[indexPath.row].HomeScoreQuarter2!
            let team2score2_string = "\(team2score2_int!)"
            cell.team2score2.text = team2score2_string
            
            
            let team2score3_int = self.NFLScore_data?[indexPath.row].HomeScoreQuarter3!
            let team2score3_string = "\(team2score3_int!)"
            cell.team2score3.text = team2score3_string
            
            
            let team2score4_int = self.NFLScore_data?[indexPath.row].HomeScoreQuarter4!
            let team2score4_string = "\(team2score4_int!)"
            cell.team2score4.text = team2score4_string
            
            
            let team1total_int = self.NFLScore_data?[indexPath.row].AwayScore!
            let team1total_string = "\(team1total_int!)"
            cell.team1total.text = team1total_string
            
            let team2total_int = self.NFLScore_data?[indexPath.row].HomeScore!
            let team2total_string = "\(team2total_int!)"
            cell.team2total.text = team2total_string
                        
            cell.status.text = self.NFLScore_data?[indexPath.row].Status!
            
            break
            
        case 1:
            
            cell.first.text = "R"
            cell.second.text = "H"
            cell.third.text = "E"
            cell.fourth.text = ""
            cell.total.text = "ID"
            let week_int = self.MLBScor_data?[indexPath.row].Game!.Season
            let week_string = "\(week_int!)"
            cell.week.text = "Season-" + week_string
            
            let dateString = (self.MLBScor_data?[indexPath.row].Game?.Updated!)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let date = dateFormatter.date(from: dateString)
            
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "MMMM d, yyyy"
            let outputDateString = outputDateFormatter.string(from: date!)
            
            cell.date.text = outputDateString
            
            cell.team1.text = self.MLBScor_data?[indexPath.row].Game?.AwayTeam!
            cell.team2.text = self.MLBScor_data?[indexPath.row].Game?.HomeTeam!
            
            
            let team1score1_int = self.MLBScor_data?[indexPath.row].Game?.AwayTeamRuns ?? 0
            let team1score1_string = "\(team1score1_int)"
            cell.team1score1.text = team1score1_string
            
            
            let team1score2_int = self.MLBScor_data?[indexPath.row].Game?.AwayTeamHits ?? 0
            let team1score2_string = "\(team1score2_int)"
            cell.team1score2.text = team1score2_string
            
            
            let team1score3_int = self.MLBScor_data?[indexPath.row].Game?.AwayTeamErrors ?? 0
            let team1score3_string = "\(team1score2_int)"
            cell.team1score3.text = team1score2_string
            cell.team1score4.text = ""
            
    
            let team2score1_int = self.MLBScor_data?[indexPath.row].Game?.HomeTeamRuns ?? 0
            let team2score1_string = "\(team2score1_int)"
            cell.team2score1.text = team2score1_string
            
            let team2score2_int = self.MLBScor_data?[indexPath.row].Game?.HomeTeamHits ?? 0
            let team2score2_string = "\(team2score2_int)"
            cell.team2score2.text = team2score2_string
            
            
            let team2score3_int = self.MLBScor_data?[indexPath.row].Game?.HomeTeamErrors ?? 0
            let team2score3_string = "\(team2score3_int)"
            cell.team2score3.text = team2score3_string
            
            cell.team2score4.text = ""
            
            
            let team1total_int = self.MLBScor_data?[indexPath.row].Game?.AwayTeamID ?? 0
            let team1total_string = "\(team1total_int)"
            cell.team1total.text = team1total_string
            
            let team2total_int = self.MLBScor_data?[indexPath.row].Game?.HomeTeamID ?? 0
            let team2total_string = "\(team2total_int)"
            cell.team2total.text = team2total_string
                    
            cell.status.text = self.MLBScor_data?[indexPath.row].Game?.Status!
            
            break
            
        default : break
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185
    }

}
