//
//  LoginView.swift
//  HomeVault
//
//  Created by Nicola Nicolov on 8.03.21.
//  Copyright © 2021 Nicola Nicolov. All rights reserved.
//

import SwiftUI
import Foundation

struct LoginView: View {
    @State private var serverip = ""
    @State private var username = ""
    @State private var password = ""
    @State var homeViewActivated: Bool = false
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            VStack() {
                VStack() {
                    NavigationLink(destination: HomeView(), isActive: $homeViewActivated) {
                        EmptyView()
                    }
                    HStack {
                        Spacer()
                    }
                    Image("homevault_logo_big").resizable().scaledToFit().frame(height: 68).padding(.top).padding(.bottom, 4)
                    Text("Your data. Your control.").padding(.bottom, 8).foregroundColor(.black)
                    TextField("Cloud Server IP or Domain", text: self.$serverip)
                        .disableAutocorrection(true)
                        .padding(8)
                        .background(Color.white.opacity(0.4))
                        .cornerRadius(4)
                        .padding()
                        .foregroundColor(.black)
                        .colorScheme(.light)
                    TextField("Username", text: self.$username)
                        .padding(8)
                        .background(Color.white.opacity(0.4))
                        .cornerRadius(4)
                        .padding()
                        .foregroundColor(.black)
                        .colorScheme(.light)
                    SecureField("Password", text: self.$password)
                        .padding(8)
                        .background(Color.white.opacity(0.4))
                        .cornerRadius(4)
                        .padding()
                        .foregroundColor(.black)
                        .colorScheme(.light)
                    Button(action: {
                        UserDefaults.standard.setLoginInfo(serverip: serverip, username: username, password: password)
                        
                        let serverUrl = URL(string: "http://" + serverip + "/mobile_methods/auth.php")
                        
                        var request = URLRequest(url:serverUrl!)
                                
                        request.httpMethod = "POST"
                                
                        let postString = "username=" + username + "&password=" + password
                        
                        request.httpBody = postString.data(using: String.Encoding.utf8);
                        
                        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                            
                            if error != nil
                            {
                                print("error=\(String(describing: error))")
                                showingAlert = true
                                return
                            }
                            
                            print("response = \(String(describing: response))")
                            
                            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                                if dataString.contains("login_success_app_handler_key") {
                                    homeViewActivated = true
                                }
                                else {
                                    showingAlert = true
                                }
                            }
                            
                        }
                        
                        task.resume()
                        
                        
                    }) {
                        HStack{
                            Spacer()
                            Text("Login")
                            Spacer()
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color("AccentColor"))
                        .cornerRadius(40)
                    }.alert(isPresented:$showingAlert) {
                        Alert(
                            title: Text("Login failed"),
                            message: Text("Make sure the server IP and login credentials are correct"),
                            dismissButton: .default(Text("Close"))
                        )
                    }
                    .padding(.vertical)
                    .padding(.horizontal, 70)
                }.background(Color.white.opacity(0.82)).cornerRadius(25).padding(.horizontal)
            }.background(Image("homevault_login_backdrop"))
            .navigationBarHidden(true)
            .navigationBarTitle("")
            .edgesIgnoringSafeArea([.top, .bottom])
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
