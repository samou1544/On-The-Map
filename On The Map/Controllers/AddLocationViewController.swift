//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Asma  on 1/14/21.
//

import UIKit
import MapKit

class AddLocationViewController: BaseViewController, MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    var lat:CLLocationDegrees!
    var long:CLLocationDegrees!
    var address:String!
    var link:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = address
        let annotations=[annotation]
        self.mapView.addAnnotation(annotation)
        self.mapView.showAnnotations(annotations, animated:true)
        
        
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

    @IBAction func postData(_ sender: Any) {
        //get current user data
        UdacityClient.getUserData(userId:UdacityClient.userId, completion: handleUserDataResponse(userData:error:))
    }
    
    func handleUserDataResponse(userData: UserDataResponse?, error: Error?) {
        if let userData=userData {
            let newLocation=PostStudentLocationRequest(uniqueKey: UdacityClient.userId, firstName: userData.firstName, lastName: userData.lastName, mapString: address, mediaURL: link, latitude: lat, longitude: long)
            UdacityClient.postStudentLocation(post: newLocation, completion: handlePostLocationResponse(success:error:))
        } else {
            showAlert(kind:.show,title:"Failed to post new location ",message:error!.localizedDescription,action:"OK")
        }
    }
    
    func handlePostLocationResponse(success:Bool, error: Error?) {
        if success{
            dismiss(animated: false, completion: {
                self.presentingViewController?.dismiss(animated: false)
               })
        } else {
            showAlert(kind:.show,title:"Failed to post new location ",message:error!.localizedDescription,action:"OK")
        }
    }
}
