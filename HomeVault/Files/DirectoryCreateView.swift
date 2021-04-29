//
//  DirectoryCreateView.swift
//  HomeVault
//
//  Created by Nicola Nicolov on 9.03.21.
//  Copyright © 2021 Nicola Nicolov. All rights reserved.
//

import SwiftUI

struct DirectoryCreateView: View {
    @Binding var isPresented: Bool
    @State private var folder_name = ""
    
    var directory = ""
    
    var body: some View {
        NavigationView {
            VStack{
                Text("The folder will be created in the currently selected directory.").frame(maxWidth: .infinity, alignment: .leading).font(.system(size: 18)).padding().padding(.horizontal, 2)
                TextField("Folder Name", text: self.$folder_name).font(.system(size: 18)).padding().background(Color.black.opacity(0.1)).cornerRadius(7).padding(.horizontal)
                Spacer()
            }.navigationBarTitle(Text("New Folder"), displayMode: .inline)
            .navigationBarItems(leading:
                 Button("Cancel") {
                    isPresented = false
                 },
            trailing:
                 Button("Create") {
                    let serverUrl = URL(string: UserDefaults.standard.getLoginInfo(key: "server_ip") + "/mobile_methods/file_create_dir.php")
                    var request = URLRequest(url:serverUrl!)
                    request.httpMethod = "POST"
                    let postString = "username=" + UserDefaults.standard.getLoginInfo(key: "username") + "&password=" + UserDefaults.standard.getLoginInfo(key: "password") + "&directory=" + directory + folder_name
                    request.httpBody = postString.data(using: String.Encoding.utf8)
                    
                    let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                        
                        if error != nil
                        {
                            print("error=\(String(describing: error))")
                            return
                        }
                        
                        isPresented = false
                        
                    }
                    
                    task.resume()
                 }
            )
        }
    }
}

