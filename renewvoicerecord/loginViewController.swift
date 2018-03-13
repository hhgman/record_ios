//
//  ViewController.swift
//  renewvoicerecord
//
//  Created by Kylee on 2018. 1. 31..
//  Copyright © 2018년 Kylee. All rights reserved.
//

import UIKit
import Alamofire


extension String {
    func search(of target: String) -> Range<Index>? {
        // search result places in between `leftIndex`and `rightIndex`
        var leftIndex = startIndex
        while true {
            //First, move your cursur to target letter's first of `leftIndex` to match it
            guard self[leftIndex] == target[target.startIndex] else {
                leftIndex = index(after:leftIndex)
                if leftIndex >= endIndex { return nil }
                continue
            }
            // From rigt target letter  increases range to `rightIndex' to figure out match or not
            var rightIndex = index(after:leftIndex)
            var targetIndex = target.index(after:target.startIndex)
            while self[rightIndex] == target[targetIndex] {
              // if it is right range
                guard distance(from:leftIndex, to:rightIndex) < target.characters.count - 1
                    else {
                        return leftIndex..<index(after:rightIndex)
                }
                rightIndex = index(after:rightIndex)
                targetIndex = target.index(after:targetIndex)
                // if it is not right range
                if rightIndex >= endIndex {
                    return nil
                }
            }
            leftIndex = index(after:leftIndex)
        }
    }
}



class loginViewController: UIViewController {
    // setting outlet for each textfield and button
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var loginErrorLb: UILabel!
    
    func getuserInfo(){
        let url = URL(string: "http://165.132.120.188:8000/userinfo/")
        let headers: HTTPHeaders = [
            "Authorization":"Token \(UserDefaults.standard.string(forKey: "access_token")!)",
        ]

        Alamofire.request(url!, method: .get, headers: headers).responseString(encoding: String.Encoding.utf8){ response in
            
            let str = response.result.value!
            let preferences =  UserDefaults.standard
            // split response from server to get right information
            var tempSplit = str.components(separatedBy: "\"gender\":\"")
            var genderSplit = tempSplit[1].components(separatedBy: "\",\"birth\":\"")
            preferences.set(genderSplit[0], forKey: "gender")
            var birthSplit = genderSplit[1].components(separatedBy: "\",\"id_number\":\"")
            preferences.set(birthSplit[0], forKey: "birth")
            var idSplit = birthSplit[1].components(separatedBy: "\",\"name\":\"")
            preferences.set(idSplit[0], forKey: "id_number")
            var nameSplit = idSplit[1].components(separatedBy: "\",\"recordings\":")
            preferences.set(nameSplit[0], forKey: "name")
        }
    }
    
    func saveAccessToken(access_token: String, token_type:String, refresh_token:String, scope: String){

        let preferences =  UserDefaults.standard
        print("saveAccessToken:\(access_token)")
        preferences.set(access_token, forKey: "access_token")
        preferences.set(token_type, forKey:"token_type")
        preferences.set(refresh_token,forKey:"refresh_token")
        preferences.set(scope,forKey:"scope")
        //Checking the preference is saved or not
        //didSave(preferences:preferences)

        func getAccessToken()->String {
            let preferenes = UserDefaults.standard
            if preferences.string(forKey: "access_token") != nil {
                let access_token = preferences.string(forKey: "access_token")
                return access_token!}
            else { return ""
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        usernameTextField.text = UserDefaults.standard.string(forKey: "username")
        passwordTextField.text = UserDefaults.standard.string(forKey: "password")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
// when button touch action comes out it will do below functions
    @IBAction func loginBtnPressed(_ sender: Any) {

        let url = URL(string: "http://165.132.120.188:8000/api-token-auth/")

        // new declare for username and password And set 'preference' to 
        let username = usernameTextField.text
        let password = passwordTextField.text
        let preference = UserDefaults.standard
        preference.set(username, forKey: "username")
        preference.set(password, forKey: "password")
        
        let json = [
            "username": username!,
            "password": password!
        ]
        
        Alamofire.request(url!, method: .post, parameters:json).responseString { response in
    
            let str = response.result.value!
            
            let start = str.index(str.startIndex, offsetBy: 10)
            let end = str.index(str.endIndex, offsetBy: -2)
            let range = start..<end
            let token = str[range]
            
            
            self.saveAccessToken(access_token: String(token), token_type: "String", refresh_token: "unknown", scope: "scope")
            self.getuserInfo()
            
            
            if let r = str.search(of:"token")  {
                self.performSegue(withIdentifier: "goToWelcome", sender: self)
            }
            else {
                self.loginErrorLb.text = "아이디 혹은 비밀번호를 확인해주세요"
            }
        }
    }
}

