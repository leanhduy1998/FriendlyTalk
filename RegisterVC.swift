//
//  RegisterVC.swift
//  FriendlyTalk
//
//  Created by Duy Le on 4/14/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import UIKit
import SinchVerification;


class RegisterVC: UIViewController {
    var verification:Verification!;
    var applicationKey = "77186ae3-0dab-41ce-9774-87798e233597";
    private var _phoneNumber: String!
    var phoneNumber: String {
        get {
            return _phoneNumber
        }
        set {
            _phoneNumber = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func verifyBtnPressed(_ sender: Any) {
        //  disableUI(true);
        verification = SMSVerification(applicationKey,
                                       phoneNumber: phoneNumber);
        
        
        verification.initiate { (result: InitiationResult, error:Error?) -> Void in
            //self.disableUI(false);
            if (result.success){
                print("success")
                //self.performSegue(withIdentifier: "enterPin", sender: sender)
                
            } else {
                print("failed")
                print(error?.localizedDescription)
                //self.status.text = error?.localizedDescription
            }
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
