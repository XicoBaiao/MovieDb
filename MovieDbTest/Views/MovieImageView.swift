//
//  MovieImage.swift
//  MovieDbTest
//
//  Created by Baiao, Francisco Fonseca on 13/08/2022.
//

import SwiftUI

struct MovieImageView: View {
    
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                AsyncImage(
                    url: movie.backdropURL,
                    content: { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 200, maxHeight: 400)
                    },
                    placeholder: {
                        ProgressView()
                    }
                ).overlay(alignment: .topTrailing) {
                        ZStack {
                            Image(systemName: "star.fill")
                                .resizable()
                                .foregroundColor(.yellow)
                                .aspectRatio(contentMode: .fit)
                            Text("\(movie.voteAverage/2, specifier: "%.1f")")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                                .minimumScaleFactor(0.5)
                                .frame(width: 15, height: 20, alignment: .center)
                                .offset(y:2)
                        }
                        .frame(width: 40, height: 40)
                }
            }
            .aspectRatio(16/9, contentMode: .fit)
            .cornerRadius(8)
            .shadow(radius: 4)
            
        }
    }
}

