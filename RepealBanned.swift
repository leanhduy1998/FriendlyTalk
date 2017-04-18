//
//  RepealBanned.swift
//  FriendlyTalk
//
//  Created by Duy Le on 4/15/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import UIKit
import Firebase

class RepealBanned: UIViewController {
    
    @IBOutlet weak var appealTF: UITextView!

    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func sendAppealBtnPressed(_ sender: Any) {
        if appealTF.text.isEmpty == false{
            let ref = FIRDatabase.database().reference().child("repealForms").child((FIRAuth.auth()?.currentUser?.uid)!)
            ref.setValue(appealTF.text)
            Alert.showAlert(VC: self, title: "Complete", message: "Your appeal form has been saved!")
            performSegue(withIdentifier: "LoginVC", sender: nil)
        }
        else {
            Alert.showAlert(VC: self, title: "Missing Message!", message: "Please fill in the appeal message!")
        }
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
