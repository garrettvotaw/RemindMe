//
//  ReminderCell.swift
//  RemindMe
//
//  Created by Garrett Votaw on 5/10/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell {
    
    

    @IBOutlet weak var bubbleImageView: UIImageView!
    
    @IBOutlet weak var reminderTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        switch selected {
//        case true:
//            bubbleImageView.image = #imageLiteral(resourceName: "FilledCircle")
//            
//        case false:
//            bubbleImageView.image = #imageLiteral(resourceName: "UnfilledCircle")
//            
//        }
        // Configure the view for the selected state
    }

}
