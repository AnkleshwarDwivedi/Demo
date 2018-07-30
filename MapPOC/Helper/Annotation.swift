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
