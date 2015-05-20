//
//  AddFriendViewController.swift
//  yoteikakunin
//
//  Created by Master on 2015/05/18.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class AddFriendViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet var friendsSearchBar: UISearchBar!
    @IBOutlet var resultTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsSearchBar.delegate = self
        friendsSearchBar.placeholder = "ユーザーIDで検索"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back() {
        //self.navigationController?.popToRootViewControllerAnimated(true);
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: SearchBar Delegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        self.view.endEditing(true)
    }
}
