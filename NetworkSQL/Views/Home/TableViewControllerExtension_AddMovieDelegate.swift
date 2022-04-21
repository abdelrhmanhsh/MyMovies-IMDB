//
//  TableViewControllerExtension_AddMovieDelegate.swift
//  NetworkSQL
//
//  Created by Abdelrhman Ahmed on 21/04/2022.
//

import Foundation

extension TableViewController: AddMovieProtocol {
    
    func addMovie(movie: Movie) {
        movieList?.append(movie)
        self.tableView.reloadData()
    }
    
}
