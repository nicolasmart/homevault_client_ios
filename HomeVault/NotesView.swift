//
//  NotesView.swift
//  HomeVault
//
//  Created by Nicola Nicolov on 22.04.21.
//  Copyright © 2021 Nicola Nicolov. All rights reserved.
//

import SwiftUI

struct NotesView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
                    ZStack {
                        WebViewContainer(webViewModel: WebViewModel(url: UserDefaults.standard.getLoginInfo(key: "server_ip") + "/notes.php", darkMode: colorScheme == .dark ? "1" : "0"))
                    }
                    .navigationBarTitle(Text("Notes"))
        }
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView()
    }
}
