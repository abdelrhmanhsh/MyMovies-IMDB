//
//  DBManager.swift
//  NetworkSQL
//
//  Created by Abdelrhman Ahmed on 21/04/2022.
//

import Foundation
import SQLite3

class DBManager {
    
    static let DBInstance = DBManager()
    
    let fileURL: URL
    let part1DbPath: String
    
    private init(){
        fileURL = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("movies.sqlite")
        
        part1DbPath = fileURL.path
    }

    func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer?
        
        if sqlite3_open(part1DbPath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(part1DbPath)")
            return db
        } else {
            print("Unable to open database.")
            return nil
        }
    }
    
    let createTableString = """
        CREATE TABLE movies(
            id char (255) primary key not null,
            rank char (255),
            title char (255),
            image char (255),
            weekend char (255),
            gross char (255),
            weeks char (255))
        """
    
    func createTable(db: OpaquePointer){
        
        var createTableStatement: OpaquePointer?
        
        if sqlite3_prepare(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("\nMovies table created.")
            } else {
                print("\nMovies table is not created.")
            }
        } else {
            print("\nCREATE TABLE statement is not prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    let insertStatementString = """
        INSERT INTO movies (id, rank, title, image, weekend, gross, weeks)
        VALUES (?, ?, ?, ?, ?, ? , ?);
    """
    
    func insert(db: OpaquePointer, movie: Movie) {
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            let id = movie.id as? NSString
            let rank = movie.rank as? NSString
            let title = movie.title as? NSString
            let image = movie.image as? NSString
            let weekend = movie.weekend as? NSString
            let gross = movie.gross as? NSString
            let weeks = movie.weeks as? NSString
            
            sqlite3_bind_text(insertStatement, 1, id?.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, rank?.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, title?.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, image?.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, weekend?.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, gross?.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, weeks?.utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\nSuccessfully inserted row.")
            } else {
                print("\nCould not insert row.")
            }
            
        } else {
            print("\nINSERT statement is not prepared.")
        }
        
        sqlite3_finalize(insertStatement)
    }

    let queryStatementString = "SELECT * FROM movies"

    func query(db: OpaquePointer) -> [Movie] {
        
        var queryStatement: OpaquePointer?
        var movieList: [Movie]? = []
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                guard let idResult = sqlite3_column_text(queryStatement, 0) else {
                    print("id nil")
                    return []
                }
                
                guard let rankResult = sqlite3_column_text(queryStatement, 1) else {
                    print("rank nil")
                    return []
                }
                
                guard let titleResult = sqlite3_column_text(queryStatement, 2) else {
                    print("title nil")
                    return []
                }
                
                guard let imageResult = sqlite3_column_text(queryStatement, 3) else {
                    print("image nil")
                    return []
                }
                
                guard let weekendResult = sqlite3_column_text(queryStatement, 4) else {
                    print("weekend nil")
                    return []
                }
                
                guard let grossResult = sqlite3_column_text(queryStatement, 5) else {
                    print("gross nil")
                    return []
                }
                
                guard let weeksResult = sqlite3_column_text(queryStatement, 6) else {
                    print("weeks nil")
                    return []
                }
                
                let id = String(cString: idResult)
                let rank = String(cString: rankResult)
                let title = String(cString: titleResult)
                let image = String(cString: imageResult)
                let weekend = String(cString: weekendResult)
                let gross = String(cString: grossResult)
                let weeks = String(cString: weeksResult)
                
                let movie = Movie()
                
                movie.id = id
                movie.title = title
                movie.rank = rank
                movie.image = image
                movie.weekend = weekend
                movie.gross = gross
                movie.weeks = weeks
                
                print("\(title)")
                movieList?.append(movie)
                
            }
            
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        
        sqlite3_finalize(queryStatement)
        return movieList!
    }
    
    let deleteStatementStirng = "DELETE FROM movies WHERE id = ?"
    
    func deleteMovieById(db: OpaquePointer, id: NSString) {
        var deleteStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(deleteStatement, 1, id.utf8String, -1, nil)
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
    }
    
    let deleteAllStatementStirng = "DELETE FROM movies"
    
    func deleteAll(db: OpaquePointer) {
        var deleteStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, deleteAllStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
    }
    
}
