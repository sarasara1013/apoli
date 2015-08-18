//
//  FriendListViewController.swift
//  yoteikakunin
//
//  Created by Master on 2015/05/18.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class FriendListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var friendListTableView: UITableView!
    var friendArray = [AnyObject]()
    var friendNameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendListTableView.dataSource = self
        friendListTableView.delegate = self
        
        /*
        friendListTableView.layer.borderWidth = 1.0
        friendListTableView.layer.borderColor = UIColor.blackColor().CGColor
        */
        
        var nib  = UINib(nibName: "FriendsCell", bundle:nil)
        friendListTableView.registerNib(nib, forCellReuseIdentifier:"FriendsCell")
        
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // Get data from Parse
    func loadData(){
        SVProgressHUD.showWithStatus("ロード中", maskType: SVProgressHUDMaskType.Black)
        
        var friendsData: PFQuery = PFQuery(className: "_User")
        friendsData.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error != nil {
                self.showErrorAlert(error!)
            }else {
                for object in objects! {
                    if object.valueForKey("username") as? String == PFUser.currentUser()?.username {
                        self.friendNameArray = object.valueForKey("following") as! Array
                        
                        for following in self.friendNameArray {
                            var userData: PFQuery = PFQuery(className: "_User")
                            userData.whereKey("username", equalTo: following)
                            userData.findObjectsInBackgroundWithBlock {
                                (objects: [AnyObject]?, error: NSError?) -> Void in
                                if error != nil {
                                    NSLog("Error == %@", error!)
                                }else {
                                    for friend in objects! {
                                        var friendInfo = FriendManager()
                                        friendInfo.name = friend.valueForKey("username") as! String
                                        let userImageFile = friend.valueForKey("imageFile") as! PFFile
                                        friendInfo.image = UIImage(data:userImageFile.getData()!)
                                        self.friendArray.append(friendInfo)
                                    }
                                }
                                self.friendListTableView.reloadData()
                                SVProgressHUD.dismiss()
                            }
                        }
                    }
                }
                // self.friendListTableView.reloadData()
                // SVProgressHUD.dismiss()
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
        
        var friendInfo = friendArray[indexPath.row] as! FriendManager
        cell?.iconImage.image = friendInfo.image
        cell?.name.text = friendInfo.name
        cell?.iconImage.layer.cornerRadius = cell!.iconImage.bounds.width / 2
        cell?.iconImage.layer.masksToBounds = true
        cell?.clipsToBounds = true

        // TEST: cell?.textLabel!.text = friendNameArray[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    @IBAction func back() {
        //self.navigationController?.popToRootViewControllerAnimated(true);
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // TODO: フォロー解除
}
