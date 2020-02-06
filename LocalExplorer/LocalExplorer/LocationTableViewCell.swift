//
//  LocationTableViewCell.swift
//  LocalExplorer
//
//  Created by Joshua Marriott on 4/4/19.
//  Copyright © 2019 Joshua Marriott. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var previewImage: UIImageView!{
        didSet {
            previewImage.clipsToBounds = false;
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
