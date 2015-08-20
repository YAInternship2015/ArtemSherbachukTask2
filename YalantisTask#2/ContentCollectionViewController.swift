//
//  ContentCollectionViewController.swift
//  YalantisTask#2
//
//  Created by typan on 8/20/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

import UIKit


class ContentCollectionViewController: UICollectionViewController {


  override func viewDidLoad() {
    super.viewDidLoad()

//    self.collectionView!.registerClass(CustomCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)


  }



  // MARK: UICollectionViewDataSource

  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    return 10
  }

  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellCollection", forIndexPath: indexPath) as!
    CustomCollectionViewCell


    return cell
  }

}
