//
//  TableViewController.swift
//  NetworkSQL
//
//  Created by Abdelrhman Ahmed on 21/04/2022.
//

import UIKit
import Kingfisher
import Network
import CoreData

class TableViewController: UITableViewController {

    var movieList: [NSManagedObject] = []
    
    var viewContext: NSManagedObjectContext!
    let indicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        viewContext = appDelegate.persistentContainer.viewContext
        
        let monitor = NWPathMonitor()

        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                // Connected
                print("Internet is available")
                self.getMoviesFromApi()
            }
            else {
                // Not Connected
                print("Internet is NOT available")
                self.getMoviesFromDB()
            }
        }

        monitor.start(queue: DispatchQueue.global(qos: .background))
        
        
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        
        indicator.startAnimating()
    }
    
    func getMoviesFromApi(){
        
        deleteAllMovies()
        
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
                self?.addMovieToDB(movieResponse: movie)
                
            }
            
            self?.getMoviesFromDB()
            
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//            }
            
        }
        
    }

    func getMoviesFromDB() -> Int{
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "MovieResponse")
        do {
            movieList = try viewContext.fetch(fetch)
        } catch {
            print("Error fetching movies")
        }
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
            self.tableView.reloadData()
        }
        
        return movieList.count
    }
    
    func addMovieToDB(movieResponse: Movie){
        let entity = NSEntityDescription.entity(forEntityName: "MovieResponse", in: viewContext)
        let movie = NSManagedObject(entity: entity!, insertInto: viewContext)
        
        movie.setValue(movieResponse.id, forKey: "id")
        movie.setValue(movieResponse.title, forKey: "title")
        movie.setValue(movieResponse.image, forKey: "image")
        movie.setValue(movieResponse.rank, forKey: "rank")
        movie.setValue(movieResponse.gross, forKey: "gross")
        movie.setValue(movieResponse.weekend, forKey: "weekend")
        movie.setValue(movieResponse.title, forKey: "weeks")
        
        do {
            try viewContext.save()
        } catch {
            print("Error saving movie")
        }
    }
    
    func deleteAllMovies(){
        
        let moviesCount = getMoviesFromDB()
        print("moviesCount \(moviesCount)")
        
        if(moviesCount > 0){
            for i in 0...moviesCount-1 {
                viewContext.delete(movieList[i])
                
                do {
                    try viewContext.save()
                } catch {
                    print("Error deleting movie")
                }
            }
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let title = movieList[indexPath.row].value(forKey: "title") as! String
        cell.textLabel!.text = title
        
        let imageUrl = movieList[indexPath.row].value(forKey: "image") as! String
        let url = URL(string: imageUrl)
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
            
            print("deleting \(movieList[indexPath.row].value(forKey: "title"))")
            
            viewContext.delete(movieList[indexPath.row])
            
            do {
                try viewContext.save()
                movieList.remove(at: indexPath.row)
            } catch {
                print("Error deleting movie")
            }
            
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
        let movie = movieList[self.tableView.indexPathForSelectedRow!.row]
        let detailsVC = segue.destination as! DetailsViewController
        detailsVC.movie = movie
    }

}
