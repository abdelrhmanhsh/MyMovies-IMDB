//
//  TableViewControllerExtension_DeleteMovieDelegate.swift
//  NetworkSQL
//
//  Created by Abdelrhman Ahmed on 21/04/2022.
//

import Foundation

extension TableViewController: DeleteMovieProtocol {
    
    func deleteMovie(id: NSString) {
        let db = obj.openDatabase()
        obj.deleteMovieById(db: db!, id: id)
        movieList = []
        movieList = obj.query(db: db!)
        self.tableView.reloadData()
    }
    
}
