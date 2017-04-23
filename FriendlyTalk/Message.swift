//
//  MessageViewController.swift
//  FriendlyTalk
//
//  Created by Duy Le on 4/22/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import UIKit

class Message {
    private var _sender: String!
    private var _message: String!
    private var _timeStamp: Double!
    var sender: String! {
        get {
            return _sender
        }
        set {
            _sender = newValue
        }
    }
    var message: String! {
        get {
            return _message
        }
        set {
            _message = newValue
        }
    }
    var timeStamp: Double! {
        get {
            return _timeStamp
        }
        set {
            _timeStamp = newValue
        }
    }
    init(senderI: String!, messageI: String!) {
        self._message = messageI
        self._sender = senderI
    }

}
