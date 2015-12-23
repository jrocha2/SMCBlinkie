//
//  AuthenticationViewController.swift
//  SMC Blinkie
//
//  Created by John Rocha on 12/21/15.
//  Copyright © 2015 John Rocha. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func adminButtonPressed() {
        AppData.sharedInstance.isAdmin = true
    }
    
    @IBAction func studentButtonPressed() {
        AppData.sharedInstance.isAdmin = false
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
