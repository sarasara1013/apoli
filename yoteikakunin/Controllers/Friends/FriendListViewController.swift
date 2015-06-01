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

    override func viewDidLoad() {
        super.viewDidLoad()
        friendListTableView.dataSource = self
        friendListTableView.delegate = self
        
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
                NSLog("%@", error!.description)
            }else {
                for object in objects! {
                    
                    var user = PFUser.currentUser()
                    if user?.username == object.valueForKey("username") as? PFUser {
                        NSLog("currentUser == %@", user!.username!)
                    }else {
                        self.friendArray.append(object.valueForKey("username")!)
                    }
                }
                self.friendListTableView.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }

    
    // MARK: TableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "FriendCell")
        }
        
        cell?.textLabel!.text = friendArray[indexPath.row] as? String
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    @IBAction func back() {
        //self.navigationController?.popToRootViewControllerAnimated(true);
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
