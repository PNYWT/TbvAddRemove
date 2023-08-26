//
//  TestViewCell.swift
//  TestTbv
//
//  Created by CallmeOni on 26/8/2566 BE.
//

import UIKit

class TestViewCell: UITableViewCell {

    @IBOutlet weak var lbCellTest: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
