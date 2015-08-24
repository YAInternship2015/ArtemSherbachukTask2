//
//  AddNewEntryViewController.swift
//  YalantisTask#2
//
//  Created by typan on 8/19/15.
//  Copyright (c) 2015 Artem Sherbachuk. All rights reserved.
//

import UIKit

protocol AddNewEntryViewControllerDelegate: class {
  func cancelAddNewEntryViewControllerWithAnimationCell(#controller: AddNewEntryViewController,
    cellIndexPath: NSIndexPath?)
}

class AddNewEntryViewController: UIViewController, UITextFieldDelegate {


  //MARK: OUTLET
  //OUTLET can't to be private
  @IBOutlet weak var doneButton: UIBarButtonItem!
  @IBOutlet weak var textField: UITextField!

  var editEntry: Publisher? //object from selected cell
  weak var delegate: AddNewEntryViewControllerDelegate?
  var indexPathForCellAnimation: NSIndexPath? //path for animate cell that execute edit screen when it dismiss


  //MARK: LOADING

  override func viewDidLoad() {
    super.viewDidLoad()

    textField.delegate = self

    // this means if editEntry != nil. If We want to edit object
    if let editEntry = editEntry {
      title = "Edit Entry"
      textField.text = editEntry.title
      doneButton.enabled = true
    } else  {
      title = "Add New Entry"
      doneButton.enabled = false
    }

  }


  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }








  //MARK: TARGET ACTION

  @IBAction func cancelButtonDidTouch(sender: UIBarButtonItem) {
    delegate?.cancelAddNewEntryViewControllerWithAnimationCell(controller: self,
      cellIndexPath: indexPathForCellAnimation)
  }


  @IBAction func doneButtonDidTouch(sender: UIBarButtonItem) {

    //if we edit object.
    if let entry = editEntry {
      DataSource.editExistEntryInModel(object:entry, changeTitle:textField.text)
    } else {
      //if we add new object.
      DataSource.addNewEntryInModel(title: textField.text)
    }

    dismissViewControllerAnimated(true, completion: nil)
  }








  //MARK: UITextFieldDelegate
  //disable done button if "text" < 3 characters
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
    replacementString string: String) -> Bool {

      let oldText: NSString = textField.text
      let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)

      doneButton.enabled =  newText.length > 2 ? true : false
      
      return true
  }
  
}
