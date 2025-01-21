//
//  ImageView.swift
//  UserList
//
//  Created by Thibault Giraudon on 21/01/2025.
//

import SwiftUI

struct ImageView: View {
    var user: User
    var size: CGFloat
    var body: some View {
        AsyncImage(url: URL(string: user.picture.thumbnail)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(Circle())
        } placeholder: {
            ProgressView()
                .frame(width: size, height: size)
                .clipShape(Circle())
        }
    }
}

