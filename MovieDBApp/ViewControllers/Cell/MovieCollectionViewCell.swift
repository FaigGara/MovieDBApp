//
//  MovieCollectionViewCell.swift
//  MovieDBApp
//
//  Created by Faiq on 26.01.2021.
//  Copyright © 2021 Faig Garazade. All rights reserved.
//

import UIKit
import CoreData

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet var movieImageView: UIImageView!
    @IBOutlet var favImageView: UIImageView!
    @IBOutlet var lblMovieName: UILabel!
    @IBOutlet var superView: UIView!
    var movie: Movie!
    var isGrid: Bool = false {
        didSet {
            if isGrid {
                lblMovieName.textAlignment = .center
                superView?.layer.cornerRadius = 5
                movieImageView?.layer.cornerRadius = 5
            }else {
                lblMovieName.textAlignment = .left
                superView?.layer.cornerRadius = 0
                movieImageView?.layer.cornerRadius = 0
            }
        }
    }
    
    func setImage(path: String) {
        ServiceManager.shared.downloadImage(path: path, complationHandler: { image in
            if let image = image {
                DispatchQueue.main.async {
                    self.movieImageView.image = image
                }
            }
        })
        DispatchQueue.main.async {
            self.displayOrHideStar()
        }
    }
    
    func displayOrHideStar() {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let results = NSFetchRequest<FavMovie>(entityName: "FavMovie")
        results.predicate =  NSPredicate(format: "db_id == %d", movie.id)
        if let favMovies = try? managedContext.fetch(results) {
            if favMovies.count > 0 {
                favImageView.isHidden = false
            }else {
                favImageView.isHidden = true
            }
            return
        }
        favImageView.isHidden = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
