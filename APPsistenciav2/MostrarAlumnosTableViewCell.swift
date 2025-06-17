//
//  MostrarAlumnosTableViewCell.swift
//  APPsistenciav2
//
//  Created by Francis on 29/01/2019.
//  Copyright © 2019 Francis. All rights reserved.
//

import UIKit

class MostrarAlumnosTableViewCell: UITableViewCell {

    @IBOutlet weak var lNombreAlumno: UILabel!
    @IBOutlet weak var lApellidosAlumno: UILabel!
    @IBOutlet weak var lEtiquetaNombre: UILabel!
    @IBOutlet weak var lEtiquetaApellido: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
