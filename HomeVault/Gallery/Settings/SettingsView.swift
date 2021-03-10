//
//  SettingsView.swift
//  HomeVault
//
//  Created by Nicola Nicolov on 10.03.21.
//  Copyright © 2021 Nicola Nicolov. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @State private var showingAlert = false
    @State private var loginViewActivated = false
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Image("homevault_logo_big").resizable().scaledToFit().frame(height: 68).padding(.top, 80).padding(.bottom, 4)
                Text("Your data. Your control.").font(.system(size: 19)).padding(.bottom, 30).foregroundColor(.black)
                Text("An app made by Nicola Nicolov, participating on the Bulgarian National IT Olympiad. Designed to help you gain back control over your own data. Designed in Varna.").frame(maxWidth: .infinity, alignment: .leading).font(.system(size: 18)).padding().padding(.horizontal, 2)
                Spacer()
                Text("GPL v3 Open-source license (GitHub@nicolasmart)").frame(maxWidth: .infinity, alignment: .center).multilineTextAlignment(.center).font(.system(size: 18)).padding().padding(.horizontal, 2)
                Button(action: {
                    showingAlert = true
                    
                }) {
                    HStack{
                        Spacer()
                        Text("Sign Out")
                        Spacer()
                    }
                    .padding()
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .background(Color.gray.opacity(0.7))
                    .cornerRadius(40)
                    .padding(.bottom, 110)
                    .padding(.horizontal, 70)
                }.alert(isPresented:$showingAlert) {
                    Alert(
                        title: Text("Sign Out"),
                        message: Text("Are you sure you want to log out of your HomeVault account?"),
                        primaryButton: .cancel(
                            Text("Cancel")
                        ),
                        secondaryButton: .destructive(
                            Text("Log Out"),
                            action: {
                                UserDefaults.standard.logout()
                                isLoggedIn = false
                            }
                        )
                    )
                }
            }.navigationBarHidden(true)
            .navigationBarTitle("")
            .edgesIgnoringSafeArea([.top, .bottom])
            .navigationBarBackButtonHidden(true)
        }
    }
}
