//
//  ViewController.swift
//  FBDemo
//
//  Created by uday on 8/10/17.
//  Copyright © 2017 uday. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {
    
    @IBOutlet weak var btnFBCustom: UIButton!
    @IBOutlet weak var txtView: UITextView!
    
    
    var fbLoggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (FBSDKAccessToken.current() != nil){
            getFBUserData()
        }
    }
    
    @IBAction func onBtnFBCustomPressed(_ sender: Any) {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        if !fbLoggedIn{
            
            
            fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
                if (error == nil){
                    let fbloginresult : FBSDKLoginManagerLoginResult = result!
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        
                        
                    }
                    
                }
            }
        }else{
            fbLoginManager.logOut()
            btnFBCustom.setTitle("Login with Facebook", for: .normal)
            txtView.text = ""
        }
        self.fbLoggedIn = false
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    print(result ?? "")
                    guard let result = result as? [String:Any] else {return}
                    self.txtView.text = result["email"] as! String
                    self.btnFBCustom.setTitle("Logout", for: .normal)
                    self.fbLoggedIn = true
                }
            })
        }
    }
    
}

