//
//  ContentView.swift
//  MovieDbTest
//
//  Created by Baiao, Francisco Fonseca on 12/08/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State var movies: [Movie] = []
    
    @State private var moviesSection: MoviesEndpoints = .nowPlaying
    
    fileprivate func movieSectionPicker() -> some View {
        return Picker("Select", selection: $moviesSection) {
            Text(MoviesEndpoints.nowPlaying.description).tag(MoviesEndpoints.nowPlaying)
            Text(MoviesEndpoints.popular.description).tag(MoviesEndpoints.popular)
            Text(MoviesEndpoints.topRated.description).tag(MoviesEndpoints.topRated)
            Text(MoviesEndpoints.upcoming.description).tag(MoviesEndpoints.upcoming)
        }.pickerStyle(SegmentedPickerStyle())
    }
    
    var body: some View {
        
        VStack {
            movieSectionPicker()
            
            Text("Hello, world!")
                .onAppear {
                    Api().getNowPlayingMovies() { movies in
                        self.movies = movies
                    }
                }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
