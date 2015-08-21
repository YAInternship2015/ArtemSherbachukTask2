//
//  ContentTableViewController.swift
//  YalantisTask#2
//
//  Created by typan on 8/20/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

import UIKit

class ContentTableViewController: UITableViewController {


  let dataSource = PublishersData()

  //MARK: LOADING

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 80
  }


  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    cell.alpha = 0
    cell.transform = CGAffineTransformMakeScale(0.1, 0.1)

    //individual time for animation on each cell
    var time = Double(indexPath.row) / Double(dataSource.numberOfItems)

    UIView.animateWithDuration(time, animations: { () -> Void in
        cell.alpha = 1
        cell.transform = CGAffineTransformMakeScale(1, 1)
    })
  }


  // MARK:  DATASOURCE TABLE-VIEW

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.numberOfItems
  }


  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("CellTable", forIndexPath: indexPath) as! CustomTableViewCell


    cell.backgroundColor = indexPath.row % 2 == true ?
      UIColor.whiteColor() : UIColor.lightGrayColor().colorWithAlphaComponent(0.3)

    cell.publisherImage.image = dataSource.imageForCellAtIndex(indexPath.row)
    cell.publisherTitle.text = dataSource.titleForCellAtIndex(indexPath.row)

    return cell
  }


  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath) as! CustomTableViewCell

    let color = CALayer()
    color.frame = cell.bounds
    color.backgroundColor = UIColor(red:0.204, green:0.737, blue:0.6, alpha:0.5).CGColor

    cell.selectedBackgroundView.layer.addSublayer(color)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}
