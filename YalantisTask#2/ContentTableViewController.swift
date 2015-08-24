//
//  ContentTableViewController.swift
//  YalantisTask#2
//
//  Created by typan on 8/20/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

import UIKit

class ContentTableViewController: UITableViewController {




  //MARK: LOADING

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.rowHeight = 80

    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: Selector("addNewEntryToList:"), name: "AddNewEntry", object: nil)

  }


  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    //animation tableView each time when they appear
    tableView.alpha = 0
    tableView.transform = CGAffineTransformMakeScale(0.1, 0.1)
    UIView.animateWithDuration(0.5, animations: { () -> Void in
      self.tableView.alpha = 1
      self.tableView.transform = CGAffineTransformMakeScale(1, 0.1)
    })
    UIView.animateWithDuration(0.5, delay: 0.5, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1,
      options: nil, animations: { () -> Void in
        self.tableView.transform = CGAffineTransformMakeScale(1, 1)
      }, completion: nil)
    //end animation


    tableView.reloadData()
  }







  // MARK:  DataSource TABLE-VIEW
  /*
  .........................
  .        101010001      .
  .........................
  */

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return DataSource.container.count
  }


  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("CellTable", forIndexPath: indexPath) as! CustomTableViewCell


    cell.backgroundColor = indexPath.row % 2 == true ?
      UIColor.whiteColor() : UIColor.lightGrayColor().colorWithAlphaComponent(0.3)

    cell.publisherImage.image = DataSource.imageForCellAtIndex(indexPath.row)
    cell.publisherTitle.text = DataSource.titleForCellAtIndex(indexPath.row)

    return cell
  }


  //delete entry from list
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

    DataSource.removeObjectAtIndex(indexPath.row)

    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
  }








  //MARK: CELL VISUAL STYLE
  /*
  .........................
  .        STYLE          .
  .........................
  */

  //green highlights on cell, when touch
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    let cell = tableView.cellForRowAtIndexPath(indexPath) as! CustomTableViewCell

    //new basic layer
    let color = CALayer()
    color.frame = cell.bounds
    color.backgroundColor = UIColor(red:0.204, green:0.737, blue:0.6, alpha:0.5).CGColor

    //add colored layer to cell. This way more smooth then cell.contentView.backgroundColor
    cell.selectedBackgroundView.layer.addSublayer(color)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)

  }


  //FadeIn animation cell
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

    cell.alpha = 0
    cell.transform = CGAffineTransformMakeScale(0, 0)

    //individual time for animation on each cell
    var time = Double(indexPath.row) / Double(DataSource.container.count)

    UIView.animateWithDuration(time, animations: { () -> Void in
      cell.alpha = 1
      cell.transform = CGAffineTransformMakeScale(1, 1)
    })
  }







  //MARK: NOTIFICATION
  /*
  .........................
  .     SOS! SOS!...      .
  .........................
  */

  func addNewEntryToList(notification: NSNotification) {
    
    tableView.reloadData()
    
  }






  //MARK: NAVIGATION
  /*
  .........................
  .       FROM -> TO      .
  .........................
  */

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    if segue.identifier == "EditEntrySegue" {

      let navCtrl = segue.destinationViewController as! UINavigationController
      let controller = navCtrl.topViewController as! AddNewEntryViewController


      if let indexPath = tableView.indexPathForCell(sender as! CustomTableViewCell) {
        controller.editEntry = DataSource.container[indexPath.row]
      }

    }

  }
  
}
