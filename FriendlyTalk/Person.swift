//
//  Person.swift
//  FriendlyTalk
//
//  Created by Duy Le on 4/18/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import UIKit

class Person {
    private var _nameLabel : String!
    private var _photoName : String!
    private var _uid : String!
    var nameLabel: String! {
        get {
            return _nameLabel
        }
        set {
            _nameLabel = newValue
        }
    }
    var photoName: String! {
        get {
            return _photoName
        }
        set {
            _photoName = newValue
        }
    }
    var uid: String! {
        get {
            return _uid
        }
        set {
            _uid = newValue
        }
    }
    init(name: String!,photo:String!,uid:String!) {
        self.nameLabel=name
        self.photoName=photo
        self.uid=uid
    }
}
