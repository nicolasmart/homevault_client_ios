//
//  WebViewContainer.swift
//  HomeVault
//
//  Created by Nicola Nicolov on 22.04.21.
//  Copyright © 2021 Nicola Nicolov. All rights reserved.
//

import UIKit
import SwiftUI
import WebKit

struct WebViewContainer: UIViewRepresentable {
    @ObservedObject var webViewModel: WebViewModel
    
    func makeCoordinator() -> WebViewContainer.Coordinator {
        Coordinator(self, webViewModel)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.webViewModel.url) else {
            return WKWebView()
        }
        let darkMode = self.webViewModel.darkMode
        let directory = self.webViewModel.directory
                
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let params = [
                "username": UserDefaults.standard.getLoginInfo(key: "username"),
                "password": UserDefaults.standard.getLoginInfo(key: "password"),
                "dark_mode": darkMode,
                "directory": directory
        ]
        let postString = self.getPostString(params: params)
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        webView.navigationDelegate = context.coordinator
        webView.load(request)
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if webViewModel.shouldGoBack {
            uiView.goBack()
            webViewModel.shouldGoBack = false
        }
    }
    
    func getPostString(params:[String:String]) -> String
        {
            var data = [String]()
            for(key, value) in params
            {
                data.append(key + "=\(value)")
                
            }
            return data.map { String($0) }.joined(separator: "&")
        }
}
