//
//  CustomCollectionViewCell.swift
//  YalantisTask#2
//
//  Created by typan on 8/20/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

import UIKit

class PublisherCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var userImage: UIImageView!
  @IBOutlet weak var visualEffectView: UIVisualEffectView!
  @IBOutlet weak var publisherTitle: UILabel!


  override func awakeFromNib() {
    super.awakeFromNib()

    //visual stile cell
    self.layer.cornerRadius = 3
    self.layer.borderWidth = 1
    self.layer.borderColor = UIColor.grayColor().CGColor

    //add a little thin line in a top of cell.
    let flatShadowLayer = CALayer()
    flatShadowLayer.frame = CGRectMake(0, 0, userImage.frame.width, 3)
    flatShadowLayer.backgroundColor = UIColor.darkGrayColor().CGColor
    self.layer.addSublayer(flatShadowLayer)
  }
  
}
