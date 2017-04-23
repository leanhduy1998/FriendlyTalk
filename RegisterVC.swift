//
//  RegisterVC.swift
//  FriendlyTalk
//
//  Created by Duy Le on 4/14/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import UIKit
import SinchVerification;

extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.characters.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}

class RegisterVC: UIViewController {
    @IBOutlet weak var regionTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    private var verification:Verification!;
    private var applicationKey = "77186ae3-0dab-41ce-9774-87798e233597";
    private var _phoneNumber: String!
    private var _regionNumber: String!
    var regionNumber: String {
        get {
            return _regionNumber
        }
        set {
            _regionNumber = newValue
        }
    }
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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    private func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
    @IBAction func verifyBtnPressed(_ sender: Any) {
        var str = regionTF.text!
        if str[str.startIndex] != "+" {
            str = "+" + str
        }
            
        let afterPlus = str.index(after: str.startIndex)
        let range = afterPlus..<str.endIndex
        if phoneTF.text?.isEmpty == true {
            Alert.showAlert(VC: self, title: "Missing phone number!", message: "Please fill in your phone number!")
        }
        else if regionTF.text?.isEmpty == true {
            Alert.showAlert(VC: self, title: "Missing phone region!", message: "Please fill in your phone region!")
        }
        
        else if (regionTF.text?.characters.count)! > 4 {
            Alert.showAlert(VC: self, title: "Wrong phone region format!", message: "Please fill in your phone region!")
        }
        else if self.isStringAnInt(string: str[range])  == false {
                Alert.showAlert(VC: self, title: "Wrong phone region format!", message: "Please fill in your phone region!")
            return
        }
        
        else if phoneTF.text?.isPhoneNumber == false {
            Alert.showAlert(VC: self, title: "Wrong phone number format!", message: "Please fill in the right phone number!")
        }
        else {
            _regionNumber = str;
            _phoneNumber = phoneTF.text
            let fullNumber = _regionNumber+_phoneNumber
            //  disableUI(true);
            verification = SMSVerification(applicationKey,
                                           phoneNumber: fullNumber);
            
            
            verification.initiate { (result: InitiationResult, error:Error?) -> Void in
                //self.disableUI(false);
                if (result.success){
                    self.performSegue(withIdentifier: "VerifyVC", sender: self.verification)
                } else {
                    print("failed")
                    print(error.debugDescription)
                    
                    //self.status.text = error?.localizedDescription
                }
            }
            
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? VerifyVC {
            if let verification = sender as? Verification {
                destination.verification = verification
                destination.phoneNumber = _phoneNumber
            }
        }
    }
    

}
