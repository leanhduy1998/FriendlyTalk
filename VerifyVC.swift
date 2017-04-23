//
//  VerifyVC.swift
//  FriendlyTalk
//
//  Created by Duy Le on 4/14/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import UIKit
import SinchVerification;
import Firebase

class VerifyVC: UIViewController {
    @IBOutlet weak var codeTF: UITextField!
    
    private var _verification:Verification!
    var verification: Verification! {
        get {
            return _verification
        }
        set {
            _verification = newValue
        }
    }
    
    private var _phoneNumber: String!
    var phoneNumber: String! {
        get {
            return _phoneNumber
        }
        set {
            _phoneNumber = newValue
        }
    }
    
    @IBOutlet weak var verifyTF: UITextField!
    @IBAction func resendCodeBtn(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func verifyBtnPressed(_ sender: Any) {
        if codeTF.text?.isEmpty == false {
            verification.verify(codeTF.text!, completion: { (success: Bool, error:Error?) in
                if success {
                    let ref = FIRDatabase.database().reference().child("phoneNumber").child((FIRAuth.auth()?.currentUser?.uid)!)
                    ref.child("phoneNumber").setValue(self._phoneNumber)
                    ref.child("banned").setValue(false)
                    self.performSegue(withIdentifier: "ChatTableVC", sender: nil)
                }
                else {
                    Alert.showAlert(VC: self, title: error?.localizedDescription, message: error?.localizedDescription)
                    return
                }
   
            })
        }
        else {
            Alert.showAlert(VC: self, title: "Missing Verification Code!", message: "Please fill in verification code!")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
