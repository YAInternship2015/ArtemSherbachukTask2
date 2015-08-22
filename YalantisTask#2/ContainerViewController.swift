//
//  ContainerViewController.swift
//
//
//  Created by typan on 8/19/15.
//
//

import UIKit

class ContainerViewController: UIViewController {

  @IBOutlet weak var containerView: UIView!

  var firstViewCtrl: UIViewController?
  var secondViewCtrl: UIViewController?
  var activeViewCtrl: UIViewController? {
    //setter react on any change varieble
    didSet {
      //1 delete old VC
      removeInactiveViewCtrl(oldValue)
      //2 replace new VC
      updateActiveViewCtrl()

    }
  }

  private var isFirstViewCtrl: Bool = true

  //MARK: LOADING

  override func viewDidLoad() {
    super.viewDidLoad()


    let sb = UIStoryboard(name: "Main", bundle: nil)

    firstViewCtrl = sb.instantiateViewControllerWithIdentifier("TableView") as! ContentTableViewController
    secondViewCtrl = sb.instantiateViewControllerWithIdentifier("CollectionView") as! ContentCollectionViewController
    activeViewCtrl = firstViewCtrl
    isFirstViewCtrl = true
  }



  //MARK: TARGET ACTION

  @IBAction func layoutButtonDidTouch(sender: UIBarButtonItem) {
    activeViewCtrl = isFirstViewCtrl ? secondViewCtrl : firstViewCtrl
    isFirstViewCtrl = !isFirstViewCtrl
  }

  @IBAction func addNewEntryButtonDidTouch(sender: UIBarButtonItem) {
    performSegueWithIdentifier("AddNewEntrySegue", sender: self)
  }




  //MARK: CONTAINER LOGIC

  private func removeInactiveViewCtrl(inactiveViewCtrl: UIViewController?) {
    if let inactiveVC = inactiveViewCtrl {

      inactiveVC.willMoveToParentViewController(nil)
      inactiveVC.view.removeFromSuperview()
      inactiveVC.removeFromParentViewController()

    }
  }

  private func updateActiveViewCtrl() {
    if let activeVC = activeViewCtrl {

//      let barHeight = navigationController!.navigationBar.frame.height
//      let viewHeight = self.view.bounds.height

      self.addChildViewController(activeVC)
      activeVC.view.frame = self.containerView.frame
      self.view.addSubview(activeVC.view)
      activeVC.didMoveToParentViewController(self)

    }
  }

  


  
  
}
