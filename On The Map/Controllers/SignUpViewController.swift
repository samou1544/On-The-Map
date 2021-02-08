//
//  SignUpViewController.swift
//  On The Map
//
//  Created by Asma  on 1/15/21.
//
import WebKit
import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let request = URLRequest(url: UdacityClient.Endpoints.webAuth.url)
        webView.load(request)
        
    }
    
    
    @IBAction func done(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
