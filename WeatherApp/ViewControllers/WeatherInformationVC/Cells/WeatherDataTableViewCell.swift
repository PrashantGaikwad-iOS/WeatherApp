//
//  WeatherInfoViewController.swift
//  WeatherApp
//
//  Created by Prashant Gaikwad on 03/07/21.
//

import UIKit

class WeatherDataTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var currentWeatheMode:CurrentWeatherModeSelection?
    var hourly: [Hourly]?
    var daily: [Daily]?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupCollectionView()
    }

    func sortHourlyArray(daily:[Daily]?){
        guard self.hourly != nil else{return}
        let sortedArray = hourly?.sorted(by: { (hour1, hour2) -> Bool in
            return (hour1.dt ?? 0) < (hour2.dt ?? 0)
        })
        self.hourly = sortedArray
        self.reloadData()
        
    }
    func sortWeeklyArray(){
        guard self.daily != nil else{return}
        let sortedArry = daily?.sorted(by: { (day1, day2) -> Bool in
            return (day1.dt ?? 0) < (day2.dt ?? 0)
        })
        self.daily = sortedArry
        self.reloadData()
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "WeeklyHourlyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WeeklyHourlyCollectionViewCell")
        
    }
    
    func reloadData()
    {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0),
                                              at: .left,
                                        animated: true)
        }
    }
    
    
}

extension WeatherDataTableViewCell:UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch currentWeatheMode{
        case .Today:
        return hourly?.count ?? 0
        case .Weekly:
            return daily?.count ?? 0
        case .none:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeeklyHourlyCollectionViewCell", for: indexPath) as? WeeklyHourlyCollectionViewCell{
            
            switch currentWeatheMode {
            case .Today:
                let date = Date(timeIntervalSince1970: Double(hourly?[indexPath.row].dt ?? 0))
                cell.topLabel.text = Date.getHourFrom(date: date)
                cell.imageIcon.image  = UIImage(named: "\(hourly?[indexPath.row].weather?.first?.icon ?? "")")
                cell.bottomLabel.text = "\(hourly?[indexPath.row].temp?.celcius.rounded() ?? 0) °C"
                break
            case .Weekly:
                let date = Date(timeIntervalSince1970: Double(daily?[indexPath.row].dt ?? 0))
                cell.topLabel.text = Date.getDayOfWeekFrom(date: date)
                cell.imageIcon.image  = UIImage(named: "\(daily?[indexPath.row].weather?.first?.icon ?? "")")
                cell.bottomLabel.text = "\(daily?[indexPath.row].temp?.day?.celcius.rounded() ?? 0) °C"
                break
            default:
                break
            }
            return cell
            
        }
        return UICollectionViewCell()
    }
    
    
}
