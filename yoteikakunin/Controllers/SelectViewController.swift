//
//  SelectViewController.swift
//  yoteikakunin
//
//  Created by reina on 2015/05/04.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class SelectViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func plus(){
        let alert = UIAlertView()
        alert.title = "警告"
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
