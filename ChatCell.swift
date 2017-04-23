//
//  ChatCellTableViewCell.swift
//  FriendlyTalk
//
//  Created by Duy Le on 4/22/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    @IBOutlet weak var profileYouIV: UIImageView!
    @IBOutlet weak var chatYouLabel: UILabel!
    @IBOutlet weak var chatMeLabel: UILabel!
    @IBOutlet weak var profileMeIV: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
