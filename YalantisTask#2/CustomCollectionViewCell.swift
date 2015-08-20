//
//  CustomCollectionViewCell.swift
//  YalantisTask#2
//
//  Created by typan on 8/20/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var userImage: UIImageView!


  override func awakeFromNib() {
    super.awakeFromNib()
    userImage.layer.cornerRadius = 3
  }
  
}
