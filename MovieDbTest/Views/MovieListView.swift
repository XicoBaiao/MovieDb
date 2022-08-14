//
//  MovieListView.swift
//  MovieDbTest
//
//  Created by Baiao, Francisco Fonseca on 12/08/2022.
//

import SwiftUI

struct MovieListView: View {

    var movies: [Movie] = []
    
    @EnvironmentObject var realmManager: RealmManager
    
    var body: some View {
        List(movies, id: \.id) { movie in
            NavigationLink(destination: MovieDetailView(movie: movie)){
                VStack {
                    HStack {
                        Button(action: {
                            if realmManager.favoriteMovies.contains(where: { $0.id == movie.id}) {
                                realmManager.deleteFavoriteMovie(id: movie.id)
                            } else {
                                realmManager.addFavoriteMovie(movie: movie)
                            }
                        }) {
                            Image(systemName: realmManager.favoriteMovies.contains(where: { $0.id == movie.id}) ? "heart.fill" : "heart")
                                .foregroundColor(.red)
                                            }.buttonStyle(PlainButtonStyle())
                                            .padding(.horizontal)
                        
                        MovieImageView(movie: movie)
                        let extractedExpr: VStack<TupleView<(some View, some View)>> = VStack(alignment: .center, spacing: 10) {
                            Text(movie.title)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            Text(movie.overview)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .minimumScaleFactor(0.7)
                                .lineLimit(4)
                        }
                        extractedExpr
                    }
                    .frame(height: 100)
                }
                
            }
        }
        .listStyle(.plain)
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
    }
}
