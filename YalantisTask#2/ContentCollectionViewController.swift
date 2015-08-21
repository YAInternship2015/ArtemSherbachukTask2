//
//  ContentCollectionViewController.swift
//  YalantisTask#2
//
//  Created by typan on 8/20/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

import UIKit


class ContentCollectionViewController: UICollectionViewController {

  //MARK: PARAMETERS
  let dataSource = PublishersData()
  private let leftAndRightPadding: CGFloat = 32.0
  private let numberOfItemPerRow: CGFloat = 3.0
  private let heightAdjustment: CGFloat = 30.0



  //MARK: LOADING VIEW

  override func viewDidLoad() {
    super.viewDidLoad()

    let withOneItemForGrid3x = (CGRectGetWidth(collectionView!.frame) - leftAndRightPadding) / numberOfItemPerRow
    let layout = collectionViewLayout as! UICollectionViewFlowLayout
    layout.itemSize = CGSizeMake(withOneItemForGrid3x, withOneItemForGrid3x + heightAdjustment)


  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)


  }

  override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {

    cell.alpha = 0
    cell.transform = CGAffineTransformMakeScale(0.1, 0.1)

    //individual time for animation on each cell
    var time = Double(indexPath.row) / Double(dataSource.numberOfItems)

    UIView.animateWithDuration(time, animations: { () -> Void in
      cell.alpha = 1
      cell.transform = CGAffineTransformMakeScale(1, 1)
    })

  }


  // MARK:  DATASOURCE CCLLECTION-VIEW

  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }

  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    return dataSource.numberOfItems
  }

  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellCollection", forIndexPath: indexPath) as!
    PublisherCollectionViewCell

    cell.publisherImage.image = dataSource.imageForCellAtIndex(indexPath.row)
    cell.publisherTitle.text = dataSource.titleForCellAtIndex(indexPath.row)

    return cell
  }

}
