//
//  SelectViewController.swift
//  yoteikakunin
//
//  Created by reina on 2015/05/04.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class SelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var friendsTableView: UITableView!
    var friendArray = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        
        friendsTableView.layer.borderWidth = 1.0
        friendsTableView.layer.borderColor = UIColor.blackColor().CGColor
        
        var nib  = UINib(nibName: "FriendsCell", bundle:nil)
        friendsTableView.registerNib(nib, forCellReuseIdentifier:"FriendsCell")
        
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Get data from Parse
    func loadData(){
        SVProgressHUD.showWithStatus("ロード中", maskType: SVProgressHUDMaskType.Black)
        
        var usersData: PFQuery = PFQuery(className: "_User")
        usersData.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error != nil {
                self.showErrorAlert(error!)
            }else {
                for object in objects! {
                    
                    var user = PFUser.currentUser()
                    if user?.username == object.valueForKey("username") as? PFUser {
                        NSLog("currentUser == %@", user!.username!)
                    }else {
                        NSLog("object == %@", object as! PFUser)
                        var friendInfo = FriendManager()
                        friendInfo.name = object.valueForKey("username") as! String
                        if object["imageFile"] != nil {
                            NSLog("imageFile == %@", object["imageFile"] as! PFFile)
                            let userImageFile = object.valueForKey("imageFile") as! PFFile
                            userImageFile.getDataInBackgroundWithBlock {
                                (imageData: NSData?, error: NSError?) -> Void in
                                if (error != nil) {
                                    self.showErrorAlert(error!)
                                }else {
                                    friendInfo.image = UIImage(data:imageData!)
                                }
                            }
                            self.friendArray.append(friendInfo)
                        }
                    }
                }
                self.friendsTableView.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func showErrorAlert(error: NSError) {
        
        var errorMessage = error.description
        
        if error.code == 209 {
            NSLog("session token == %@", PFUser.currentUser()!.sessionToken!)
            errorMessage = "セッショントークンが切れました。ログアウトします。"
            PFUser.currentUser()?.delete()
            SVProgressHUD.showSuccessWithStatus("ログアウトしました", maskType: SVProgressHUDMaskType.Black)
            self.dismissViewControllerAnimated(true, completion: nil)
            PFUser.enableRevocableSessionInBackgroundWithBlock { (error: NSError?) -> Void in
                println("Session token deprecated")
            }
        }
        var alertController = UIAlertController(title: "通信エラー", message: errorMessage, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Cancel) {
            action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
        
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
    }
    
    // MARK: TableView DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendArray.count;
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("FriendsCell") as? FriendsCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "FriendCell") as? FriendsCell
        }
        //cell?.name.text = friendArray[indexPath.row] as? String
        cell?.setCell(friendArray[indexPath.row] as! FriendManager)
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    @IBAction func plus() {
        let alert = UIAlertView()
        alert.title = "確認"
        alert.message = "送信しますか？"
        alert.delegate = self
        alert.addButtonWithTitle("送信")
        alert.addButtonWithTitle("キャンセル")
        alert.tag = 2;
        alert.show()
    }
    
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        NSLog("call alertView buttonIndex = %d", buttonIndex)
        if buttonIndex == 0{
            self.performSegueWithIdentifier("toResultViewController", sender: nil)
        }
    }
    
    
    
    @IBAction func back() {
        self.navigationController?.popViewControllerAnimated(true);
    }
    
}
