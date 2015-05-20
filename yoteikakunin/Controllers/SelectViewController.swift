//
//  SelectViewController.swift
//  yoteikakunin
//
//  Created by reina on 2015/05/04.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class SelectViewController: UIViewController {
    
    @IBOutlet var friendsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsTableView.layer.borderWidth = 1.0
        friendsTableView.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func plus(){
        let alert = UIAlertView()
        alert.title = "確認"
        alert.message = "送信しますか？"
        alert.delegate = self
        alert.addButtonWithTitle("送信")
        alert.addButtonWithTitle("キャンセル")
        alert.show()
    }
    
    //UIAlertViewDelegateの実装
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        NSLog("call alertView buttonIndex = %d", buttonIndex)
        if buttonIndex == 0{
            //次の画面に遷移するコード
            self.performSegueWithIdentifier("toResultViewController", sender: nil)
        }
    }
    
    @IBAction func back() {
        self.navigationController?.popViewControllerAnimated(true);
    }
    
}
