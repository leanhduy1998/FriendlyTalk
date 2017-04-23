//
//  DataService.swift
//  FriendlyTalk
//
//  Created by Duy Le on 4/22/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class DataService: UIViewController {
    static let dataservice = DataService()
    let roofRef = FIRDatabase.database().reference()
    let meUid = (FIRAuth.auth()?.currentUser?.uid)!
    private var messages = [Message]()
    private var peopleDistances = [PersonWithDistance]()
    
    private var mePerson: Person!
    
    func getMePerson(callback: (Person)->()){
        if mePerson == nil {
            roofRef.child("phoneNumber/"+meUid).observeSingleEvent(of: .value, with: { (snapshot) in
             //   var phoneNumber = ""
                var name = ""
                var photo = ""
                for iden in snapshot.children.allObjects as! [FIRDataSnapshot] {
               //     if iden.key == "phoneNumber" {
                //        phoneNumber = iden.value as! String!
                 //   }
                    if iden.key == "name" {
                        name = iden.value as! String!
                    }
                    else if iden.key == "photo" {
                        photo = iden.value as! String!
                    }
                }
                self.mePerson = Person(name: name, photo: photo, uid: self.meUid)
            })
        }
        else {
            callback(mePerson)
        }
    }
    
    func getMessages(youUid: String!, callback: @escaping ([Message])->()){
        var combinedUid = ""
        if youUid < meUid {
            combinedUid = youUid + meUid
        }
        else {
            combinedUid = meUid + youUid
        }
        roofRef.child("messages/"+combinedUid).observe(FIRDataEventType.value, with: { (snapshot) in
            for time in snapshot.children.allObjects as! [FIRDataSnapshot] {
                var sender = ""
                var message = ""
                for category in time.children.allObjects as! [FIRDataSnapshot] {
                    if category.key == "sender" {
                        sender = category.value as! String
                    }
                    else if category.key == "message" {
                        message = category.value as! String
                    }
                }
                let singleMessage = Message(senderI: sender, messageI: message)
                if sender.isEmpty {
                    
                }
                else {
                    self.messages += [singleMessage]
                }
            }
            callback(self.messages)
            self.messages.removeAll()
        })
    }
    func getNearbyUser(meCoordinate : CLLocation!, callback: @escaping ([PersonWithDistance])->()){
        var uids = [String]()
        roofRef.child("location").observe(FIRDataEventType.value, with: { (snapshot) in
            for user in snapshot.children.allObjects as! [FIRDataSnapshot] {
                var latitude:Double!
                var longitude:Double!
                var uid = user.key
                
                if uid == self.meUid {
                    
                }
                else {
                    for category in user.children.allObjects as! [FIRDataSnapshot] {
                        if category.key == "latitude" {
                            latitude = category.value as! Double!
                        }
                        else if category.key == "longitude" {
                            longitude = category.value as! Double!
                        }
                    }
                    
                    let youCoordinate = CLLocation(latitude: latitude, longitude: longitude)
                    let distance = self.calculateDistance(meCoordinate: meCoordinate, youCoordinate: youCoordinate)
                    if distance <= 800 {
                        uids += [uid]
                        var exist = false
                        let person = PersonWithDistance(name: "nil", photo: "nil", uid: uid, distance: String(distance))
                        for per in self.peopleDistances {
                            if per.uid == person.uid {
                                per.distance = person.distance
                                per.nameLabel = person.nameLabel
                                per.photoName = person.photoName
                                per.uid = person.uid
                                exist=true
                            }
                        }
                        if exist {
                            
                        }
                        else {
                            self.peopleDistances += [person]
                        }
                    }
                }
                
            }
            for userUid in uids {
                if userUid == self.meUid {
                    
                }
                else {
                    self.roofRef.child("phoneNumber").child(userUid).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
                        for person in self.peopleDistances {
                            if person.uid == userUid {
                                person.nameLabel = snapshot.value as! String
                                self.roofRef.child("phoneNumber").child(userUid).child("photoName").observeSingleEvent(of: .value, with: { (snapshot2) in
                                    person.photoName = snapshot2.value as! String
                    
                                })
                            }
                        }
                    callback(self.peopleDistances)
                    })
                }
            }
        })
    }
    func calculateDistance(meCoordinate: CLLocation, youCoordinate: CLLocation) -> (Double){
        let lat1 = Double(meCoordinate.coordinate.latitude)
        let lon1 = Double(meCoordinate.coordinate.longitude)
        let lat2 = Double(youCoordinate.coordinate.latitude)
        let lon2 = Double(youCoordinate.coordinate.longitude)
        let coordinate = CLLocation(latitude: lat1, longitude: lon1)
        let coordinate1 = CLLocation(latitude: lat2, longitude: lon2)
        let distanceInMeters = coordinate.distance(from: coordinate1)
        return (distanceInMeters)
    }
    func saveLocation(longitute:Double!,latitude:Double!){
        roofRef.child("location").child(meUid).child("longitude").setValue(longitute)
        roofRef.child("location").child(meUid).child("latitude").setValue(latitude)
    }


}
