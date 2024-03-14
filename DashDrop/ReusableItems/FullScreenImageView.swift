//
//  FullScreenImageView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/13/24.
//

import SwiftUI
import Kingfisher

struct FullScreenImageView: View {
    let url: URL

    var body: some View {
        KFImage(url)
            .resizable()
            .scaledToFit()
    }
}
