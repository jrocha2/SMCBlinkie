//
//  AuthenticationViewController.swift
//  SMCBlinkie
//
//  Created by John Rocha on 9/12/15.
//  Copyright (c) 2015 John Rocha and Jenna Wilson. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {

    var user = ""
    @IBAction func authenticate(sender: UIButton) {
        user = sender.currentTitle!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
            if (segue.identifier == "adminSegue") {
                var svc = segue!.destinationViewController as! ViewController;
                if (user == "Admin") {
                    svc.toPass = true
                } else {
                    svc.toPass = false
                }
                
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
