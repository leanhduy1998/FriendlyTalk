//
//  PhoneNumber.swift
//  FriendlyTalk
//
//  Created by Duy Le on 4/15/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import UIKit

class PhoneNumber: NSObject {
    private var _phoneNumber: String!
    private var _banned: Bool!
    public var phoneNumber: String! {
        get {
            return _phoneNumber
        }
    }
    public var banned: Bool! {
        get {
            return _banned
        }
    }
    init(phoneNumber: String, banned: Bool) {
        _phoneNumber=phoneNumber
        _banned=banned
    }
}
