//
//  MovieDetailView.swift
//  MovieDbTest
//
//  Created by Baiao, Francisco Fonseca on 14/08/2022.
//

import SwiftUI

struct MovieDetailView: View {
    
    @StateObject var moviesApi = MoviesApi()
    
    let movie: Movie
    
    fileprivate func MovieImage() -> some View {
        return AsyncImage(
            url: movie.backdropURL,
            content: { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            },
            placeholder: {
                ProgressView()
            }
        )
    }
    
    fileprivate func TitleAndDescription() -> some View {
        return VStack {
            Text(movie.title.uppercased())
                .font(.largeTitle)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
                .padding(.vertical, 8)
                .foregroundColor(.black)
                .background()
            Text(movie.overview)
                .font(.headline)
                .multilineTextAlignment(.leading)
                .foregroundColor(.gray)
                .padding(.horizontal)
        }
        
    }
    
    fileprivate func Rating() -> some View {
        return HStack(alignment: .center, spacing: 10.0) {
            Text(Converters().convertMovieRating(rating: movie.voteAverage))
            StarsView(rating: movie.voteAverage/2, maxRating: 5)
            Spacer()
            Text("\(movie.voteCount) votes")
        }.padding(.horizontal, 30)
            .frame(width: UIScreen.main.bounds.width*0.7, height: 60, alignment: .center)
    }
    
    var body: some View {
            ZStack {
                Color.white.ignoresSafeArea()
                    .opacity(0.5)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center, spacing: 20) {
                        
                        MovieImage()
                        TitleAndDescription()
                        Rating()
                        if !moviesApi.recommendedMovies.isEmpty {
                            Text("If you liked \(movie.title), we've got some recommendations for you")
                                .font(.title2)
                                .fontWeight(.medium)
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                                .frame(alignment: .center)
                            RecommendedMoviesCarousel(recommendedMovies: moviesApi.recommendedMovies)
                        }
                    }
                    
                    .navigationBarTitle(movie.title, displayMode: .inline)
                }
            }.onAppear {
                moviesApi.getRecommendedMovies(id: movie.id)
            }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movie: Movie(id: 1, title: "Obsidian",backdropPath: "https://image.tmdb.org/t/p/w500/k4JIHyAXaGHwAwT7y5Skd17f0Wl.jpg", posterPath: "", overview: "Lightyear is a 2022 American computer-animated science fiction action-adventure film produced by Walt Disney Pictures and Pixar Animation Studios, and distributed by Walt Disney Studios Motion Pictures. The film is a spin-off of the Toy Story film series, and the fifth overall installment in the franchise. It centers on the character Buzz Lightyear, although instead of following the cast of toy characters from the main franchise, the film presents itself as part of a franchise within the Toy Story films in which Lightyear is a character. It was co-written and directed by Angus MacLane in his feature directorial debut, produced by Galyn Susman, and stars Chris Evans as the voice of the titular character, with Keke Palmer, Peter Sohn, Taika Waititi, Dale Soules, James Brolin, and Uzo Aduba in supporting roles.", voteAverage: 4.2, voteCount: 544, runtime: 163))
    }
}
