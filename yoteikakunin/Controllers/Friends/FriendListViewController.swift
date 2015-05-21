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
    var friends: FriendManager! = FriendManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        friendListTableView.delegate = self
        
        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Get data from Parse
    func loadData(){
        var usersData: PFQuery = PFQuery(className: "User")
        usersData.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]?, error:NSError?) -> Void in
            
            if error != nil {
                for object in objects! {
                    object.valueForKey("username")
                }
                
                self.friendListTableView.reloadData()
            }
        }
    }
    
    // MARK: TableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ListCell", forIndexPath: indexPath) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "ListCell")
        }
        
        return cell!
    }
    
    @IBAction func back() {
        //self.navigationController?.popToRootViewControllerAnimated(true);
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
