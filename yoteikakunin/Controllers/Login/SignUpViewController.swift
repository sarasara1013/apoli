//
//  SignUpViewController.swift
//  yoteikakunin
//
//  Created by Master on 2015/05/05.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userIDTextField: UITextField!
    @IBOutlet var userPassTextField: UITextField!
    
    var userImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIDTextField.delegate = self
        userPassTextField.delegate = self
        userPassTextField.secureTextEntry = true
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
    
    @IBAction func openPhotoLibrary() {
        let ipc: UIImagePickerController = UIImagePickerController();
        ipc.delegate = self
        // ipc.sourceType = UIImagePickerControllerSourceType.Camera
        ipc.allowsEditing = true
        ipc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(ipc, animated:true, completion:nil)
    }
    
    // MARK: UIImagePickerController Delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
            userImageView.image = image
            UserManager.sharedInstance.image = image
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func signUp() {
        SVProgressHUD.showWithStatus("登録中...", maskType: SVProgressHUDMaskType.Black)
        
        var object: PFObject = PFObject(className: "UserInfo")
        object["UserName"] = userIDTextField.text
        UserManager.sharedInstance.userID = userIDTextField.text
        
        var imageData: NSData = UIImageJPEGRepresentation(UserManager.sharedInstance.image, 0.1)
        var userImageData: NSData = UIImagePNGRepresentation(UserManager.sharedInstance.image)
        var file: PFFile = PFFile(data: userImageData)
        object["imageFile"] = file
        object.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if succeeded {
                self.registerUser()
                SVProgressHUD.dismiss()
            }else {
                self.showAlert(error!)
                SVProgressHUD.dismiss()
            }
        }
        
    }
    
    func registerUser() {
        var user = PFUser()
        user.username = userIDTextField.text
        user.password = userPassTextField.text
        user.signUpInBackgroundWithBlock { (succeeded, error) -> Void in
            if error == nil {
                SVProgressHUD.showSuccessWithStatus("登録完了!")
                self.dismiss()
            } else {
                self.showAlert(error!)
            }
        }
    }
    
    @IBAction func back() {
        self.dismiss()
    }
    
    func dismiss () {
        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showAlert(error: NSError) {
        var alertController = UIAlertController(title: "Error", message: String(format: "%@ が原因で実行できませんでした", error), preferredStyle: .Alert)
        
        let reloadAction = UIAlertAction(title: "再送信", style: .Default) {
            action in
            self.signUp()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel) {
            action in
            self.dismiss
        }
        alertController.addAction(reloadAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}
