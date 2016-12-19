//
//  EventsCustomCell.swift
//  Seizure Monitoring
//
//  Created by Gabriel Nahum on 12/18/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit

class EventsCustomCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet var maxHR: UILabel!
    @IBOutlet var typeSeizure: UILabel!
    @IBOutlet var endTime: UILabel!
    @IBOutlet var startTime: UILabel!
    @IBOutlet var seconds: UILabel!
    @IBOutlet var nameOfEvent: UILabel!
    @IBOutlet var month: UILabel!
    @IBOutlet var day: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
