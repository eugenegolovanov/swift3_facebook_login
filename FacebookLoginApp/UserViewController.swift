//
//  UserViewController.swift
//  FacebookLoginApp
//
//  Created by eugene golovanov on 12/4/16.
//  Copyright © 2016 eugene golovanov. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKCoreKit

class UserViewController: UIViewController {

    @IBOutlet weak var labelUserInfo: UILabel!
    var info:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelUserInfo.text = info
    }

    @IBAction func onLogout(_ sender: UIButton) {
        //Facebook Logout
        print("on Facebook Logout Tapped")
        let loginManager = LoginManager()
        loginManager.logOut()
        self.performSegue(withIdentifier: "logouSegue", sender: nil)
    }


}

