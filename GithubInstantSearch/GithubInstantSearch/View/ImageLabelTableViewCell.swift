//
//  ImageLabelTableViewCell.swift
//  GithubInstantSearch
//
//  Created by Shashank Shandilya on 4/22/18.
//  Copyright © 2018 org. All rights reserved.
//

import UIKit

class ImageLabelTableViewCell: UITableViewCell {
    @IBOutlet weak var imageV: UIImageView!
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
