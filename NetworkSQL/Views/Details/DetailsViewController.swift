//
//  ViewController.swift
//  NetworkSQL
//
//  Created by Abdelrhman Ahmed on 21/04/2022.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {
    
    var viewContext: NSManagedObjectContext!
    var movie = NSManagedObject()
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var weekend: UILabel!
    @IBOutlet weak var gross: UILabel!
    @IBOutlet weak var weeks: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = movie.value(forKey: "title") as! String
        movieTitle.text = title
        
        let movieRank = movie.value(forKey: "rank") as! String
        rank.text = movieRank
        
        let movieWeekend = movie.value(forKey: "weekend") as! String
        weekend.text = movieWeekend
        
        let movieGross = movie.value(forKey: "gross") as! String
        gross.text = movieGross
        
        let movieWeeks = movie.value(forKey: "weeks") as! String
        weeks.text = movieWeeks
        
        let url = URL(string: (movie.value(forKey: "image") as! String))
        movieImage?.kf.setImage(with: url, placeholder: UIImage(named: "placeholder.jpg"), options: nil, completionHandler: nil)
        
    }
    
}
