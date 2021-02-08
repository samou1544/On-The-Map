//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Asma  on 1/14/21.
//

import UIKit
import CoreLocation

class InformationPostingViewController: BaseViewController {

    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBOutlet weak var findLocatioButton: UIButton!
    @IBOutlet weak var indicatiorView: UIActivityIndicatorView!
    var address:String?
    var location:CLLocation?
    var mediaUrl:String?
    
    let segueID="showLocationOnMap"
    override func viewDidLoad() {
        super.viewDidLoad()
        let cancelButton=UIBarButtonItem(title:"Cancel" ,style: .plain, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem=cancelButton
    }
    
    @objc func cancel(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        self.address = locationTextField.text!
        self.mediaUrl=urlTextField.text!
        let geoCoder = CLGeocoder()
        isDecodingAddress(isDecoding:true)
        geoCoder.geocodeAddressString(address!) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            
            else {
                self.isDecodingAddress(isDecoding:false)
                self.showAlert(kind:.present,title:"Couldn't decode provided address ", message: error?.localizedDescription ?? "",action:"OK")
                return
            }
            self.isDecodingAddress(isDecoding:false)
            self.location=location
            self.performSegue(withIdentifier: self.segueID, sender: nil)
                
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueID {
            let addLocationVC = segue.destination as! AddLocationViewController
            addLocationVC.address=self.address
            addLocationVC.lat=self.location?.coordinate.latitude
            addLocationVC.long=self.location?.coordinate.longitude
            addLocationVC.link=self.mediaUrl!
        }
    }
   
    func isDecodingAddress(isDecoding:Bool){
        if(isDecoding){
            indicatiorView.startAnimating()
        }else{
            indicatiorView.stopAnimating()
        }
        locationTextField.isEnabled = !isDecoding
        urlTextField.isEnabled = !isDecoding
        findLocatioButton.isEnabled = !isDecoding
    }

}
