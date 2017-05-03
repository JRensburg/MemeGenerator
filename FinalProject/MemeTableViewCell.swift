//
//  MemeTableViewCell.swift
//  FinalProject
//
//  Created by Jaco Van Rensburg on 4/28/17.
//  Copyright © 2017 Jaco van  Rensburg. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    @IBOutlet weak var memeView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
