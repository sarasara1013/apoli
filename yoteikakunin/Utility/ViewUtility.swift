//
//  ViewUtility.swift
//  yoteikakunin
//
//  Created by Master on 2015/05/18.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class ViewUtility: NSObject {
    class func findFirstResponder(view: UIView) -> UIView {
        
        var returnView: UIView?
        
        if view.isFirstResponder() {
            return view
        }
        
        for subView in view.subviews {
            if subView.isFirstResponder != nil {
                return subView as! UIView
            }
            
            var responder = self.findFirstResponder(subView as! UIView)
            if let responder = responder as UIView? {
                return responder
            }
        }
        
        return returnView!
    }
}

// UIResponder Extention
extension UIResponder {
    
    //Class var not supported in 1.0
    private struct CurrentFirstResponder {
        static var currentFirstResponder: UIResponder?
    }
    private class var currentFirstResponder: UIResponder? {
        get { return CurrentFirstResponder.currentFirstResponder }
        set(newValue) { CurrentFirstResponder.currentFirstResponder = newValue }
    }
    
    class func getCurrentFirstResponder() -> UIResponder? {
        currentFirstResponder = nil
        UIApplication.sharedApplication().sendAction("findFirstResponder", to: nil, from: nil, forEvent: nil)
        return currentFirstResponder
    }
    
    func findFirstResponder() {
        UIResponder.currentFirstResponder = self
    }
}
