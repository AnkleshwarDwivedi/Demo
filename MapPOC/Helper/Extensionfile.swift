//
//  Delegatefile.swift
//  MapPOC
//
//  Created by Ankleshwar on 29/07/18.
//  Copyright © 2018 Ankleshwar. All rights reserved.
//

import Foundation
import MapKit


extension ViewController:MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = MKAnnotationView()
        guard let annotation = annotation as? Annotation
            else{
                return nil
        }
        if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.identifier) {
            annotationView = dequedView
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
        }
        //annotationView.pinTintColor = UIColor.blue
        
        annotationView.image = UIImage(named: "mapPin")
        annotationView.canShowCallout = true
        let paragraph = UILabel()
        paragraph.numberOfLines = 0
        paragraph.font = UIFont.preferredFont(forTextStyle: .caption1)
        paragraph.text = annotation.subtitle
        paragraph.numberOfLines = 1
        paragraph.adjustsFontSizeToFitWidth = true
        annotationView.detailCalloutAccessoryView = paragraph
        if annotation.pinPhoto == nil{ //default image
            annotation.pinPhoto = UIImage(named: "mapPin.png")
        }
        annotationView.leftCalloutAccessoryView = UIImageView(image: annotation.pinPhoto)
        annotationView.rightCalloutAccessoryView = UIButton(type: .infoLight)
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
    }
    //MARK: Overlay delegates
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline{
            let polylineRenderer = MKPolylineRenderer(polyline: polyline)
            if polyline.title == "GrandTour_Line"{
                polylineRenderer.strokeColor = UIColor.red
                polylineRenderer.lineWidth = 5.0
                return polylineRenderer
            }
            polylineRenderer.strokeColor = UIColor.green
            polylineRenderer.lineWidth = 3.0
            polylineRenderer.lineDashPattern = [20,10,2,10]
            return polylineRenderer
        }
        
        if let circle = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: circle)
            circleRenderer.fillColor = UIColor(red: 0.0, green: 0.1, blue: 1.0, alpha: 0.1)
            circleRenderer.strokeColor = UIColor.blue
            circleRenderer.lineWidth = 1.0
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}



extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
          //  ECSAlert().showAlert(message: "authorized", controller: self)
           manager.startUpdatingLocation()
            //updateMapRegion(rangeSpan: 500)
            
        case .authorizedWhenInUse:
            // If authorized when in use
            manager.startUpdatingLocation()
           // updateMapRegion(rangeSpan: 500)
            break
        case .denied, .restricted:
            
            ECSAlert().showAlert(message: "Please Enable Location", controller: self)
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        self.coordinate2D = location.coordinate
        let displayString = "Coord:\(coordinate2D) Alt: \(location.altitude) meters"
        
        updateMapRegion(rangeSpan: 200)
        
         let pin = Annotation(coordinate: coordinate2D, title: displayString, subtitle: "")
      
        mapView.addAnnotation(pin)
       
        
        printTimestamp(date: Date().today)
 
    }
}





