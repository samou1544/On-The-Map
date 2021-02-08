//
//  TabViewController.swift
//  On The Map
//
//  Created by Asma  on 1/12/21.
//

import UIKit

class TabViewController: UITabBarController {
    
    let limit=100
    let order="-updatedAt"
    let segueID="showInformationPostingVC"
    var refreshingVC:UIAlertController?

    override func viewDidLoad() {
            super.viewDidLoad()
        
        getStudentLocations()        
        
        let logoutButton=UIBarButtonItem(title:"LOGOUT" ,style: .plain, target: self, action: #selector(logout))
        let refreshButton=UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise") ,style: .plain, target: self, action: #selector(refresh))
        let addButton=UIBarButtonItem(image: UIImage(systemName: "plus") ,style: .plain, target: self, action: #selector(addPost))
        navigationItem.rightBarButtonItems = [refreshButton,addButton]
        navigationItem.leftBarButtonItem=logoutButton
        }

    @objc func logout() {
        UdacityClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
        }
    @objc func addPost() {
        performSegue(withIdentifier: segueID, sender: nil)
        }
    @objc func refresh() {
        let task=getStudentLocations()
        showRefreshIndicator(message:"Refreshing student locations", task:task)
        
        }
    func getStudentLocations()->URLSessionDataTask{
        return UdacityClient.getStudentLocations(limit:self.limit, skip:nil,order:self.order, uniqueKey: nil){ studentLocations, error in
            if let refreshVC=self.refreshingVC {
                refreshVC.dismiss(animated:true, completion:nil)
            }
            if(error != nil){
                
                
                self.showLoadingFailure(message: error?.localizedDescription ?? "")
                
            }
            StudentLocationModel.studentLocations = studentLocations
          //Notifying MapViewController and ListViewController that data has refreshed
                NotificationCenter.default.post(name: .didRefreshData, object: nil)
            
        }
    }
    func showRefreshIndicator(message: String, task:URLSessionDataTask) {
        refreshingVC = UIAlertController(title: "Refreshing ... ", message: message, preferredStyle: .alert)
        refreshingVC!.addAction(UIAlertAction(title: "Cancel", style: .cancel){ (action:UIAlertAction!) in
            task.cancel()
        })
        present(refreshingVC!, animated:true, completion:{
            //create an activity indicator
            let indicator = UIActivityIndicatorView(frame: self.refreshingVC!.view.bounds)
                    indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]

                    //add the activity indicator as a subview of the alert controller's view
            self.refreshingVC!.view.addSubview(indicator)
                    indicator.isUserInteractionEnabled = false 
                    indicator.startAnimating()
            self.refreshingVC!.view.addSubview(indicator)
        })
        
    }
    func showLoadingFailure(message: String) {
        let alertVC = UIAlertController(title: "Couldn't load student information ", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated:true, completion:nil)
        
    }
}
