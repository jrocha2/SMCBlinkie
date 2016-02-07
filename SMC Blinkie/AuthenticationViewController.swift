//
//  AuthenticationViewController.swift
//  SMC Blinkie
//
//  Created by John Rocha on 12/21/15.
//  Copyright © 2015 John Rocha. All rights reserved.
//

import UIKit
import Firebase

class AuthenticationViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    var ref: Firebase!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Firebase(url: "https://smcblinkie.firebaseio.com/")
        // Setup delegates
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        // Attempt to sign in silently, this will succeed if
        // the user has recently been authenticated
        
        GIDSignIn.sharedInstance().signInSilently()
        authenticateWithGoogle()
        
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
    
    // Wire up to a button tap
    func authenticateWithGoogle() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func signOut() {
        GIDSignIn.sharedInstance().signOut()
        ref.unauth()
    }
    
    // Implement the required GIDSignInDelegate methods
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
        withError error: NSError!) {
            if (error == nil) {
                // Auth with Firebase
                ref.authWithOAuthProvider("google", token: user.authentication.accessToken, withCompletionBlock: { (error, authData) in
                    // User is logged in!
                    print("Logged IN!")
                })
            } else {
                // Don't assert this error it is commonly returned as nil
                print("\(error.localizedDescription)")
            }
    }
    
    // Implement the required GIDSignInDelegate methods
    // Unauth when disconnected from Google
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
        withError error: NSError!) {
            ref.unauth();
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
