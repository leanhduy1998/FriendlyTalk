//
//  ViewController.swift
//  FriendlyTalk
//
//  Created by Duy Le on 4/11/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
  
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    private var handle: FIRAuthStateDidChangeListenerHandle?
    private let badEmail = "The email address is badly formatted."
    private let notSignedUp = "There is no user record corresponding to this identifier. The user may have been deleted."

    override func viewDidLoad() {
        super.viewDidLoad()
        FIRApp.configure()
        setup();
    
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func testBtn(_ sender: Any) {
        performSegue(withIdentifier: "ChatTableVC", sender: nil)
    }
    private func setup(){
        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            // ...
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func LoginBtnPressed(_ sender: Any) {
        if emailTF.text?.isEmpty == true {
            Alert.showAlert(VC: self, title: "Missing email!", message: "Please enter your email!")
        }
        else if passwordTF.text?.isEmpty == true {
            Alert.showAlert(VC: self, title: "Missing password!", message: "Please enter your password")
        }
        else {
            let email = emailTF.text
            let password = passwordTF.text
            
            FIRAuth.auth()?.signIn(withEmail: email!, password: password!) { (user, error) in
                if let error = error{
                    if error.localizedDescription == self.badEmail {
                        Alert.showAlert(VC: self, title: "Wrong email format", message: "Please enter the correct email")
                    }
                    else if error.localizedDescription == self.notSignedUp {
                        FIRAuth.auth()?.createUser(withEmail: email!, password: password!) { (user, error) in
                                if let error = error {
                                print(error.localizedDescription)
                                return
                            }
                            // if failed, already return. When not failed, continue
                            self.performSegue(withIdentifier: "RegisterVC", sender: nil)
                        }
                    }
                    
                    return
                }
                // if failed, already return. When not failed, continue
                var ref: FIRDatabaseReference!
                ref = FIRDatabase.database().reference().child("phoneNumber").child((FIRAuth.auth()?.currentUser?.uid)!)
                
                _ = ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    let phoneNumber = snapshot.value as! NSArray
                    let banned = phoneNumber[1] as! Bool
                    let number = phoneNumber[0] as! String
                    
                    if number.isEmpty {
                        self.performSegue(withIdentifier: "RegisterVC", sender: nil)
                    }
                    else {
                        if banned == true {
                            self.performSegue(withIdentifier: "RepealBannedVC", sender: nil)
                        }
                        else {
                            self.performSegue(withIdentifier: "ChatBoardVC", sender: nil)
                        }
                    }
                })
            }
        }
        
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? RegisterVC {
            if let phoneNumber = sender as? String {
                destination.phoneNumber=phoneNumber
            }
        }
    }*/
    
}

