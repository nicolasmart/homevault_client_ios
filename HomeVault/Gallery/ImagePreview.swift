//
//  ImagePreview.swift
//  HomeVault
//
//  Created by Nicola Nicolov on 9.03.21.
//  Copyright © 2021 Nicola Nicolov. All rights reserved.
//

import SwiftUI

struct ImagePreview: View {
    @State var lastScaleValue: CGFloat = 1.0
    var selectedImage = "http://google.com/images/branding/googlelogo/2x/googlelogo_color_92x30dp.png"
    
    var body: some View {
        if #available(iOS 14.0, *) {
            ZoomableScrollView{
            AsyncImage(url: URL(string: selectedImage)!,
                       placeholder: { ProgressView() },
                       image: { Image(uiImage: $0).resizable() }).aspectRatio(contentMode: .fit)
            }
                .navigationBarTitle(Text(""), displayMode: .inline)
        } else {
            // Fallback on earlier versions
        }
    }
}

struct ImagePreview_Previews: PreviewProvider {
    static var previews: some View {
        ImagePreview()
    }
}
