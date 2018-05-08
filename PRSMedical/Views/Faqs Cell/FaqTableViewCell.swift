//
//  FaqTableViewCell.swift
//  PRSMedical
//
//  Created by Lucideus  on 4/16/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit

class FaqTableViewCell: UITableViewCell {
    @IBOutlet weak var labelQuestion : UILabel!
    @IBOutlet weak var labelAnswer : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
