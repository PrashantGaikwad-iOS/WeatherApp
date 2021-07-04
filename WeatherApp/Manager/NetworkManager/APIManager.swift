//
//  APIManager.swift
//  WeatherApp
//
//  Created by Prashant Gaikwad on 03/07/21.
//

import Foundation

public let ErrorDomain = "com.appx.error"
public let ErrorCodeAppNotActive = 666
public let ErrorCodeTimeout = 1001
public let ErrorCodeVersionTooOld = 1004
public let ErrorInvalidFunction = 1005
public let ErrorInvalidResponse = 1006

class APIManager {
    
    private let baseUrl = "http://api.openweathermap.org/"
    private let decoder: JSONDecoder
    public init(_ decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    public enum HttpMethod : String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    private enum RestfulApiSubpath {
        case todaysForecastInformation
        case weekForecast
        case weatherData
        
        var getUrlSubpath : String {
            get {
                switch self {
                case .todaysForecastInformation: return "data/2.5/weather?"
                case .weekForecast: return "data/2.5/forecast?"
                case .weatherData: return "data/2.5/onecall?"
                }
            }
        }
    }
    
    func getTodaysWeather(latitude:Double,longitude:Double,completion: @escaping (TodaysForecastModel?)->Void ) {
        self.sendCloudReq(TodaysForecastModel.self, subpath: .todaysForecastInformation, subUrl: "lat=\(latitude)&lon=\(longitude)&appid=\(AppConstants.appId)", method: .get, bodyArgs: nil, completion: { (response) in
            if let result = response {
                completion(result)
            }
        }) { (error) in
            print(error?.localizedDescription ?? "NA")
        }
    }
    
    func getWeekWeather(latitude: Double, longitude: Double, completion: @escaping (WeekForecastModel?) -> Void ) {
        self.sendCloudReq(WeekForecastModel.self, subpath: .weekForecast, subUrl: "lat=\(latitude)&lon=\(longitude)&appid=\(AppConstants.appId)", method: .get, bodyArgs: nil, completion: { (response) in
            if let result = response {
                completion(result)
            }
        }) { (error) in
            print(error?.localizedDescription ?? "NA")
        }
    }
    
    func getWeatherData(latitude: Double, longitude: Double, completion: @escaping (WeatherDataModel?) -> Void ) {
        self.sendCloudReq(WeatherDataModel
                            .self, subpath: .weatherData, subUrl: "lat=\(latitude)&lon=\(longitude)&appid=\(AppConstants.appId)", method: .get, bodyArgs: nil, completion: { (response) in
                                if let result = response {
                                    completion(result)
                                }
                            }) { (error) in
            print(error?.localizedDescription ?? "NA")
        }
    }
    
    
    private func sendCloudReq<T: Decodable>(_ objectType: T.Type, subpath: RestfulApiSubpath, subUrl: String,  method: HttpMethod, bodyArgs: [String: Any]?, completion: @escaping(T?) -> Void, error: @escaping(Error?) -> Void) {
        guard let url = URL(string: self.baseUrl) else{return}
        guard let urlString = "\(url.absoluteString)\(subpath.getUrlSubpath)\(subUrl)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let urlBuilder = URLComponents(url: URL(string: urlString.removingPercentEncoding ?? "") ?? url, resolvingAgainstBaseURL: true) else { assert(false, "invalid base url"); return }
        var req = URLRequest(url: urlBuilder.url ?? url)
        req.httpMethod = method.rawValue
        
        if let bodyArgs = bodyArgs {
            guard let jsonData = try? JSONSerialization.data(withJSONObject: bodyArgs) else { assert(false, "invalid json request"); return }
            req.httpBody = jsonData
        }
        
        let userAgent: String
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            userAgent = "iOS \(version) (\(build))"
        }
        else {
            userAgent = "iOS"
        }
        req.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: req) { (data, res, err) in
            if err == nil, let _ = res as? HTTPURLResponse {
                if let data = data {
                    do {
                        let response = try self.decoder.decode(T.self, from: data)
                        completion(response)
                    }
                    catch let error {
                        print("error: \(error.localizedDescription) *** \(error)")
                    }
                }
            }
            else if let err = err {
                error(err)
            }
            else {
                let err = NSError(domain: ErrorDomain, code: ErrorInvalidFunction, userInfo: nil)
                error(err)
            }
        }.resume()
    }
}
