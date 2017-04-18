//
//  Alert.swift
//  FriendlyTalk
//
//  Created by Duy Le on 4/15/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import UIKit

class Alert {
    class func showAlert(VC: UIViewController, title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        VC.present(alertController, animated: true, completion: nil)
    }
}
