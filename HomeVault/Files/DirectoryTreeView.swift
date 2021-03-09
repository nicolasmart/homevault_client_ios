//
//  DirectoryTreeView.swift
//  HomeVault
//
//  Created by Nicola Nicolov on 8.03.21.
//  Copyright © 2021 Nicola Nicolov. All rights reserved.
//

import SwiftUI

struct DirectoryTreeView: View {
    @State private var serverip = ""
    @State private var username = ""
    @State private var password = ""
    var directory = "/"
    
    @State private var folderNames = [String]()
    @State private var fileNames = [String]()
    
    @State private var documentPathUrl = NSURL()
    @State private var filesToShare = [Any]()
    
    var navigationTitleText = "File Storage"
    @State private var isFileLoading:[String:Bool]? = [:]
    
    @State private var showingFolderCreateSheet = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(folderNames, id: \.self) { folder in
                    NavigationLink(destination: SubdirectoryTreeView(directory: directory + folder + "/", navigationTitleText: folder)){
                        HStack {
                            Image(systemName: "folder")
                            Text(folder).font(.system(size: 18))
                        }
                    }
                }
                ForEach(fileNames, id: \.self) { file in
                    Button (action: {
                        downloadSelected(url: URL(string: "http://" + serverip + "/mobile_methods/file_download.php")!, name: file)
                        
                    }) {
                        HStack {
                            Image(systemName: "doc")
                                .padding(.horizontal, 4.3)
                            Text(file).font(.system(size: 18))
                            Spacer()
                            if #available(iOS 14.0, *) {
                                if isFileLoading?[file] == true {
                                    HStack{
                                        ProgressView()
                                    }
                                }
                            }
                        }
                    }
                }
                Button(action: {
                       showingFolderCreateSheet = true
                }) {
                    HStack {
                        Image(systemName: "plus").padding(.horizontal, 4.3)
                        Text("New Folder").font(.system(size: 18))
                        Spacer()
                    }
                }
                .sheet(isPresented: $showingFolderCreateSheet, onDismiss: {
                    getJsonDirs()
                }) {
                    DirectoryCreateView(isPresented: $showingFolderCreateSheet, directory: directory)
                }
            }
            .navigationBarTitle(navigationTitleText)
        }.onAppear(perform: getJsonDirs)
    }
    
    func getJsonDirs() {
        serverip = UserDefaults.standard.getLoginInfo(key: "server_ip")
        username = UserDefaults.standard.getLoginInfo(key: "username")
        password = UserDefaults.standard.getLoginInfo(key: "password")
        //serverip = UserDefaults.standard.string(forKey: "serverip")!
        //username = UserDefaults.standard.string(forKey: "username")!
        //password = UserDefaults.standard.string(forKey: "password")!
        
        fileNames.removeAll()
        folderNames.removeAll()
        
        let serverUrl = URL(string: "http://" + serverip + "/mobile_methods/file_fetch_dir.php")
        
        var request = URLRequest(url:serverUrl!)
                
        request.httpMethod = "POST"
                
        let postString = "username=" + username + "&password=" + password + "&directory=" + directory
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil
            {
                print("error=\(String(describing: error))")
                //showingAlert = true
                return
            }
            
            //print("response = \(String(describing: response))")
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                if dataString.contains("listing_success_key") {
                    let fromIndex = dataString.index(dataString.startIndex, offsetBy: 20)
                    let jsonString = String(dataString[fromIndex...])
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: jsonString.data(using: .utf8)!, options: [])
                        let jsonArray = jsonResponse as? [[String: Any]]
                        
                        for jsonElement in jsonArray ?? [] {
                            if let name = jsonElement["dirname"] as? String {
                                folderNames += [name]
                            } else if let name = jsonElement["filename"] as? String {
                                fileNames += [name]
                            }
                        }
                        return
                    } catch {
                        print(error)
                    }
                    
                }
                else {
                    //showingAlert = true
                }
            }
            
        }
        task.resume()
    }
    
    func downloadSelected(url: URL, name:String){
        isFileLoading![name] = true
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
                
        let postString = "username=" + username + "&password=" + password + "&directory=" + directory + "/" + name
        print(postString)

        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                }
                do{
                    let largeImageData = try Data(contentsOf: tempLocalUrl)
                    let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    let fileURL = documentsDirectoryURL.appendingPathComponent(name);
                    
                    do {
                        try largeImageData.write(to: fileURL, options: [.atomic])

                        filesToShare = [Any]()
                        filesToShare.append(fileURL)
                        
                        isFileLoading![name] = false
                        
                        DispatchQueue.main.async {
                            let shareActivity = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
                            if let vc = UIApplication.shared.windows.first?.rootViewController{
                                shareActivity.popoverPresentationController?.sourceView = vc.view
                                shareActivity.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height, width: 0, height: 0)
                                shareActivity.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
                                vc.present(shareActivity, animated: true, completion: nil)
                            }
                        }
                    } catch {
                        print("Random error")
                    }
                    
                    
                    
                    
                }catch{
                    print("error");
                }
                
                
                
                do {
                    
                } catch (let writeError) {
                    
                }
                
            } else {
                print("Failure: %@", error?.localizedDescription);
            }
        }
        task.resume()
    }
}

struct DirectoryTreeView_Previews: PreviewProvider {
    static var previews: some View {
        DirectoryTreeView()
    }
}
