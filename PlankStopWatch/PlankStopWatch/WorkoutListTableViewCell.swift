//
//  WorkoutListTableViewCell.swift
//  PlankStopWatch
//
//  Created by Kireet Agrawal on 3/23/17.
//  Copyright © 2017 Kireet Agrawal. All rights reserved.
//

import UIKit

class WorkoutListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
