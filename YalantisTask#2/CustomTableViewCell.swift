//
//  CustomTableViewCell.swift
//  YalantisTask#2
//
//  Created by typan on 8/20/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

  @IBOutlet weak var userImage: UIImageView!
  @IBOutlet weak var userText: UILabel!


  override func awakeFromNib() {
    super.awakeFromNib()
    userImage.layer.cornerRadius = 3
    userImage.layer.borderWidth = 1
    userImage.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(0.7).CGColor
  }


}
