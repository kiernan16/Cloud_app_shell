//
//  MetadataTableViewCell.swift
//  Nielsen Cloud App
//
//  Created by Nielsen on 4/9/17.
//  Copyright © 2017 Nielsen. All rights reserved.
//

import UIKit

class MetadataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellTextField: UITextField!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
