//
//  WeatherInfoViewController.swift
//  WeatherApp
//
//  Created by Prashant Gaikwad on 03/07/21.
//

import UIKit

class SegmentationHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var sementControl: UISegmentedControl!
    var changeWeatherMode:((_ mode:CurrentWeatherModeSelection)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func segmentControlAction(_ sender: Any) {
        self.changeWeatherMode?(CurrentWeatherModeSelection(rawValue: self.sementControl.selectedSegmentIndex) ?? .Today)
    }
    
}
