//
//  Response.swift
//  NetworkSQL
//
//  Created by Abdelrhman Ahmed on 21/04/2022.
//

import Foundation

class MyResult : Decodable {
    var items : [Movie]
    var errorMessage : String?
}
