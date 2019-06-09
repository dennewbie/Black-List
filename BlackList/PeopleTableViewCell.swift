//
//  PeopleTableViewCell.swift
//  BlackList
//
//  Created by Denny Caruso on 04/01/2019.
//  Copyright © 2019 Denny Caruso. All rights reserved.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {

    @IBOutlet weak var imgPerson: UIImageView!
    @IBOutlet weak var namePerson: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView?.frame = CGRect(x: 0, y: 0, width: 78, height: 78)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
