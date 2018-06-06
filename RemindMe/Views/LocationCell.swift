//
//  LocationCell.swift
//  RemindMe
//
//  Created by Garrett Votaw on 6/6/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
