//
//  LoginVC.swift
//  FacebookLogin
//
//  Created by eugene golovanov on 12/4/16.
//  Copyright © 2016 eugene golovanov. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKCoreKit

class LoginVC: UIViewController, LoginButtonDelegate {

    
    
    //--------------------------------------------------------------------------------------------
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (FBSDKAccessToken.current() != nil) {
//            // User is already logged in, do work such as go to next view controller.
//            let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-40, height: 44))
//            button.backgroundColor = UIColor.red
//            button.addTarget(self, action: #selector(self.onFacebookLogout(_:)), for: .touchUpInside)
//            button.center = self.view.center
//            button.setTitle("Logout From Facebook", for: .normal)
//            self.view.addSubview(button)
            
            guard let token = FBSDKAccessToken.current().tokenString else {
                print("no token")
                return
            }
            print("TOKEN SAVED = \(token)")
            self.getFacebookGraphAndSegue(token: token)
            
        }
        else {
            let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
            loginButton.center = self.view.center
            loginButton.delegate = self
            self.view.addSubview(loginButton)
        }


    }


    
    //--------------------------------------------------------------------------------------------
    // MARK: - -Facebook Delegate Methods-

    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        print("User Logged In")
        
        switch result {
        case .cancelled:
            print("\n handle cacellation \n")
            break
        case .failed(let error):
            print("error: \(error)")
            break
        case .success(let grantedPermissions, let declinedPermissions, let accessToken):
            print("\nLogged in SUCCESSFULLY!")
            print("\nToken: \(accessToken.authenticationToken)")
            print("\ngrantedPermissions: \(grantedPermissions)")
            print("\ndeclinedPermissions: \(declinedPermissions)")
            
            self.getFacebookGraphAndSegue(token: accessToken.authenticationToken)
            
            break
        }
        

        
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("\n====  Did Logout =====\n")
    }

    
    //--------------------------------------------------------------------------------------------
    // MARK: - Helper

    
    func getFacebookGraphAndSegue(token:String) {
        
        guard let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name, first_name, last_name"], tokenString: token, version: nil, httpMethod: "GET") else {
            print("could not get Facebook user info")
            return
        }
        req.start(completionHandler: { (connection, result, error) in
            if(error == nil) {
                print("result \(result)")
                guard let userInfo = result as? [String: AnyObject] else {print("bad result");return}
                let email = userInfo["email"] as? String ?? ""
                let name = userInfo["name"] as? String ?? ""
                
                print("NAME:\(name)     EMAIL: \(email)")
                self.performSegue(withIdentifier: "loginSegue", sender: userInfo)
            }
            else {
                print("error \(error)")
            }
            
        })

    }

    

    
    //--------------------------------------------------------------------------------------------
    // MARK: - Segue


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue" {
            if let vc = segue.destination as? UserViewController {
                if let info = sender as? [String: AnyObject] {

                    let email = info["email"] as? String ?? ""
                    let name = info["name"] as? String ?? ""
                    let firstName = info["first_name"] as? String ?? ""
                    let lastName = info["last_name"] as? String ?? ""
                    
                    let lbl:String = "\nNAME:\(name)\nEMAIL: \(email)\nfirstName:\(firstName)\nlastName:\(lastName)"
                    print(lbl)
                    vc.info = lbl

                }
            }
        }
    }
    

}
