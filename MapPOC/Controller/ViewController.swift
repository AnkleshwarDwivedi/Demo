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
import CoreData

class ViewController: UIViewController{
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lblSunSet: UILabel!
    var currentSelectedDate = Date()
    @IBOutlet weak var lblSunRise: UILabel!
    var helper = Helper()
     var coordinate2D = CLLocationCoordinate2DMake(28.7041,77.1025)
  
    @IBOutlet weak var lblDate: UILabel!
    
    
   
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
        self.lblDate.text = Date().iso8601
        self.currentSelectedDate = Date().today
        
    }
    
    func printTimestamp(date: Date) {
    
        
      
        
        let sunSet = EDSunriseSet(date:date, timezone: TimeZone.current, latitude: coordinate2D.latitude, longitude: coordinate2D.longitude)


        
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
    
 
    
    @IBAction func clickToSaveLocation(_ sender: Any) {
        self.save(lat: coordinate2D.latitude, lng: coordinate2D.longitude)
    }
    
    func save(lat: Double,lng:Double) {
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appdelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)
        let user = NSManagedObject(entity: entity!, insertInto: managedContext)
        
     
        user.setValue(lat, forKey: "lat")
        user.setValue(lng, forKey: "lng")
        do {
            try managedContext.save()
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")            }
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

    @IBAction func clickToCurrentLocation(_ sender: Any) {
        
        self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: true)
    }
    
    func findAddress(address:String){
        
       self.helper.getCoordinate(address: address) { (coordinate, location, error) in
            if (error != nil){
                ECSAlert().showAlert(message: "Please search a valid address", controller: self)
                
            }else{
                if let coordinate = coordinate{
                    self.coordinate2D = coordinate
                    self.mapView.camera.centerCoordinate = coordinate
                    self.mapView.camera.altitude = 1000.0
                    let pin = Annotation(coordinate: coordinate, title: address, subtitle: location)
                    self.mapView.addAnnotation(pin)
                    self.printTimestamp(date: self.currentSelectedDate)

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
    
    
    @IBAction func clickTonextDate(_ sender: Any) {
        self.currentSelectedDate = self.currentSelectedDate.tomorrow
        self.printTimestamp(date: self.currentSelectedDate)
        self.lblDate.text = self.currentSelectedDate.iso8601
        
    }
    
    @IBAction func clickToPreviousDate(_ sender: Any) {
        self.currentSelectedDate = self.currentSelectedDate.yesterday
        self.printTimestamp(date: self.currentSelectedDate)
        self.lblDate.text = self.currentSelectedDate.iso8601
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

