//
//  MovieListView.swift
//  MovieDbTest
//
//  Created by Baiao, Francisco Fonseca on 12/08/2022.
//

import SwiftUI

struct MovieListView: View {
    
    var movies: [Movie] = []
    var isSearchView : Bool = false
    @EnvironmentObject var realmManager: RealmManager
    @State var showHiddenMovies: Bool = false
    @State var tapFilter = false
    
    var filteredHiddenMovies: [Movie] {
        let hiddenMovieIDs = realmManager.hiddenMovies.map { $0.id }
        return movies.filter{ !hiddenMovieIDs.contains($0.id)}
    }
    
    fileprivate func FavoriteHideButtons(movie: Movie) -> some View{
        return VStack(spacing:15) {
            Button(action: {
                if realmManager.favoriteMovies.contains(where: { $0.id == movie.id}) {
                    realmManager.deleteFavoriteMovie(id: movie.id)
                } else {
                    realmManager.addFavoriteMovie(movie: movie)
                }
            }){
                Image(systemName: realmManager.favoriteMovies.contains(where: { $0.id == movie.id}) ? "heart.fill" : "heart")
                    .foregroundColor(.red)
            }.buttonStyle(PlainButtonStyle())
                .padding(.horizontal)
            if isSearchView {
                Button(action: {
                    if realmManager.hiddenMovies.contains(where: { $0.id == movie.id}) {
                        realmManager.showHiddenMovieFromSearchResults(movie: movie)
                    } else {
                        realmManager.hideMovieFromSearchResults(movie: movie)
                    }
                }){
                    Image(systemName: realmManager.hiddenMovies.contains(where: { $0.id == movie.id}) ? "eye.slash" : "eye")
                }.buttonStyle(PlainButtonStyle())
                    .padding(.horizontal)
            }
        }
        
    }
    
    fileprivate func TitleSubtitleStack(movie: Movie) -> some View {
        return VStack(alignment: .center, spacing: 10) {
            Text(movie.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
            Text(movie.overview)
                .font(.body)
                .foregroundColor(.secondary)
                .minimumScaleFactor(0.7)
                .lineLimit(4)
        }
    }
    
    fileprivate func HideMoviesFilterButton() -> some View {
        return ZStack {
            Image(systemName: "eye")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .offset(x: showHiddenMovies ? -90 : 0, y : showHiddenMovies ? -90 : 0)
                .rotation3DEffect(Angle(degrees: showHiddenMovies ? 20 : 0), axis: (x: 10, y: -10, z: 0))
                .frame(width: 45, height: 45, alignment: .center)
            
            Image(systemName: "eye.slash")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .offset(x: showHiddenMovies ? 0 : 90, y : showHiddenMovies ? 0 : 90)
                .rotation3DEffect(Angle(degrees: showHiddenMovies ? 0 : 20), axis: (x: -10, y: 10, z: 0))
                .frame(width: 45, height: 45, alignment: .center)
        }.frame(width: 75, height: 75)
            .background(
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color.white, Color.white.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    Circle()
                        .stroke(Color.clear, lineWidth: 10)
                        .shadow(color: Color.white.opacity(0.7), radius: 3, x: -5, y: -5)
                    
                    Circle()
                        .stroke(Color.clear, lineWidth: 10)
                        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 3, y: 3)
                }
                
            )
            .clipShape(Circle())
            .shadow(color: Color.white, radius: 20, x: -20, y: -20)
            .shadow(color: Color.black.opacity(0.4), radius: 20, x: 20, y: 20)
            .offset(x: -30, y: -30)
            .scaleEffect(tapFilter ? 1.2 : 1)
            .onTapGesture {
                self.tapFilter = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.tapFilter = false
                }
                self.showHiddenMovies.toggle()
            }
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            List(showHiddenMovies ? movies : filteredHiddenMovies, id: \.id) { movie in
                NavigationLink(destination: MovieDetailView(movie: movie)){
                    VStack {
                        HStack {
                            FavoriteHideButtons(movie: movie)
                            
                            MovieImageView(movie: movie)
                            
                            TitleSubtitleStack(movie: movie)
                        }
                        .frame(height: 100)
                    }
                }
            }
            .listStyle(.plain)
            
            if isSearchView
            {
                HideMoviesFilterButton()
            }
            
        }
        
    }
}

