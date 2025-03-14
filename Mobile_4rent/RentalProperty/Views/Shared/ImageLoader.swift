//
//  ImageLoader.swift
//  RentalProperty
//
//  Created by joeyin on 2025/3/13.
//

import SwiftUI

struct ImageLoader: View {
    let url: String
    let width: CGFloat
    let height: CGFloat
    
    @State var id = UUID()
    
    private func handleLoadFailure() {
        id = UUID()
    }
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: width, height: height)
                case .success(let image):
                    image.resizable()
                        .scaledToFill()
                        .frame(width: width, height: height)
                case .failure:
                    VStack {
                        
                    }
                    .frame(width: width, height: height)
                    .onAppear() {
                        handleLoadFailure()
                    }
                @unknown default:
                    EmptyView()
            }
        }
        .id(id)
    }
}
