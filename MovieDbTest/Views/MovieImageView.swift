//
//  MovieImage.swift
//  MovieDbTest
//
//  Created by Baiao, Francisco Fonseca on 13/08/2022.
//

import SwiftUI
import CachedAsyncImage

struct MovieImageView: View {
    
    let movie: Movie
    @State var loadedImage: Image = Image(systemName: "photo")
    @State var isImageLoaded: Bool = false
    
    fileprivate func StarView() -> some View {
        return ZStack {
            Image(systemName: "star.fill")
                .resizable()
                .foregroundColor(.yellow)
                .aspectRatio(contentMode: .fit)
            Text(Converters().convertMovieRating(rating: movie.voteAverage))
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.black)
                .minimumScaleFactor(0.5)
                .frame(width: 15, height: 20, alignment: .center)
                .offset(y:2)
        }
        .frame(width: 40, height: 40)
    }
    
    fileprivate func MovieImage() -> some View {
        return CachedAsyncImage(url: movie.backdropURL) { state in
            switch state {
            case .empty:
                ZStack {
                    Rectangle()
                        .frame(maxWidth: 200, maxHeight: 400)
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 200, maxHeight: 400)
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 200, maxHeight: 400)
            @unknown default:
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 200, maxHeight: 400)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                MovieImage()
                .overlay(alignment: .topTrailing) {
                    StarView()
                }
                .aspectRatio(16/9, contentMode: .fit)
                .cornerRadius(8)
                .shadow(radius: 4)
                
            }
        }
    }
}

