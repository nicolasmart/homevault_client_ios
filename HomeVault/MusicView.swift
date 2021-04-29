//
//  MusicView.swift
//  HomeVault
//
//  Created by Nicola Nicolov on 29.04.21.
//  Copyright © 2021 Nicola Nicolov. All rights reserved.
//

import SwiftUI

struct MusicView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
                    ZStack {
                        WebViewContainer(webViewModel: WebViewModel(url: UserDefaults.standard.getLoginInfo(key: "server_ip") + "/music.php", darkMode: colorScheme == .dark ? "1" : "0"))
                    }
                    .navigationBarTitle(Text("Music"))
        }
    }
}

struct MusicView_Previews: PreviewProvider {
    static var previews: some View {
        MusicView()
    }
}
