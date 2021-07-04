//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Prashant Gaikwad on 03/07/21.
//

import Foundation

protocol WeatherServiceDelegate: AnyObject {
    func getCurrentWeather(data: TodaysForecastModel?)
    func getDailyWeather(data: WeekForecastModel?)
    func getOneCallWeatherData(data: WeatherDataModel?)
}

class WeatherService {
    weak private var weatherServiceDelegate: WeatherServiceDelegate?
    
    init(delegate: WeatherServiceDelegate) {
        self.weatherServiceDelegate = delegate
    }
    
    var todaysForecastModel: TodaysForecastModel? {
        didSet{
            guard let _ = todaysForecastModel else{return}
            weatherServiceDelegate?.getCurrentWeather(data: todaysForecastModel)
        }
    }
    
    var weekForecastModel: WeekForecastModel? {
        didSet{
            guard let _ = weekForecastModel else{return}
            weatherServiceDelegate?.getDailyWeather(data: weekForecastModel)
        }
    }
    
    var weatherData: WeatherDataModel? {
        didSet{
            guard let _ = weatherData else{return}
            weatherServiceDelegate?.getOneCallWeatherData(data: weatherData)
            
        }
    }
    
    func getCurrentWeatherData(lat: Double?,long: Double?){
        AppDelegate.instance.apimanager.getTodaysWeather(latitude: lat ?? 0.0, longitude: long ?? 0.0) { (data) in
            self.todaysForecastModel = data
        }
    }
    
    func getDailyWeatherInfo(lat: Double?,long: Double?){
        AppDelegate.instance.apimanager.getWeekWeather(latitude: lat ?? 0.0, longitude: long ?? 0.0) { (data) in
            self.weekForecastModel = data
        }
    }
    
    func getWeatherData(lat: Double?,long: Double?){
        AppDelegate.instance.apimanager.getWeatherData(latitude: lat ?? 0.0, longitude: long ?? 0.0) { (data) in
            self.weatherData = data
        }
    }
}
