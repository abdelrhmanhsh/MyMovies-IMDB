//
//  ViewController.swift
//  NetworkSQL
//
//  Created by Abdelrhman Ahmed on 21/04/2022.
//

import UIKit

class DetailsViewController: UIViewController {

    var movie: Movie?
    var tableVCDelegate: DeleteMovieProtocol?
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var weekend: UILabel!
    @IBOutlet weak var gross: UILabel!
    @IBOutlet weak var weeks: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: (movie?.image) ?? "")
        movieImage?.kf.setImage(with: url, placeholder: UIImage(named: "placeholder.jpg"), options: nil, completionHandler: nil)
        
        movieTitle.text = movie?.title
        rank.text = movie?.rank
        weekend.text = movie?.weekend
        gross.text = movie?.gross
        weeks.text = movie?.weeks
        
    }
    
    @IBAction func btnDelete(_ sender: UIBarButtonItem) {
        let alert: UIAlertController = UIAlertController(title: "Are you sure?", message: "You are attempting to delete this movie!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {
            action in
            self.tableVCDelegate?.deleteMovie(id: (self.movie?.id)! as NSString)
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
