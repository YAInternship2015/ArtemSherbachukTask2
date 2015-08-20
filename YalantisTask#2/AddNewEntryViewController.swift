//
//  AddNewEntryViewController.swift
//  YalantisTask#2
//
//  Created by typan on 8/19/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

import UIKit

class AddNewEntryViewController: UIViewController {


  @IBOutlet weak var textField: UITextField!



  override func viewDidLoad() {
    super.viewDidLoad()

  }


  //MARK: TARGET ACTION

  @IBAction func cancelButtonDidTouch(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func doneButtonDidTouch(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  
}
