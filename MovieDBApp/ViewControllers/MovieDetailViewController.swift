//
//  MovieDetailViewController.swift
//  MovieDBApp
//
//  Created by Faiq on 26.01.2021.
//  Copyright © 2021 Faig Garazade. All rights reserved.
//

import UIKit
import CoreData

class MovieDetailViewController: UIViewController {
    @IBOutlet var lblMovieTitle: UILabel!
    @IBOutlet var txtViewMovieDescription: UITextView!
    @IBOutlet var imgViewMoviePoster: UIImageView!
    var movie: Movie!
    var rightBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rightBarButton = UIBarButtonItem(image: isFav() ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"), style: .done, target: self, action: #selector(clickedStar))
        navigationItem.rightBarButtonItem = rightBarButton
        title = movie.original_title
        prepareViewComponents()
    }
    
    func prepareViewComponents() {
        lblMovieTitle.text = movie.title
        txtViewMovieDescription.text = movie.overview
        ServiceManager.shared.downloadImage(path: movie.poster_path, complationHandler: { image in
            if let image = image {
                DispatchQueue.main.async {
                    self.imgViewMoviePoster.image = image
                }
            }
        })
    }
    
    @objc func clickedStar() {
        save()
        rightBarButton.image = isFav() ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
    }
    
    func save() {
        
        guard let managedContext = moc() else { return }
        
        let results = NSFetchRequest<FavMovie>(entityName: "FavMovie")
        results.predicate =  NSPredicate(format: "db_id == %d", movie.id)
        if let favMovies = try? managedContext.fetch(results) {
            if favMovies.count > 0, let fav = favMovies.first {
                managedContext.delete(fav)
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
                return
            }
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "FavMovie",
                                                in: managedContext)!
        let movieEntity = NSManagedObject(entity: entity, insertInto: managedContext)
        movieEntity.setValue(movie.id, forKeyPath: "db_id")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func isFav() -> Bool {
        guard let managedContext = moc() else { return false }
        let results = NSFetchRequest<FavMovie>(entityName: "FavMovie")
        results.predicate =  NSPredicate(format: "db_id == %d", movie.id)
        if let favMovies = try? managedContext.fetch(results) {
            if favMovies.count > 0 {
                return true
            }
        }
        return false
    }
    
    func moc() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        return appDelegate.persistentContainer.viewContext
    }
    
}
