//
//  PublishersData.swift
//  YalantisTask#2
//
//  Created by typan on 8/21/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

import Foundation
import UIKit

class PublishersData {


  //INITIALIZER
  init() {
    container = PublishersData.getAllPublisherObject()
    numberOfItems = container.count
  }


  //PRIVATE
  private let container: [Publisher]

  private static func getAllPublisherObject() -> [Publisher] {
    let myFavorites = MyFavorites.publisher()
    let politics = Politics.publisher()
    let travel = Travel.publisher()
    let tehnology = Tehnology.publisher()

    var container = [Publisher]()
    container += myFavorites
    container += politics
    container += travel
    container += tehnology

    return container
  }


  //MARK: PUBLIC
  let numberOfItems: Int

  func imageForCellAtIndex(index:Int) -> UIImage {
    var publisherEntry = container[index]
    return publisherEntry.image
  }

  func titleForCellAtIndex(index: Int) -> String {
    var publisherEntry = container[index]
    return publisherEntry.title
  }

}






//Publisher Entry Object
private class Publisher {

  let image: UIImage
  let title: String
  let section: String

  init(image: UIImage, title: String, section: String) {
    self.image = image
    self.title = title
    self.section = section
  }
  
}



//STRUCTRURE For Sections
private struct MyFavorites {
  //array with 5 objects Publisher
  private static func publisher() -> [Publisher] {
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
  //array with 6 objects Publisher
  private static func publisher() -> [Publisher] {
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
  //array with 7 objects Publisher
  private static func publisher() -> [Publisher] {
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
  //array with 5 objects Publisher
  private static func publisher() -> [Publisher] {
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





























