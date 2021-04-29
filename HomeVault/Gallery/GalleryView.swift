//
//  GalleryView.swift
//  HomeVault
//
//  Created by Nicola Nicolov on 9.03.21.
//  Copyright © 2021 Nicola Nicolov. All rights reserved.
//

import SwiftUI

struct GalleryView: View {
    @State private var serverip = ""
    @State private var username = ""
    @State private var password = ""
    var directory = "/"
    
    @State var image:UIImage = UIImage()
    @State var showImage = false
    @State var selectedImage = ""
    
    @State private var photos = [String]() 
    
    var body: some View {
        NavigationView {
            ScrollView {
                if #available(iOS 14.0, *) {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 4)) {
                        ForEach(photos, id: \.self) { photo in
                            ZStack {
                            AsyncImage(url: URL(string: photo)!,
                                       placeholder: { ProgressView() },
                                           image: { Image(uiImage: $0).resizable() })
                            } .clipped()
                            .aspectRatio(1, contentMode: .fit)
                            .onTapGesture {
                                selectedImage = photo
                                showImage = true
                            }
                        }
                    }
                    NavigationLink(destination: ImagePreview(selectedImage: selectedImage),
                                   isActive: $showImage, label: { EmptyView() })
                } else {
                    // Fallback on earlier versions
                }
            }.navigationBarTitle("Gallery")
        }.onAppear(perform: getJsonImages)
    }
    
    func getJsonImages() {
        serverip = UserDefaults.standard.getLoginInfo(key: "server_ip")
        username = UserDefaults.standard.getLoginInfo(key: "username")
        password = UserDefaults.standard.getLoginInfo(key: "password")
        //serverip = UserDefaults.standard.string(forKey: "serverip")!
        //username = UserDefaults.standard.string(forKey: "username")!
        //password = UserDefaults.standard.string(forKey: "password")!
        
        
        let serverUrl = URL(string: serverip + "/mobile_methods/gallery_fetch.php")
        
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
            
            print("response = \(String(describing: response))")
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print ("dataString= \(dataString)")
                if dataString.contains("listing_success_key") {
                    let fromIndex = dataString.index(dataString.startIndex, offsetBy: 20)
                    let jsonString = String(dataString[fromIndex...])
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: jsonString.data(using: .utf8)!, options: [])
                        let jsonArray = jsonResponse as? [String]
                        
                        for jsonElement in jsonArray ?? [] {
                            photos.append(serverip + "/users/" + username + "/photos/" + jsonElement)
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
        //isFileLoading![name] = true
        
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

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
    }
}
