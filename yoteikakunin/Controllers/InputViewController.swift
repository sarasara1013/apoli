//
//  InputViewController.swift
//  yoteikakunin
//
//  Created by reina on 2015/05/04.
//  Copyright (c) 2015年 srrn. All rights reserved.
//

import UIKit

class InputViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    var listArray = [String]()
    var locationManager: CLLocationManager!
    
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var timeTextField: UITextField!
    @IBOutlet var placeTextField: UITextField!
    @IBOutlet var mapPinButton: UIButton!
    @IBOutlet var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (locationManager == nil) {
            locationManager = CLLocationManager()
        }
        locationManager.delegate = self
        
        dateTextField.delegate = self
        timeTextField.delegate = self
        placeTextField.delegate = self
        
        placeTextField.adjustsFontSizeToFitWidth = true;
        // FIXME: Can't adjust width size
        placeTextField.minimumFontSize = 0.2
        
        let tapGesture = UITapGestureRecognizer(
            target: self, action: "tapGesture:")
        self.view.addGestureRecognizer(tapGesture)

        self.initializeDateTextFieldWithDatePicker()
        self.initializeTimeTextFieldWithDatePicker()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updatePlace:", name: "updatePlace", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: TextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func initializeDateTextFieldWithDatePicker() {
        var datePicker = UIDatePicker(frame: CGRectZero)
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.minuteInterval = 5
        datePicker.backgroundColor = UIColor.whiteColor()
        datePicker.addTarget(self, action: Selector("dateUpdated:"), forControlEvents: UIControlEvents.ValueChanged)
        dateTextField.inputView = datePicker
    }
    
    func initializeTimeTextFieldWithDatePicker() {
        var datePicker = UIDatePicker(frame: CGRectZero)
        datePicker.datePickerMode = UIDatePickerMode.Time
        datePicker.minuteInterval = 5
        datePicker.backgroundColor = UIColor.whiteColor()
        datePicker.addTarget(self, action: Selector("timeUpdated:"), forControlEvents: UIControlEvents.ValueChanged)
        timeTextField.inputView = datePicker
    }
    
    func dateUpdated(datePicker: UIDatePicker) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        dateTextField.text = formatter.stringFromDate(datePicker.date)
    }
    
    func timeUpdated(datePicker: UIDatePicker) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH時mm分"
        timeTextField.text = formatter.stringFromDate(datePicker.date)
    }
    
    
    //MARK: Private
    @IBAction func back() {
        //戻る処理
        self.presentingViewController?.dismissViewControllerAnimated(true, completion:nil)
    }
    
    @IBAction func getCurrentPrace() {
        
        SVProgressHUD.showWithStatus("現在地の取得中...", maskType: SVProgressHUDMaskType.Black)
        
        let locationManager = INTULocationManager.sharedInstance()
        locationManager.requestLocationWithDesiredAccuracy(INTULocationAccuracy.City,
            timeout: 10.0,
            block: { (currentLocation:CLLocation!, achievedAccuracy:INTULocationAccuracy, status:INTULocationStatus) -> Void in
                
                GeoUtility().reverseGeocoding(currentLocation.coordinate)
                
                switch (status) {
                case .Success:
                    
                    break
                case .TimedOut:
                    self.showAlert()
                default:
                    break
                }
                
                SVProgressHUD.dismiss()
        })
    }
    
    func updatePlace(notification: NSNotificationCenter) {
        self.placeTextField.text = notification.valueForKey("object") as! String
        self.placeTextField.setNeedsDisplay()
    }
    
    func showAlert() {
        
        var alertController = UIAlertController(title: "タイムアウト", message: "通信がタイムアウトしました。電波状況等を再確認してリトライして下さい。", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Cancel) {
            action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // Close Keyboards when tap outside itselfs
    func tapGesture(sender: UITapGestureRecognizer){
        for view in self.view.subviews {
            if view is UITextField {
                let textField = view as! UITextField
                if(textField.isFirstResponder()) {
                    textField.resignFirstResponder()
                    return
                }
            }else if view is UITextView {
                let textView = view as! UITextView
                if(textView.isFirstResponder()) {
                    textView.resignFirstResponder()
                    return
                }
            }
        }
    }
}
