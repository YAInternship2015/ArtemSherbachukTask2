//
//  AddNewEntryViewController.swift
//  YalantisTask#2
//
//  Created by typan on 8/19/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

import UIKit


class AddNewEntryViewController: UIViewController {


  //MARK: OUTLET

  @IBOutlet weak var textField: UITextField!



  //MARK: LOADING
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }


  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }



 //MARK: TARGET ACTION
  
  @IBAction func cancelButtonDidTouch(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func doneButtonDidTouch(sender: UIBarButtonItem) {

    //add from text field message to model
    DataSource.addNewEntryInModel(title: textField.text)

    dismissViewControllerAnimated(true, completion: nil)
  }

  
}
