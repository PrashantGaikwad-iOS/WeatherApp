//
//  WeatherInfoViewController.swift
//  WeatherApp
//
//  Created by Prashant Gaikwad on 03/07/21.
//

import UIKit
import CoreLocation

enum CurrentWeatherModeSelection: Int, CaseIterable {
    case Today
    case Weekly
}

class WeatherInfoViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherInfoLabel: UILabel!
    @IBOutlet weak var weatherIconImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var bookmarkButtton: UIButton!
    
    // MARK: - Properties
    var isBookmarked = false
    let userDefaults = UserDefaults.standard
    var allBookMarks = [[String:NSNumber]]()
    enum Sections: Int, CaseIterable{
        case Header
        case WeeklyHourly
    }
    var weatherService: WeatherService?
    var location: CLLocationCoordinate2D?
    var currentWeatherMode = CurrentWeatherModeSelection.Today
    var weatherData: WeatherDataModel? {
        didSet{
            guard let data = weatherData else{return}
            setWeatherData(weatherData: data)
        }
    }
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherService = WeatherService(delegate: self)
        if let _location = location {
            weatherService?.getWeatherData(lat: _location.latitude, long: _location.longitude)
            Utils.shared.getAddressFromLatLon(coordinate: _location) { (city) in
                self.cityLabel.text = city
            }
        }
        getBookmarks()
        self.setUpTableView()
    }
    
    // MARK: - IBActions
    @IBAction func bookMarkButtonAction(_ sender: Any) {
        if isBookmarked{
            removeBookmark()
        }
        else{
            setBookmark()
        }
    }
    
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions
    func getBookmarks(){
        if let vals = userDefaults.object(forKey: AppConstants.bookmarks) as? [[String:NSNumber]]{
            self.allBookMarks = vals
            self.checkBookmark()
        }
    }
    
    func setBookmark() {
        let locationLat = NSNumber(value:location?.latitude ?? 0)
        let locationLon = NSNumber(value:location?.longitude ?? 0)
        let locationArray = [["lat":locationLat,"long":locationLon]]
        allBookMarks.append(contentsOf: locationArray)
        userDefaults.set(allBookMarks, forKey:AppConstants.bookmarks)
        isBookmarked = true
        getBookmarks()
    }
    
    func checkBookmark(){
        let locationLat = NSNumber(value:location?.latitude ?? 0)
        let locationLon = NSNumber(value:location?.longitude ?? 0)
        let locationArray = ["lat":locationLat,"long":locationLon]
        if allBookMarks.contains(locationArray) {
            isBookmarked = true
            self.bookmarkButtton.setImage(UIImage(systemName: "bookmark.circle.fill"), for: .normal)
        }else{
            isBookmarked = false
            self.bookmarkButtton.setImage(UIImage(systemName: "bookmark.circle"), for: .normal)
        }
        
    }
    
    func removeBookmark(){
        let locationLat = NSNumber(value:location?.latitude ?? 0)
        let locationLon = NSNumber(value:location?.longitude ?? 0)
        let locationArray = ["lat":locationLat,"long":locationLon]
        if let vals = userDefaults.object(forKey: AppConstants.bookmarks) as? Array<Dictionary<String,NSNumber>>{
            allBookMarks = vals.filter({$0 != locationArray})
            userDefaults.set(allBookMarks, forKey:AppConstants.bookmarks)
            isBookmarked = false
            getBookmarks()
        }
    }
    
    func setUpTableView(){
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        self.weatherTableView.register(UINib(nibName: "WeatherDataTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherDataTableViewCell")
        self.weatherTableView.register(UINib(nibName: "SegmentationHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "SegmentationHeaderTableViewCell")
    }
    
    func setWeatherData(weatherData: WeatherDataModel) {
        DispatchQueue.main.async {
            self.dateLabel.text = Date.getTodaysDate()
            guard let weather = weatherData.current?.weather?.first else{return}
            self.weatherInfoLabel.text = weather.main ?? ""
            self.weatherIconImage.image = UIImage(named: weather.icon ?? "")
            self.temperatureLabel.text = "\(weatherData.current?.temp?.celcius.rounded() ?? 0) °C"
            self.humidityLabel.text = "Humidity: \(weatherData.current?.humidity ?? 0) %"
            self.windSpeedLabel.text = "Wind: \(weatherData.current?.wind_speed  ?? 0) miles/sec"
            self.weatherTableView.reloadData()
        }
    }
}

// MARK: - TableView Methods
extension WeatherInfoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellToReturn : UITableViewCell?
        
        switch Sections(rawValue: indexPath.section) {
        case.Header:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SegmentationHeaderTableViewCell", for: indexPath) as? SegmentationHeaderTableViewCell {
                cell.changeWeatherMode = { [weak self] mode in
                    self?.currentWeatherMode = mode
                    DispatchQueue.main.async {
                        self?.weatherTableView.reloadData()
                    }
                }
                cellToReturn = cell
            }
        case.WeeklyHourly:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherDataTableViewCell", for: indexPath) as? WeatherDataTableViewCell {
                cell.hourly = weatherData?.hourly
                cell.daily = weatherData?.daily
                cell.sortWeeklyArray()
                cell.currentWeatheMode = self.currentWeatherMode
                cellToReturn = cell
            }
        default:
            cellToReturn = UITableViewCell()
        }
        
        return cellToReturn ?? UITableViewCell()
    }
}

extension WeatherInfoViewController: WeatherServiceDelegate {
    func getCurrentWeather(data: TodaysForecastModel?) {
    }
    
    func getDailyWeather(data: WeekForecastModel?) {
    }
    
    func getOneCallWeatherData(data: WeatherDataModel?) {
        self.weatherData = data
    }
}
