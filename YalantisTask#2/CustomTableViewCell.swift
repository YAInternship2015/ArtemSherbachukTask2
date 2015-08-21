//
//  CustomTableViewCell.swift
//  YalantisTask#2
//
//  Created by typan on 8/20/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

  @IBOutlet weak var publisherImage: UIImageView!
  @IBOutlet weak var publisherTitle: UILabel!


  override func awakeFromNib() {
    super.awakeFromNib()
    //visual style for userImage
    publisherImage.layer.cornerRadius = 3
    publisherImage.layer.borderWidth = 1
    publisherImage.layer.borderColor = UIColor.grayColor().CGColor
    
    //thin line on top of image for nice looking
    let flatShadowLine = CALayer()
    flatShadowLine.backgroundColor = UIColor.grayColor().CGColor
    flatShadowLine.frame = CGRectMake(0, 0, publisherImage.bounds.width, 2)
    publisherImage.layer.addSublayer(flatShadowLine)
  }


}
