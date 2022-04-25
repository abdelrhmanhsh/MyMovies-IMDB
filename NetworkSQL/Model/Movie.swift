//
//  Movie.swift
//  NetworkSQL
//
//  Created by Abdelrhman Ahmed on 24/04/2022.
//

import Foundation

class Movie : Decodable{
    
    var id : String?
    var rank : String?
    var title : String?
    var image : String?
    var weekend : String?
    var gross : String?
    var weeks : String?
    
//    enum CodingKeys : String , CodingKey{
//        case id = "id"
//        case rank = "rank"
//        case header = "title"
//        case image = "image"
//        case weekend = "weekend"
//        case gross = "gross"
//        case weeks = "weeks"
//    }
    
}
