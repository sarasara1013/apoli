//
//  AddFriendViewController.swift
//  yoteikakunin
//
//  Created by Master on 2015/05/18.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class AddFriendViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // TODO: サーチ機能
    @IBOutlet var friendsSearchBar: UISearchBar!
    @IBOutlet var resultTableView: UITableView!
    
    var friendArray = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // friendsSearchBar.delegate = self
        // friendsSearchBar.placeholder = "ユーザーIDで検索"
        resultTableView.dataSource = self
        resultTableView.delegate = self
        
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
                    if user?.username == object.valueForKey("username") as? String {
                        NSLog("currentUser == %@", user!.username!)
                    }else {
                        NSLog("object == %@", object as! PFUser)
                        var friendInfo = FriendManager()
                        friendInfo.name = object.valueForKey("username") as! String
                        if object["imageFile"] != nil {
                            let userImageFile = object.valueForKey("imageFile") as! PFFile
                            friendInfo.image = UIImage(data:userImageFile.getData()!)
                            self.friendArray.append(friendInfo)
                        }
                    }
                }
                self.resultTableView.reloadData()
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
    
    
    // MARK: SearchBar Delegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        NSLog("searching ... %@", searchText)
        var findUsers: PFQuery = PFUser.query()!;
        findUsers.whereKey("username",  equalTo: searchText)
        findUsers.findObjectsInBackgroundWithBlock {
            (objects:[AnyObject]?, error:NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        var user = object as! PFUser
                        self.friendArray.append(user.username!)
                    }
                }
                self.resultTableView.reloadData()
            } else {
                println("There was an error")
            }
        }
        
        //self.friendArray.append()
        self.resultTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        self.view.endEditing(true)
    }
    
    // MARK: TableView DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "FriendCell")
        }
        
        cell?.imageView?.layer.cornerRadius = 30
        cell?.imageView?.layer.masksToBounds = true
        cell?.clipsToBounds = true
        
        //self.inputField = cell!.viewWithTag(1) as! UITextField
        var friendInfo = friendArray[indexPath.row] as! FriendManager
        cell?.imageView?.image = friendInfo.image
        cell?.textLabel?.text = friendInfo.name
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.followFriend(indexPath)
        // self.unfollowFriend(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    @IBAction func back() {
        self.navigationController?.popToRootViewControllerAnimated(true);
        // self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func followFriend(indexPath: NSIndexPath) {
        var query: PFQuery = PFQuery(className: "_User")
        SVProgressHUD.showWithStatus("友だち登録中...")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            for object in (objects as! [PFObject]) {
                if(error == nil) {
                    if object.valueForKey("username") as? String == PFUser.currentUser()?.username {
                        var friendInfo = self.friendArray[indexPath.row] as! FriendManager
                        object.addUniqueObject(friendInfo.name, forKey: "following")
                        object.saveInBackgroundWithBlock { (succeeded, error) -> Void in
                            if succeeded == true {
                                SVProgressHUD.showSuccessWithStatus("友だち登録しました")
                            }else {
                                NSLog("エラー %@", error!.description)
                            }
                        }
                    }else{
                        NSLog("エラー %@", error!.description)
                        // SVProgressHUD.showErrorWithStatus(error?.description)
                    }
                }
            }
        }
    }
    
    // TODO: フォロー解除
    func unfollowFriend(indexPath: NSIndexPath) {
        var query: PFQuery = PFQuery(className: "_User")
        SVProgressHUD.showWithStatus("友だち解除中...")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            for object in (objects as! [PFObject]) {
                if(error == nil){
                    if object.valueForKey("username") as? String == PFUser.currentUser()?.username {
                        var friendInfo = self.friendArray[indexPath.row] as! FriendManager
                        object.removeObject(friendInfo.name, forKey: "following")
                            object.saveInBackgroundWithBlock { (succeeded, error) -> Void in
                                if succeeded == true {
                                    SVProgressHUD.showSuccessWithStatus("友だち登録を解除しました")
                                }
                            }
                    }
                }else{
                    SVProgressHUD.showErrorWithStatus(error?.description)
                }
            }
        }
    }
    
    // TODO: TableViewCellと全体のデザインの調整
}
