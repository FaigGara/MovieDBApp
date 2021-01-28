//
//  ServiceManager.swift
//  MovieDB
//
//  Created by Faiq on 20.01.2021.
//

import UIKit

class ServiceManager: NSObject {
    static var shared: ServiceManager = ServiceManager()
    let basicURL = "https://api.themoviedb.org/3/"
    let apiKey = "fd2b04342048fa2d5f728561866ad52a"
    
    func basePostPethod(urlString: String?, complationHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let auth = basicURL + (urlString ?? "")
        let url = URL(string: auth)
        guard let requestUrl = url else { fatalError() }

        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                // Check for Error
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
            complationHandler(data, response, error)
        }
        task.resume()
    }
    
    func getMovies(pageNum: Int, complationHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        basePostPethod(urlString: "movie/popular?language=en-US&api_key=\(apiKey)&page=\(pageNum)") { (data, response, error) in
            complationHandler(data, response, error)
        }
    }
    
    func downloadImage(path: String, complationHandler: @escaping (_ image: UIImage? ) -> Void) {
        var downloadPhotoTask: URLSessionDownloadTask? = nil
        if let url = URL(string: "https://image.tmdb.org/t/p/w400/" + path) {
            downloadPhotoTask = URLSession.shared.downloadTask(with: url, completionHandler: { location, response, error in
                if let location = location,  let data = try? Data(contentsOf: location) {
                    if let image = UIImage(data: data) {
                        complationHandler(image)
                    }
                }
                complationHandler(nil)
            })
        }
        downloadPhotoTask?.resume()
    }
}
