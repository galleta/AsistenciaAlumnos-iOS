//
//  DrawerMenuTableViewCell.swift
//  APPsistenciav2
//
//  Created by Francis on 29/01/2019.
//  Copyright © 2019 Francis. All rights reserved.
//

import UIKit

class DrawerMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var imagenmenu: UIImageView!
    @IBOutlet weak var textomenu: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
