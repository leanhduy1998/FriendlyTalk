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
        if emailTF.text?.isEmpty ?? true {
            print("not filled")
        }
        else if passwordTF.text?.isEmpty ?? true {
            print("not filled")
        }
        else {
            //let phoneNumber = emailTF.text
            
            
            
            
            let email = emailTF.text
            let password = passwordTF.text
            
            FIRAuth.auth()?.signIn(withEmail: email!, password: password!) { (user, error) in
                if let error = error{
                    if error.localizedDescription == self.badEmail {
                        let alertController = UIAlertController(title: "Wrong email format", message:
                            "Please enter the correct email", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                        self.present(alertController, animated: true, completion: nil)
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
                
                let refHandle = ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    let phoneNumber = snapshot.value as? PhoneNumber
                    let banned = phoneNumber?.banned
                    let number = phoneNumber?.phoneNumber
                    
                    if number == nil {
                        self.performSegue(withIdentifier: "RegisterVC", sender: nil)
                    }
                    else {
                        if banned ?? true {
                            self.performSegue(withIdentifier: "RepealBannedVC", sender: nil)
                        }
                        else {
                            self.performSegue(withIdentifier: "ChatVC", sender: nil)
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

