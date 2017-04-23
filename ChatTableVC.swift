//
//  ChatTableVC.swift
//  FriendlyTalk
//
//  Created by Duy Le on 4/18/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ChatTableVC: UITableViewController,CLLocationManagerDelegate {
    private var peopleWithDistance = [PersonWithDistance]()
    private let locationManager = CLLocationManager()
    private var meCoordinate : CLLocation!
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleWithDistance.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ChatTableCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChatTableCell  else {
            fatalError("The dequeued cell is not an instance of ChatTableCell.")
        }
        let person = peopleWithDistance[indexPath.row]
        cell.nameLabel.text = person.nameLabel
        cell.distanceLabel.text = person.distance
        //cell.photoIV.images
        
        return cell
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataService.dataservice.getMePerson { (person) in
        }
        setUp()
    }
    func setUp(){
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        let updateLocationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChatTableVC.saveLocation), userInfo: nil, repeats: true)
        updateLocationTimer.fire()
        let updateNearbyUsersTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ChatTableVC.updateNearbyUsers), userInfo: nil, repeats: true)
        updateNearbyUsersTimer.fire()
    }
    func saveLocation()
    {
        let latitude = Double((locationManager.location?.coordinate.latitude.description)!)
        let longitude = Double((locationManager.location?.coordinate.longitude.description)!)
        meCoordinate = CLLocation(latitude: latitude!, longitude: longitude!)
        DataService.dataservice.saveLocation(longitute: Double((longitude?.description)!), latitude: Double((latitude?.description)!))
    }
    @objc private func updateNearbyUsers(){
        DataService.dataservice.getNearbyUser(meCoordinate: meCoordinate) { (people:[PersonWithDistance]) in
            self.peopleWithDistance = people
            self.tableView.reloadData()
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        saveLocation()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ChatVC {
            if let cell = sender as? ChatTableCell {
                let indexPath = tableView?.indexPathForSelectedRow
                let youPerson = peopleWithDistance[indexPath!.item]
                destination.chatTitle = youPerson.nameLabel
                destination.youPerson = youPerson
            }
            
           // cell.photoIV = person.photoName
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
