//
//  LoginViewController.swift
//  yoteikakunin
//
//  Created by Master on 2015/05/05.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var loginIDTextField: UITextField!
    @IBOutlet var loginPassTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        loginIDTextField.delegate = self
        loginPassTextField.delegate = self
        loginPassTextField.secureTextEntry = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: TextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        UIView.animateWithDuration(0.2, delay: 0.0, options: nil, animations: {
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 150)
        }, completion: nil)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        UIView.animateWithDuration(0.2, delay: 0.0, options: nil, animations: {
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y + 150)
            }, completion: nil)
    }
    
    // MARK: Private
    @IBAction func login() {
        SVProgressHUD.showWithStatus("Sending...", maskType: SVProgressHUDMaskType.Black)
        
        var object: PFObject = PFObject(className: "Picture")
        object["title"] = "駅のホームより"
        var imageData: NSData = UIImageJPEGRepresentation(UIImage(named: "image.jpg"), 0.1)
        var file: PFFile = PFFile(name: "image.jpg", data: imageData)
        object["graphicFile"] = file
        object.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if succeeded {
                SVProgressHUD.dismiss()
            }else {
                self.showAlert(error!)
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func showAlert(error: NSError) {
        var alertController = UIAlertController(title: "UIAlertControllerStyle.Alert", message: "Error", preferredStyle: .Alert)
        
        let reloadAction = UIAlertAction(title: "はい", style: .Default) {
            action in
            self.login
        }
        let cancelAction = UIAlertAction(title: "いいえ", style: .Cancel) {
            action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        // addActionした順に左から右にボタンが配置されます
        alertController.addAction(reloadAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func backToTop() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
