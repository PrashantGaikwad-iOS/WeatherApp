//
//  Utils.swift
//  WeatherApp
//
//  Created by Prashant Gaikwad on 03/07/21.
//

import Foundation
import CoreLocation

class Utils {
    static let shared = Utils()
    private init() {}
    
    func getAddressFromLatLon(coordinate: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = coordinate.latitude
        center.longitude = coordinate.longitude
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
                                        if (error != nil)
                                        {
                                            print("reverse geodcode fail: \(error!.localizedDescription)")
                                        }
                                        
                                        if let pm = placemarks {
                                            if pm.count > 0 {
                                                let pm = placemarks![0]
                                                completion(pm.subLocality ?? pm.locality ?? pm.country ?? "Unknown")
                                            }
                                        }
                                    })
    }
    
}

extension Date {
    static func getTodaysDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: date)
    }
    
    static func getHourFrom(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        let string = dateFormatter.string(from: date)
        return string
    }
    
    static func getDayOfWeekFrom(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .long
        var string = dateFormatter.string(from: date)
        if let index = string.firstIndex(of: ",") {
            string = String(string.prefix(upTo: index))
            return string
        }
        return "error"
    }
}


extension Double{
    var celcius: Double{
        return self - 273.15
    }
    
    var farenheit: Double{
        return  ((self - 273.15) * 1.8) + 32
    }
}
