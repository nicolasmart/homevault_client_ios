//
//  WebViewModel.swift
//  HomeVault
//
//  Created by Nicola Nicolov on 22.04.21.
//  Copyright © 2021 Nicola Nicolov. All rights reserved.
//

import Foundation
class WebViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var canGoBack: Bool = false
    @Published var shouldGoBack: Bool = false
    @Published var title: String = ""
    
    var url: String
    var darkMode: String
    
    init(url: String, darkMode: String) {
        self.url = url
        self.darkMode = darkMode
    }
}
