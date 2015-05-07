//
//  InputViewController.swift
//  yoteikakunin
//
//  Created by reina on 2015/05/04.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class InputViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


   @IBAction func back() {
    //戻る処理
    self.presentingViewController?.dismissViewControllerAnimated(true, completion:nil)
    }
    
}
