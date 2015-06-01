//
//  FriendsCell.swift
//  yoteikakunin
//
//  Created by Master on 2015/06/01.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class FriendsCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.iconImage.backgroundColor = UIColor.redColor()
        self.iconImage.layer.cornerRadius = 30
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(friend :FriendManager) {
        self.name.text = friend.name
        var err: NSError?
        self.iconImage.image = friend.image
    }
}
