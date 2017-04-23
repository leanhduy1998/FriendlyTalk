//
//  ChatVC.swift
//  FriendlyTalk
//
//  Created by Duy Le on 4/21/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import UIKit
import Firebase

class ChatVC: UIViewController {
    private var _title: String!
    var messages = [Message]()
    var chatTitle: String! {
        get {
            return _title
        }
        set {
            _title = newValue
        }
    }
    @IBOutlet weak var chatTitleLabel: UILabel!
    @IBOutlet weak var chatBoxLabel: UITextField!
    @IBOutlet weak var tableView: UITableView!
    private var _youPerson: PersonWithDistance!
    var youPerson: PersonWithDistance! {
        get {
            return _youPerson
        }
        set {
            _youPerson = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        updateTableView()
        // Do any additional setup after loading the view.
    }
    private func setUp(){
        chatTitleLabel.text = chatTitle
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        tableView.delegate = self
        tableView.dataSource = self
    }
    func updateTableView(){
        DataService.dataservice.getMessages(youUid: youPerson.uid) { (messagesArr) in
            self.messages = messagesArr
            self.tableView.reloadData()
            if self.messages.count>0 {
                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    @IBAction func sendBtnPressed(_ sender: Any) {
        if chatBoxLabel.text?.isEmpty == false {
            let meUid = FIRAuth.auth()?.currentUser?.uid as String!
            var combinedUid = ""
            if self.youPerson.uid < meUid!{
                combinedUid = self.youPerson.uid + meUid!
            }
            else {
                combinedUid = meUid! + self.youPerson.uid
            }
            
            let iPadAnnouncementDate = NSDate(timeIntervalSinceReferenceDate: 486_308_000.0)
            var t = Int(NSDate().timeIntervalSince(iPadAnnouncementDate as Date))
            let time = String(format:"%d", t) + meUid!
            let messageRef = FIRDatabase.database().reference().child("messages").child(combinedUid).child(time)
            messageRef.child("members").setValue([meUid,self.youPerson.uid])
            messageRef.child("sender").setValue(meUid)
            messageRef.child("message").setValue(self.chatBoxLabel.text)
            messageRef.child("timestamp").setValue(time)
            updateTableView()
            self.chatBoxLabel.text=""
        }
    }
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    


}
private struct Constaint {
    static let cellIdMessageReceived = "ChatCellYou"
    static let cellIdMessageSent = "ChatCellMe"
}
extension ChatVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageSingle = messages[indexPath.row]
        var mePerson: Person!
        DataService.dataservice.getMePerson { (person) in
            mePerson = person
        }
        
        
        if messageSingle.sender == mePerson.uid {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constaint.cellIdMessageSent, for: indexPath) as! ChatCell
            cell.chatMeLabel.text = messageSingle.message
            //cell.profileMeIV ==
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constaint.cellIdMessageReceived, for: indexPath) as! ChatCell
            cell.chatYouLabel.text = messageSingle.message
            //cell.profileYouIV ==
            return cell
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
