//
//  TableViewController.swift
//  NetworkSQL
//
//  Created by Abdelrhman Ahmed on 21/04/2022.
//

import UIKit
import Kingfisher

class TableViewController: UITableViewController {

    var movieList: [Movie]? = []
    
    let obj = DBManager.DBInstance
    let db: OpaquePointer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMovies()
    }
    
    func getMovies(){
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        
        indicator.startAnimating()
        
        let db = obj.openDatabase()
        obj.createTable(db: db!)
        obj.deleteAll(db: db!)
        
        fetchResult { [weak self] (result) in
            
            for i in 0...(((result?.items.count)!)-1) {
                
                let movie = Movie()
                
                movie.id = result?.items[i].id
                movie.title = result?.items[i].title
                movie.rank = result?.items[i].rank
                movie.image = result?.items[i].image
                movie.weekend = result?.items[i].weekend
                movie.gross = result?.items[i].gross
                movie.weeks = result?.items[i].weeks
                
                print(result?.items[i].title ?? "")
                self?.obj.insert(db: db!, movie: movie)
                
            }
            
            self?.movieList = self?.obj.query(db: db!)
            print(self?.movieList?.count ?? 0)
            
            DispatchQueue.main.async {
                indicator.stopAnimating()
                self?.tableView.reloadData()
            }
            
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel!.text = movieList?[indexPath.row].title
        
        let url = URL(string: movieList?[indexPath.row].image ?? "")
        cell.imageView?.kf.setImage(with: url, placeholder: UIImage(named: "placeholder.jpg"), options: nil, completionHandler: nil)
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let db = obj.openDatabase()
            
            obj.deleteMovieById(db: db!, id: (movieList?[indexPath.row].id) as! NSString)
            print("\(movieList?[indexPath.row].title) was deleted!")
            movieList?.remove(at: indexPath.row)
            DispatchQueue.main.async {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let movie: Movie = movieList![self.tableView.indexPathForSelectedRow!.row]
        print("selected movie: \(movie.title)")
        let detailsVC = segue.destination as! DetailsViewController
        detailsVC.movie = movie
        detailsVC.tableVCDelegate = self
    }

}
