//
//  SettingsViewController.swift
//  WeatherApp
//
//  Created by Prashant Gaikwad on 04/07/21.
//

import UIKit
import SafariServices

class SettingsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var settingsTableView: UITableView!
    
    // MARK: - Properties
    var listOfItems = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Settings"
        setUpTableView()
        listOfItems = ["Help", "Reset bookmarks", "Check other repositories"]
    }
    
    func setUpTableView() {
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.tableFooterView = UIView()
    }
    
    fileprivate func clearBookmarks() {
        let alertVC = UIAlertController(title: "Weather App", message: "Delete all bookmarks?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: {
            (alert) -> Void in
            let allBookMarks = [[String:NSNumber]]()
            UserDefaults.standard.set(allBookMarks, forKey:AppConstants.bookmarks)
        })
        alertVC.addAction(yesAction)
        let noAction = UIAlertAction(title: "No", style: .default, handler: {
            (alert) -> Void in
        })
        alertVC.addAction(noAction)
        
        present(alertVC, animated: true)
    }
    
    fileprivate func openSafariController() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let url = URL(string: "https://github.com/PrashantGaikwad-iOS?tab=repositories")!
            let controller = SFSafariViewController(url: url)
            self.present(controller, animated: true, completion: nil)
            controller.delegate = self
        }
    }
    
    fileprivate func showHelpPage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "HelpViewController") as? HelpViewController else { return }
        vc.modalPresentationStyle = .formSheet
        self.present(vc, animated: true)
    }
}

// MARK: - TableView Methods
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate, SFSafariViewControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = listOfItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            showHelpPage()
        case 1:
            clearBookmarks()
        case 2:
            openSafariController()
        default:
            fatalError()
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}

