//
//  SelectViewController.swift
//  yoteikakunin
//
//  Created by reina on 2015/05/04.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class SelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedNumber: Int = 0
    var friendArray = [AnyObject]()
    var selectedFriendsName = [String]()
    
    @IBOutlet var friendsTableView: UITableView!
    @IBOutlet var selectedNumberLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedNumberLabel.text = "0"
        
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        
        /*
        friendsTableView.layer.borderWidth = 1.0
        friendsTableView.layer.borderColor = UIColor.blackColor().CGColor
         */
        
        var nib  = UINib(nibName: "FriendsCell", bundle:nil)
        friendsTableView.registerNib(nib, forCellReuseIdentifier:"FriendsCell")
        
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        //cell?.setCell(friendArray[indexPath.row] as! FriendManager)
        return cell!
    }
    
    // MARK: TableView Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! FriendsCell
        
        let isContain = contains(selectedFriendsName, cell.name.text!)
        if isContain == true {
            let index = find(selectedFriendsName, cell.name.text!)
            selectedFriendsName.removeAtIndex(index!)
        }else {
            selectedFriendsName.append(cell.name.text!)
        }
        
        if cell.checkMark.image == nil {
            cell.checkMark.image = UIImage(named: "selected.png")
            selectedNumber++
        }else {
            cell.checkMark.image = nil
            selectedNumber--
        }
        
        selectedNumberLabel.text = String(selectedNumber)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: AlertView Delegate
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.tag == 2 {
            if buttonIndex == 0 {
                if selectedFriendsName.count > 0 {
                    sendPush()
                    self.performSegueWithIdentifier("toResultViewController", sender: nil)
                }else {
                    let alert = UIAlertView()
                    alert.title = "友だち選択"
                    alert.message = "アポを送信する友だちを選択して下さい"
                    alert.delegate = self
                    alert.addButtonWithTitle("OK")
                    alert.tag = 3
                    alert.show()
                }
            }
        }else if alertView.tag == 3 {
            // Push OK button
        }
    }
    
    
    // MARK: Private
    func loadData(){
        SVProgressHUD.showWithStatus("ロード中", maskType: SVProgressHUDMaskType.Black)
        // Get data from Parse
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
    
    
    @IBAction func back() {
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let finishVC = segue.destinationViewController as! FinishViewController
        finishVC.friendsName = selectedFriendsName
    }
    
    // MARK: Send Push
    func sendPush() {
        //PFPush.sendPushDataToChannelInBackground(, withData: , block: )
        let query = PFQuery(className: "_User")
        
        // TODO: 選択したユーザーをqueryにセットして送信
        query.whereKey("objectId", notEqualTo: PFUser.currentUser()!.objectId!)
        var push: PFPush = PFPush()
        push.setQuery(query)
        var message = String(format: "%@さんからメッセージが届きました。", PFUser.currentUser()!.username!)
        push.setMessage(message)
        push.sendPush(nil)
        println("Push Notification Sent")
    }
}
