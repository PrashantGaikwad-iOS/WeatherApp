//
//  ViewController.swift
//  WeatherApp
//
//  Created by Prashant Gaikwad on 03/07/21.
//

import UIKit
import CoreLocation
class BookmarkListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    var location = [String:NSNumber]()
    var coordinate:CLLocationCoordinate2D?
    var city:String?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getCityName(){
            let lat = Double(truncating: location["lat"] ?? 0)
            let lon = Double(truncating: location["long"] ?? 0)
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            if let locationData = coordinate{
                Utils.shared.getAddressFromLatLon(coordinate: locationData) { [weak self] (value) in
                    self?.city = value
                    self?.titleLabel.text = self?.city
                }
            }
            
            
        }
    
    
}
