//
//  BaseViewController.swift
//  On The Map
//
//  Created by Asma  on 1/15/21.
//

import UIKit

class BaseViewController: UIViewController {
    
    enum Kind{
        case present
        case show
    }

    func showAlert(kind:Kind,title:String, message: String, action:String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: action, style: .default, handler: nil))
        switch kind {
        case .present:
            present(alertVC, animated:true, completion:nil)
        case .show:
            show(alertVC, sender: nil)
        }
        
    }
    


}
