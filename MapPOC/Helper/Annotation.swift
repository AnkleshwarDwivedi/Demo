//
//  PizzaAnnotation.swift
//  PizzaHistoryMap
//
//  Created by Steven Lipton on 7/18/17.
//  Copyright © 2017 Steven Lipton. All rights reserved.
//

import UIKit
import MapKit

class Annotation: NSObject,MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var identifier = "Pin"
    var historyText = ""
    var pinPhoto:UIImage! = nil
    //var pinPhoto = UIImage(named: "mapPin.png")
    var deliveryRadius:CLLocationDistance! = nil
    init(coordinate:CLLocationCoordinate2D,title:String?,subtitle:String?){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}

class ECSAlert: NSObject {
    
    
    
    
    
    func showAlert(message:String , controller:UIViewController) {
        let alertVC = UIAlertController(title: "", message: message, preferredStyle:UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style:UIAlertActionStyle.default, handler: nil)
        alertVC.addAction(okAction)
        controller.present(alertVC, animated: true, completion: nil)
    }
    
}


public extension Date {
    public  func ISOStringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT") as TimeZone!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.string(from:date)
    }
    
    public static func dateFromISOString(string: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: string)!
    }
    
    static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = " EEEE , dd MMM , yyyy"
        return formatter
    }()
    
    
    var iso8601: String {
        
        
        return Date.iso8601Formatter.string(from: self)
    }
    
    
    var dayAfter : String
    {
        let date = Date()
        return ISOStringFromDate(date: date)
    }
    
    var today: Date {
        return Calendar.current.date(byAdding: .day, value: 0, to: noon)!
    }
    
    
    
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var dayAfterTomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 2, to: noon)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
    
    
}

class Helper{

public func placemark(annotation:Annotation, completionHandler: @escaping (CLPlacemark?) -> Void){
    let coordinate = annotation.coordinate
    let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
        if let placemarks = placemarks{
            completionHandler(placemarks.first)
        } else {
            completionHandler(nil)
        }
    }
}

public func getCoordinate( address:String, completionHandler: @escaping(CLLocationCoordinate2D?,String, NSError?)->Void){
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(address) { (placemarks, error) in
        if error == nil {
            if let placemark = placemarks?[0]{
                let coordinate = placemark.location?.coordinate
                if let localtiy = (placemark.locality){
                    let location = localtiy + " " + placemark.isoCountryCode!
                    completionHandler(coordinate, location, nil)
                }
                else{
                    let location = placemark.locality ?? ""
                    completionHandler(coordinate, location, nil)
                }
                
                
                return
            }
        }
        completionHandler(nil, "", error as NSError?)
    }
}
    
    
   
}
