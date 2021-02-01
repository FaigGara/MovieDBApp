//
//  Movie.swift
//  MovieDBApp
//
//  Created by Faiq on 27.01.2021.
//  Copyright © 2021 Faig Garazade. All rights reserved.
//

import Foundation

struct Movie: Codable {
    var adult = false
    var backdrop_path = ""
    var genre_ids: [Int]
    var id = 0
    var original_language = ""
    var original_title = ""
    var overview = ""
    var popularity = 0.0
    var poster_path = ""
    var release_date = ""
    var title = ""
    var video = false
    var vote_average = 0.0
    var vote_count = 0
}

struct MovieJson {
    var page = 1
//    var movies = [Movie]()
    var results: Any?
    
    static func createMovie(results: String) -> [Movie]? {
        let jsonData = Data(results.utf8)
        let decoder = JSONDecoder()
        do {
            return try decoder.decode([Movie].self, from: jsonData)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
