//
//  MapViewController.swift
//  On The Map
//
//  Created by Asma  on 1/14/21.
//

import UIKit
import MapKit

class MapViewController: BaseViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var annotations = [MKPointAnnotation]()
        
        for studentLocation in StudentLocationModel.studentLocations {
            
            let lat = CLLocationDegrees(studentLocation.latitude)
            let long = CLLocationDegrees(studentLocation.longitude)
           
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = studentLocation.firstName
            let last = studentLocation.lastName
            let mediaURL = studentLocation.mediaURL
          
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
           annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeToRefreshNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            unsubscribeFromRefreshdNotifications()
    }
    
    func subscribeToRefreshNotifications() {
        //subscription to Refresh button tap
        NotificationCenter.default.addObserver(self, selector: #selector(onRefreshButtonTap(_:)), name: .didRefreshData, object: nil)
      
    }

    func unsubscribeFromRefreshdNotifications() {

        NotificationCenter.default.removeObserver(self, name: .didRefreshData, object: nil)
    }
    
    @objc func onRefreshButtonTap(_ notification:Notification) {
        viewDidLoad()
    }

}
