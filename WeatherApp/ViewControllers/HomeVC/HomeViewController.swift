//
//  ViewController.swift
//  WeatherApp
//
//  Created by Prashant Gaikwad on 03/07/21.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var homeTableView: UITableView!
    
    // MARK: - Properties
    let userDefaults = UserDefaults.standard
    var allBookmarks: [[String:NSNumber]]?
    var location: CLLocationCoordinate2D?
    var allBookMarks = [[String:NSNumber]]()
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        getBookmarks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getBookmarks()
    }
    
    // MARK: - IBActions
    @IBAction func addAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "CityViewController") as? CityViewController else { return }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    // MARK: - Actions
    func setUpTableView() {
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.tableFooterView = UIView()
        self.homeTableView.register(UINib(nibName: "BookmarkListTableViewCell", bundle: nil), forCellReuseIdentifier: "BookmarkListTableViewCell")
    }
    
    func getBookmarks() {
        if let vals = userDefaults.object(forKey: AppConstants.bookmarks) as? [[String:NSNumber]] {
            self.allBookmarks = vals
            DispatchQueue.main.async {
                self.homeTableView.reloadData()
            }
        }
        if allBookmarks?.count == 0 {
            self.setEmptyDataLabelTableView()
        } else {
            homeTableView.backgroundView = nil
        }
    }
    
    func setEmptyDataLabelTableView() {
        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: homeTableView.bounds.size.width, height: homeTableView.bounds.size.height))
        noDataLabel.text              = "Click on + to add Bookmarks"
        noDataLabel.textColor         = UIColor.black
        noDataLabel.textAlignment     = .center
        homeTableView.backgroundView  = noDataLabel
        homeTableView.separatorStyle  = .none
    }
    
}

// MARK: - TableView Methods
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allBookmarks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkListTableViewCell", for: indexPath) as? BookmarkListTableViewCell {
            cell.accessoryType = .disclosureIndicator
            if let location = allBookmarks?[indexPath.row] {
                cell.location = location
                cell.getCityName()
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "WeatherInfoViewController") as? WeatherInfoViewController else{return}
        vc.modalPresentationStyle = .fullScreen
        if let locationObject = allBookmarks?[indexPath.row] {
            let lat = Double(truncating: locationObject["lat"] ?? 0)
            let lon = Double(truncating: locationObject["long"] ?? 0)
            vc.location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            self.present(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if let locationObject = allBookmarks?[indexPath.row] {
                let lat = Double(truncating: locationObject["lat"] ?? 0)
                let lon = Double(truncating: locationObject["long"] ?? 0)
                location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            }
            let locationLat = NSNumber(value:location?.latitude ?? 0)
            let locationLon = NSNumber(value:location?.longitude ?? 0)
            let locationArray = ["lat":locationLat,"long":locationLon]
            if let vals = userDefaults.object(forKey: AppConstants.bookmarks) as? Array<Dictionary<String,NSNumber>>{
                allBookMarks = vals.filter({$0 != locationArray})
                userDefaults.set(allBookMarks, forKey:AppConstants.bookmarks)
                getBookmarks()
            }
        }
    }
}

