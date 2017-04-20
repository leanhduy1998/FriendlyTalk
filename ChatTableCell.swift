//
//  ChatBoardCell.swift
//  FriendlyTalk
//
//  Created by Duy Le on 4/18/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import UIKit

class ChatTableCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoIV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
