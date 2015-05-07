//
//  TopViewController.swift
//  yoteikakunin
//
//  Created by Master on 2015/05/06.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {
    
    var userData: UserManager = UserManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pushSend() {
        if (PFUser.currentUser() == nil) {
            self.performSegueWithIdentifier("toLogin", sender: nil)
        }else {
            self.performSegueWithIdentifier("toSend", sender: nil)
             NSLog("PFUser.currentUser() == %@", PFUser.currentUser()!)
        }
    }
    
    @IBAction func signOut() {
        PFUser.logOut()
        PFUser.currentUser()?.delete()
        SVProgressHUD.showSuccessWithStatus("ログアウトしました", maskType: SVProgressHUDMaskType.Black)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
