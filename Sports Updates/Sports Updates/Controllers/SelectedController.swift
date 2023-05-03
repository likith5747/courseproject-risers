//
//  SelectedController.swift
//  Sports Updates
//
//  Created by Sowmya  on 4/17/23.
//

import UIKit

class SelectedController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    let defaults = UserDefaults.standard
    
    var selectedItems1 = [String]()
    
    @IBOutlet weak var selectedtableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedtableview.dataSource = self
        selectedtableview.delegate = self
        
        selectedItems1 =  defaults.array(forKey: "FavoriteSports") as? [String] ?? []
        print("selectedItems",selectedItems1)
        print("selectedItems count",selectedItems1.count)
        selectedtableview.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("counts",selectedItems1.count)
        return selectedItems1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedViewCell", for: indexPath) as! SelectedViewCell
        cell.Favoriteteam.text = self.selectedItems1[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DetailedteamController = self.storyboard?.instantiateViewController(withIdentifier: "DetailedteamController") as! DetailedteamController
        DetailedteamController.teamname = self.selectedItems1[indexPath.row]
        self.navigationController?.pushViewController(DetailedteamController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
