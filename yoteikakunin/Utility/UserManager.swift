//
//  UserManager.swift
//  yoteikakunin
//
//  Created by Master on 2015/05/05.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class UserManager: NSObject {
    class var sharedInstance: UserManager {
        struct Static {
            static let instance: UserManager = UserManager()
        }
        return Static.instance
    }
    
    override init() {
        
    }
}
