//
//  UserDefaults+UniversalRW.swift
//  HomeVault
//
//  Created by Nicola Nicolov on 9.03.21.
//  Copyright © 2021 Nicola Nicolov. All rights reserved.
//

import Foundation

extension UserDefaults{

    func isLoggedIn()-> Bool {
        if object(forKey: "username") != nil {
            return true
        }
        return false
    }

    func setLoginInfo(serverip: String, username: String, password: String){
        set(serverip, forKey: "server_ip")
        set(username, forKey: "username")
        set(password, forKey: "password")
        //synchronize()
    }

    func getLoginInfo(key: String) -> String{
        return string(forKey: key) ?? ""
    }
}
