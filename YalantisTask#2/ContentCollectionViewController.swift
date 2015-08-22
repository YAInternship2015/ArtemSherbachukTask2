//
//  ContentCollectionViewController.swift
//  YalantisTask#2
//
//  Created by typan on 8/20/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

import UIKit


class ContentCollectionViewController: UICollectionViewController {





  //MARK: LOADING VIEW

  override func viewDidLoad() {
    super.viewDidLoad()

    //collectionView grid parametrs setup
    let leftAndRightPadding: CGFloat = 32.0
    let numberOfItemPerRow: CGFloat = 3.0
    let heightAdjustment: CGFloat = 30.0

    let withOneItemForGrid3x = (CGRectGetWidth(collectionView!.frame) - leftAndRightPadding) / numberOfItemPerRow
    let layout = collectionViewLayout as! UICollectionViewFlowLayout
    layout.itemSize = CGSizeMake(withOneItemForGrid3x, withOneItemForGrid3x + heightAdjustment)
    //end collectionView grid setup


    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: Selector("addNewEntryToList:"), name: "AddNewEntry", object: nil)
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    //animation collectionView each time they appear on screen
    collectionView!.alpha = 0
    UIView.animateWithDuration(0.5, animations: { () -> Void in
      self.collectionView!.alpha = 1
    })
    //end animation

    collectionView!.reloadData()
  }





  // MARK:  DataSource CCLLECTION-VIEW

  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    return DataSource.container.count
  }

  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellCollection", forIndexPath: indexPath) as!
    PublisherCollectionViewCell

    cell.publisherImage.image = DataSource.imageForCellAtIndex(indexPath.row)
    cell.publisherTitle.text = DataSource.titleForCellAtIndex(indexPath.row)

    return cell
  }





  //MARK: CELL VISUAL SYLE

  //animation cell
  override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {

    //start visual point for cell
    cell.alpha = 0
    cell.transform = CGAffineTransformMakeScale(0.1, 0.1)

    //individual time for animation on each cell
    var time = Double(indexPath.row) / Double(DataSource.container.count)

    UIView.animateWithDuration(time, animations: { () -> Void in
      cell.alpha = 1
      cell.transform = CGAffineTransformMakeScale(1, 1)
    })

  }






  //MARK: NOTIFICATION

  func addNewEntryToList(notification: NSNotification) {

    let newRowIndex = DataSource.container.count

    let newObj = notification.userInfo!["newObj"] as! Publisher

    DataSource.container.append(newObj)

    collectionView!.insertItemsAtIndexPaths([NSIndexPath(forItem: newRowIndex, inSection: 0)])
  }


}
