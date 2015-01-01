//
//  ViewController.swift
//  Counter
//
//  Created by Michael Hulet on 12/24/14.
//  Copyright (c) 2014 Michael Hulet. All rights reserved.
//

import UIKit
import Foundation
import Security
import iAd
class MHViewController: UIViewController {
    let cache = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var resetButton: UIButton!
    @IBAction func adjustCount(){
        if stepper!.value == 0{
            resetButton!.hidden = true
        }
        else if resetButton!.hidden{
            resetButton!.hidden = false
        }
        let formatter = NSNumberFormatter()
        formatter.usesGroupingSeparator = true
        countLabel!.text = formatter.stringFromNumber(NSNumber(double: stepper!.value))
    }
    @IBAction func reset(){
        if stepper!.value != 0{
            let prompt = UIAlertController(title: "Are you sure?", message: "Are you sure you want to reset your count to 0? This cannot be undone.", preferredStyle: .Alert)
            prompt.addAction(UIAlertAction(title: "No", style: .Cancel, handler:nil))
            prompt.addAction(UIAlertAction(title: "Yes", style: .Destructive, handler: { (action: UIAlertAction!) -> Void in
                self.stepper!.value = 0
                self.adjustCount()
            }))
            presentViewController(prompt, animated: true, completion: nil)
        }
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        canDisplayBannerAds = true
        stepper!.maximumValue = Double.infinity
        stepper!.value = cache.doubleForKey("count")
        adjustCount()
        //We have to toggle whether or not the status bar is hidden so it won't hide in landscape mode
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .None)
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
        //Detect when the iAd banner shows, so we can adjust accordingly
        resetButton!.addObserver(self, forKeyPath: "center", options: .New, context: nil)
    }
    override func viewWillDisappear(animated: Bool){
        super.viewWillDisappear(animated)
        cache.setDouble(stepper!.value, forKey: "count")
    }
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>){
        //Fires when the iAd banner shows
        let frame = UIScreen.mainScreen().bounds.size
        stepper!.center = CGPointMake(frame.width / 2, frame.height / 2)
    }
}