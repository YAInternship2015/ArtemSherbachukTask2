//
//  PublishersData.swift
//  YalantisTask#2
//
//  Created by typan on 8/21/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

import Foundation
import UIKit

//one golabl object it is model with all func.
let DataSource = PublishersData()


class PublishersData {


  //INITIALIZER
  init() {
    container = [Publisher]()
    loadDataFromPlist()
  }


  //PRIVATE API
  private static func getAllPublisherObject() -> [Publisher] {
    let myFavorites = MyFavorites.dataKit()
    let politics = Politics.dataKit()
    let travel = Travel.dataKit()
    let tehnology = Tehnology.dataKit()

    var container = [Publisher]()
    container += myFavorites
    container += politics
    container += travel
    container += tehnology

    return container
  }


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

    //if file dataBase is exist
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






  //MARK: PUBLIC API
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

    let newObj = Publisher(title: title)
    DataSource.container.append(newObj)

    postNotification(userInfo: nil)
    //send to ContentTableViewController and ContentCollectionViewController in ViewDidLoad

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
  convenience init(title: String) {
    self.init(image: UIImage(named: "TIME")!, title: title, section: "New Added")
  }




  //loading decode
  required init(coder aDecoder: NSCoder) {
    let imageData = aDecoder.decodeObjectForKey("image") as! NSData
    image = UIImage(data: imageData)!
    title = aDecoder.decodeObjectForKey("title") as! String
    section = aDecoder.decodeObjectForKey("section") as! String
    super.init()
  }

  //encode saving
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(UIImagePNGRepresentation(image), forKey: "image")
    aCoder.encodeObject(title, forKey: "title")
    aCoder.encodeObject(section, forKey: "section")
  }


}




//STRUCTRURE For Sections

private struct MyFavorites {
  static let section = "My Favorites"
  //array with 5 objects Publisher
  static func dataKit() -> [Publisher] {
    var publisher = [Publisher]()
    publisher.append(Publisher(image:  UIImage(named: "TIME")!, title: "TIME", section: "My Favorites"))
    publisher.append(Publisher(image:  UIImage(named: "The New York Times")!, title: "The New York Times",
      section: "My Favorites"))
    publisher.append(Publisher(image:  UIImage(named: "TED")!, title: "TED", section: "My Favorites"))
    publisher.append(Publisher(image:  UIImage(named: "Recode")!, title: "Re/code", section: "My Favorites"))
    publisher.append(Publisher(image:   UIImage(named: "WIRED")!, title: "WIRED", section: "My Favorites"))
    return publisher
  }

}

private struct Politics {
  static let section = "Politics"
  //array with 6 objects Publisher
  static func dataKit() -> [Publisher] {
    var publisher = [Publisher]()
    publisher.append(Publisher(image: UIImage(named: "The Atlantic")!, title: "The Atlantic", section: "Politics"))
    publisher.append(Publisher(image: UIImage(named: "The Hill")!, title: "The Hill", section: "Politics"))
    publisher.append(Publisher(image: UIImage(named: "Daily Intelligencer")!, title: "Daily Intelligencer",
      section: "Politics"))
    publisher.append(Publisher(image: UIImage(named: "Vanity Fair")!, title: "Vanity Fair", section: "Politics"))
    publisher.append(Publisher(image: UIImage(named: "TIME")!, title: "TIME", section: "Politics"))
    publisher.append(Publisher(image: UIImage(named: "The Huffington Post")!, title: "The Huffington Post",
      section: "Politics"))
    return publisher
  }

}

private struct Travel {
  static let section = "Travel"
  //array with 7 objects Publisher
  private static func dataKit() -> [Publisher] {
    var publisher = [Publisher]()
    publisher.append(Publisher(image: UIImage(named: "AFAR")!, title: "AFAR", section: "Travel"))
    publisher.append(Publisher(image:  UIImage(named: "The New York Times")!, title: "The New York Times",
      section: "Travel"))
    publisher.append(Publisher(image: UIImage(named: "AFAR")!, title: "AFAR", section: "Travel"))
    publisher.append(Publisher(image: UIImage(named: "Men’s Journal")!, title: "Men’s Journal", section: "Travel"))
    publisher.append(Publisher(image: UIImage(named: "Smithsonian")!, title:"Smithsonian", section: "Travel"))
    publisher.append(Publisher(image: UIImage(named: "Wallpaper")!, title: "Wallpaper", section: "Travel"))
    publisher.append(Publisher(image: UIImage(named: "Sunset")!, title: "Sunset", section: "Travel"))
    return publisher
  }

}


private struct Tehnology {
  static let section = "Tehnology"
  //array with 5 objects Publisher
  private static func dataKit() -> [Publisher] {
    var publisher = [Publisher]()
    publisher.append(Publisher(image: UIImage(named: "WIRED")!, title: "WIRED", section: "Technology"))
    publisher.append(Publisher(image: UIImage(named: "Recode")!, title: "Re/code", section: "Technology"))
    publisher.append(Publisher(image: UIImage(named: "Quartz")!, title: "Quartz", section: "Technology"))
    publisher.append(Publisher(image: UIImage(named: "Daring Fireball")!, title: "Daring Fireball",
      section: "Technology"))
    publisher.append(Publisher(image: UIImage(named: "MIT Technology Review")!, title: "MIT Technology Review",
      section: "Technology"))
    return publisher
  }
  
}





























