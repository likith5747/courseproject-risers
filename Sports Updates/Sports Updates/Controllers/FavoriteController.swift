//
//  FavoriteController.swift
//  Sports Updates
//
//  Created by Sowmya on 4/11/23.
//

import UIKit
import Alamofire
import MBProgressHUD

class FavoriteController: UIViewController {
    
    let defaults = UserDefaults.standard
    private var NFLfavorite_data : [FavoriteStruct]?
    var selectedItems = [String]()
    @IBOutlet weak var favoritetableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritetableview.allowsMultipleSelection = true
        self.FavoriteAPI()
        self.favoritetableview.reloadData()
        
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.set(selectedItems, forKey: "selectedItems")
    }
    
    private func FavoriteAPI()
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
                    print("Objects: \(objects)")
                    self.NFLfavorite_data = objects
                    self.favoritetableview.reloadData()
                    progressHUD.hide(animated: true)
                    
                }
            case .failure(let error):
                // Handle error response
                print("error api",error.localizedDescription)
                
            }
        }
    }
}
extension FavoriteController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.NFLfavorite_data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteViewCell", for: indexPath) as! FavoriteViewCell
        
        cell.city.text = self.NFLfavorite_data?[indexPath.row].City!
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 109
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = (NFLfavorite_data?[indexPath.row].Key!)!
        var multipleselection = UserDefaults.standard.array(forKey: "FavoriteSports") as? [String] ?? []
        multipleselection.append(selectedItem)
        
        defaults.set(multipleselection, forKey: "FavoriteSports")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedItem = (NFLfavorite_data?[indexPath.row].City!)!
        if let index = selectedItems.firstIndex(of: selectedItem) {
            selectedItems.remove(at: index)
        }
    }
}
