//
//  AddFriendViewController.swift
//  yoteikakunin
//
//  Created by Master on 2015/05/18.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class AddFriendViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var friendsSearchBar: UISearchBar!
    @IBOutlet var resultTableView: UITableView!
    
    var friendArray = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsSearchBar.delegate = self
        friendsSearchBar.placeholder = "ユーザーIDで検索"
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
        //usersData.whereKey("", equalTo: )
        usersData.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]?, error:NSError?) -> Void in
            
            if error != nil {
                NSLog("%@", error!.description)
            }else {
                for object in objects! {
                    //object.valueForKey("username")
                    
                    var user = PFUser.currentUser()
                    
                    if user?.username == object.valueForKey("username") as? PFUser {
                        NSLog("currentUser == %@", user!.username!)
                    }else {
                        self.friendArray.append(object.valueForKey("username")!)
                    }
                }
                
                self.resultTableView.reloadData()
                SVProgressHUD.dismiss()
            }
            
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
        
        //self.inputField = cell!.viewWithTag(1) as! UITextField
        
        cell?.textLabel?.text = String(format: "%@", friendArray[indexPath.row] as! String)
        
        return cell!
    }
    
    
    @IBAction func back() {
        self.navigationController?.popToRootViewControllerAnimated(true);
        //self.dismissViewControllerAnimated(true, completion: nil)
    }
}
