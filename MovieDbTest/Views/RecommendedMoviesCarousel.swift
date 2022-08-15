//
//  RecommendedMoviesCarousel.swift
//  MovieDbTest
//
//  Created by Baiao, Francisco Fonseca on 15/08/2022.
//

import Foundation
import SwiftUI
import CachedAsyncImage

struct RecommendedMoviesCarousel: View {
    
    var recommendedMovies: [Movie] = []
    
    @State private var isActive = false
    
    fileprivate func RecommendedMovieImage(recommendedMovie: Movie) -> some View {
        return CachedAsyncImage(url: recommendedMovie.backdropURL) { state in
            switch state {
            case .empty:
                ZStack {
                    Rectangle()
                        .frame(width:250)
                        .background(Color.gray)
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 250)
                    .clipped()
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(white:0.4)))
                    .shadow(radius: 3)
            case .failure:
                Rectangle()
                    .frame(width:250)
            @unknown default:
                Rectangle()
                    .frame(width:250)
            }
        }
    }
    
    var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(recommendedMovies) { recommendedMovie in
                        GeometryReader { proxy in
                            let scale = getScale(proxy: proxy)
                            VStack(spacing: 8) {
                                RecommendedMovieImage(recommendedMovie: recommendedMovie)
                                StarsView(rating: recommendedMovie.voteAverage/2, maxRating: 5)
                                    .frame(width: 150, height: 20, alignment: .center)
                                Text(recommendedMovie.title)
                                    .font(.system(size: 16, weight: .semibold))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.black)
                                
                            }
                            .scaleEffect(.init(width:scale, height: scale))
                            .animation(.easeOut(duration: 1))
                            .padding(.vertical)
                        }
                        .frame(width: 275, height: 300)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 32)
                    }
                    Spacer()
                        .frame(width:16)
                }
            }.padding(.bottom, 50)
    }
    
    func getScale(proxy: GeometryProxy) -> CGFloat {
        let midPoint: CGFloat = 125
        
        let viewframe = proxy.frame(in: CoordinateSpace.global)
        
        var scale: CGFloat = 1.0
        let deltaXAnimationThreshold: CGFloat = 125
        
        let diffFromCenter = abs(midPoint - viewframe.origin.x - deltaXAnimationThreshold / 2)
        
        if diffFromCenter < deltaXAnimationThreshold {
            scale = 1 + (deltaXAnimationThreshold - diffFromCenter) / 500
        }
        
        return scale
    }
    
}
