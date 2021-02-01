//
//  MovieListViewController.swift
//  MovieDB
//
//  Created by Faiq on 25.01.2021.
//

import UIKit

class MovieListViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    private var isGrid: Bool = false
    private var movieListVC: MovieListViewController?
    var movies = [Movie]()
    var page = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "movieCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        ServiceManager.shared.getMovies(pageNum: 1) { (data, response, error) in
            if error == nil && data != nil  {
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            self.page = json["page"] as! Int
                            if let  results = json["results"] as? [Any] {
                                let decoder = JSONDecoder()
                                let jsonData = try! JSONSerialization.data(withJSONObject: results, options: .prettyPrinted)
                                if let jsonDataString = String(data: jsonData, encoding: .utf8){
                                    let finalJsonData = Data(jsonDataString.utf8)
                                    self.movies.append(contentsOf: try decoder.decode([Movie].self, from: finalJsonData))
                                }
                                
                            }
                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                }
            }
            DispatchQueue.main.async(execute: {
                self.collectionView.reloadData()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

     @IBAction func listTypeTapped(_ sender: UIBarButtonItem) {
         if !isGrid {
            sender.image = UIImage(named: "list")
         }else {
             sender.image = UIImage(named: "grid")
         }
         
         isGrid = !isGrid
        collectionView.reloadData()
     }

}

extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        cell.isGrid = isGrid
        cell.movie = self.movies[indexPath.row]
        cell.lblMovieName.text = self.movies[indexPath.row].original_title
        cell.setImage(path: self.movies[indexPath.row].backdrop_path)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGrid {
            return CGSize(width: collectionView.frame.size.width / 2 - 7.5, height: collectionView.frame.size.width - 100 )
        }
        return CGSize(width: collectionView.frame.size.width - 10, height: collectionView.frame.size.width/2 - 30 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(identifier: "MovieDetailViewController") as! MovieDetailViewController
        detailVC.movie = self.movies[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
