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
    var nameLabel: String! {
        get {
            return _nameLabel
        }
        set {
            _nameLabel=nameLabel
        }
    }
    var photoName: String! {
        get {
            return _photoName
        }
        set {
            _photoName=photoName
        }
    }
    
    init(name: String!,photo:String!) {
        self._nameLabel=name
        self._photoName=photo
    }
}
