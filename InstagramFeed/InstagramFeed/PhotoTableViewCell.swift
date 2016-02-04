//
//  PhotoTableViewCell.swift
//  InstagramFeed
//
//  Created by Marc Anderson on 2/3/16.
//  Copyright © 2016 Marc Adam. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    var photoURL: NSURL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
