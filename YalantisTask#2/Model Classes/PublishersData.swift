//
//  PublishersData.swift
//  YalantisTask#2
//
//  Created by typan on 8/21/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

import Foundation
import UIKit

//golabl let for convenience. Для удобства
let DataSource = PublishersData.sharedInstance


class PublishersData {


  //INITIALIZER
  private init() {
    container = [Publisher]()
    loadDataFromPlist()
  }



  //PRIVATE API
  /*
  ...................
  .     PRIVATE     .
  ...................
  */
  //Construct file path
  private func dataFilePath() -> String {

    //get the Documents Directory in App Sandbox
    func documentDirectory() -> String {
      let documentsDirectory = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,  NSSearchPathDomainMask.UserDomainMask, true) as! [String]
      return documentsDirectory[0]
    }

    return documentDirectory().stringByAppendingPathComponent("dataBase.plist")
  }


  //loading data
  private func loadDataFromPlist() {

    let path = dataFilePath()

    //if file dataBase file is exist
    if NSFileManager.defaultManager().fileExistsAtPath(path) {
      //if that file not empty
      if let data = NSData(contentsOfFile: path) {
        let unarhiver = NSKeyedUnarchiver(forReadingWithData: data)
        container = unarhiver.decodeObjectForKey("Publisher") as! [Publisher]
        unarhiver.finishDecoding()
      }
    }
    
  }


  //save data
  private func saveDataToPlist() {
    let data = NSMutableData()
    let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
    archiver.encodeObject(container, forKey: "Publisher")
    archiver.finishEncoding()
    data.writeToFile(dataFilePath(), atomically: true)
  }


  //Notification in func -> becouse we use it in 2 func. When add new obj and edit exist obj
  private func postNotification(#userInfo: [String: Publisher]?) {
    NSNotificationCenter.defaultCenter().postNotificationName("AddNewEntry", object: self,
      userInfo: userInfo)
  }


  //getter random image path
  private var randomImagePathForNewObj: String {
    var path = ""
    switch arc4random_uniform(7) {
    case 1:
      path = "TIME"
      return path
    case 2:
      path = "The New York Times"
      return path
    case 3:
      path = "TED"
      return path
    case 4:
      path = "MIT Technology Review"
      return path
    case 5:
      path = "The Atlantic"
      return path
    case 6:
      path =  "Daily Intelligencer"
      return path
    case 7:
      path = "Quartz"
      return path
    default:
      path = "Recode"
      return path
    }
  }






  //MARK: PUBLIC API
  /*
  ...................
  .      PUBLIC     .
  ...................
  */
  //singletone pattern in one line in swift :) http://krakendev.io/blog/the-right-way-to-write-a-singleton
  static let sharedInstance = PublishersData()

  var container: [Publisher] //container where I persist all data


  //get image data
  func imageForCellAtIndex(index:Int) -> UIImage {
    var publisherEntry = container[index]
    return publisherEntry.image
  }


  //get title data
  func titleForCellAtIndex(index: Int) -> String {
    var publisherEntry = container[index]
    return publisherEntry.title
  }


  //set new object to container
  func addNewEntryInModel(#title: String) {

    let newObj = Publisher(title: title, imagePath: randomImagePathForNewObj)
    container.append(newObj)

    postNotification(userInfo: nil)
    //send message to ContentTableViewController and ContentCollectionViewController in ViewDidLoad

    saveDataToPlist()
  }


  func removeObjectAtIndex(index: Int) {
    container.removeAtIndex(index)
    saveDataToPlist()
  }


  //edit exist object in container.
  func editExistEntryInModel(#object:Publisher, changeTitle:String) {

    object.title = changeTitle
    postNotification(userInfo: nil)

    saveDataToPlist()
  }

}






//Publisher Entry Object. This is object what we see in Cell
/*
...................
.    PUBLISHER    .
...................
*/
class Publisher: NSObject, NSCoding {

  let image: UIImage
  var title: String
  let section: String


  init(image: UIImage, title: String, section: String) {

    self.image = image
    self.title = title
    self.section = section

    super.init()

  }

  //This is initializer for instance of object with some of data by default.
  convenience init(title: String, imagePath: String) {

    self.init(image: UIImage(named: imagePath)!, title: title, section: "New Added")

  }


  //decode object
  required init(coder aDecoder: NSCoder) {
    let imageData = aDecoder.decodeObjectForKey("image") as! NSData
    image = UIImage(data: imageData)!
    title = aDecoder.decodeObjectForKey("title") as! String
    section = aDecoder.decodeObjectForKey("section") as! String
    super.init()
  }

  //encode object
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(UIImagePNGRepresentation(image), forKey: "image")
    aCoder.encodeObject(title, forKey: "title")
    aCoder.encodeObject(section, forKey: "section")
  }


}








