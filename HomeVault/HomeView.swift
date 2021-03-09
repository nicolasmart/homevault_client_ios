//
//  ContentView.swift
//  HomeVault
//
//  Created by Nicola Nicolov on 8.03.21.
//  Copyright © 2021 Nicola Nicolov. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection){
            DirectoryTreeView()
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "folder")
                        Text("Files")
                    }
                }
                .tag(0)
                .navigationBarHidden(true)
                .navigationBarTitle("")
                .edgesIgnoringSafeArea([.top, .bottom])
                .navigationBarBackButtonHidden(true)
            GalleryView()
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "photo")
                        Text("Gallery")
                    }
                }
                .tag(1)
                .navigationBarHidden(true)
                .navigationBarTitle("")
                .edgesIgnoringSafeArea([.top, .bottom])
                .navigationBarBackButtonHidden(true)
            Text("Third View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "music.note.list")
                        Text("Music")
                    }
                }
                .tag(2)
                .navigationBarHidden(true)
                .navigationBarTitle("")
                .edgesIgnoringSafeArea([.top, .bottom])
                .navigationBarBackButtonHidden(true)
            Text("Fourth View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "square.and.pencil")
                        Text("Notes")
                    }
                }
                .tag(3)
                .navigationBarHidden(true)
                .navigationBarTitle("")
                .edgesIgnoringSafeArea([.top, .bottom])
                .navigationBarBackButtonHidden(true)
            Text("Fifth View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }
                .tag(4)
                .navigationBarHidden(true)
                .navigationBarTitle("")
                .edgesIgnoringSafeArea([.top, .bottom])
                .navigationBarBackButtonHidden(true)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
