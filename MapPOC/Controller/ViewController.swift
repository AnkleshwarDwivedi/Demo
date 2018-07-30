//
//  ViewController.swift
//  MapPOC
//
//  Created by Ankleshwar on 29/07/18.
//  Copyright © 2018 Ankleshwar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController{
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lblSunSet: UILabel!
    
    @IBOutlet weak var lblSunRise: UILabel!
    
    
    
    
    var coordinate2D = CLLocationCoordinate2DMake(28.7041,77.1025)
    var camera = MKMapCamera()
    
    
    var pitch = 0
    var isOn = false
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        _locationManager.activityType = .automotiveNavigation
        _locationManager.distanceFilter = 10.0
        _locationManager.allowsBackgroundLocationUpdates = true
        
        return _locationManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewBottom.layer.borderWidth = 1.0
        self.viewBottom.layer.borderColor = UIColor.black.cgColor
        mapView.delegate = self
        searchBar.delegate = self
        searchBar.showsScopeBar = true
        setupCoreLocation()
        addOverlay()
        updateMapRegion(rangeSpan: 500)
       
      
    }
    
    func printTimestamp(location:CLLocation) {
    
        
      
        
        let sunSet = EDSunriseSet(date:Date().today, timezone: TimeZone.current, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        print(sunSet?.sunrise)
//        print(sunSet?.sunset)

        
        if sunSet?.sunset != nil{
            self.lblSunSet.text = self.setTime(date: (sunSet?.sunset)!) + " " + "PM"
        }
        if sunSet?.sunset != nil{
             self.lblSunRise.text = self.setTime(date: (sunSet?.sunrise)!) + " " + "AM"
        }
        
        
        
       
        
    }

    func setTime(date:Date) -> String{
        let calendar = Calendar.current
        let time=calendar.dateComponents([.hour,.minute,.second], from: date)
       return "\(time.hour!):\(time.minute!)"
    }
    
 
    
    
    

    //MARK: location
    
    func setupCoreLocation(){
        switch CLLocationManager.authorizationStatus(){
        case .notDetermined ,.denied:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedAlways:
            enableLocationServices()
        case .authorizedWhenInUse:
            enableLocationServices()
            
        default:
            break
        }
    }
    
    func enableLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
            mapView.setUserTrackingMode(.follow, animated: true)
        }
        
    }
    
    func addOverlay(){
        //let radius = 1600.0 //meters
        for location in mapView.annotations{
            if let radius = (location as! Annotation).deliveryRadius{
                let circle = MKCircle(center: location.coordinate, radius: radius)
                mapView.add(circle)
            }
            
        }
    }

    
    func findAddress(address:String){
        
        getCoordinate(address: address) { (coordinate, location, error) in
            if (error != nil){
                ECSAlert().showAlert(message: "Please search a valid address", controller: self)
                
            }else{
                if let coordinate = coordinate{
                    self.mapView.camera.centerCoordinate = coordinate
                    self.mapView.camera.altitude = 1000.0
                    let pin = Annotation(coordinate: coordinate, title: address, subtitle: location)
                    self.mapView.addAnnotation(pin)
                  

                }
            }
            
            
        }
    }
    
    
    func updateMapRegion(rangeSpan:CLLocationDistance){
        let region = MKCoordinateRegionMakeWithDistance(coordinate2D, rangeSpan, rangeSpan)
        mapView.region = region
    }
    func updateMapCamera(heading:CLLocationDirection, altitude:CLLocationDistance){
        camera.centerCoordinate = coordinate2D
        camera.heading = heading
        camera.altitude = altitude
        camera.pitch = 0.0
        mapView.camera = camera
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

func placemark(annotation:Annotation, completionHandler: @escaping (CLPlacemark?) -> Void){
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

func getCoordinate( address:String, completionHandler: @escaping(CLLocationCoordinate2D?,String, NSError?)->Void){
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

extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text!.count == 0 {
            
        }
        else{
           self.findAddress(address: searchBar.text!)
        }
        
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("survey?search=\(searchText)")
        
       
        
        
    }
}
