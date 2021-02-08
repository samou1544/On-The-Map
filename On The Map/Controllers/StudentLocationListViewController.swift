//
//  StudentLocationListViewController.swift
//  On The Map
//
//  Created by Asma  on 1/13/21.
//

import UIKit

class StudentLocationListViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    let studentLocationCellIdentifier="studentLocationCell"
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(StudentLocationModel.studentLocations.count)
        return StudentLocationModel.studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: studentLocationCellIdentifier)!
        
        let studentLocation = StudentLocationModel.studentLocations[indexPath.row]
        let studentName=studentLocation.firstName+" "+studentLocation.lastName
        cell.textLabel?.text = studentName
        cell.imageView?.image = UIImage(named: "IconPin")
        cell.detailTextLabel?.text = studentLocation.mediaURL
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let url = URL(string: StudentLocationModel.studentLocations[indexPath.row].mediaURL) else { return }
        UIApplication.shared.open(url)
        tableView.deselectRow(at: indexPath, animated: true)
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
        tableView.reloadData()
    }

}
