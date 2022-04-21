//
//  NetworkManager.swift
//  NetworkSQL
//
//  Created by Abdelrhman Ahmed on 21/04/2022.
//

import Foundation

func fetchResult(complitionHandler: @escaping (MyResult?) -> Void){
    
   let url = URL(string: "https://imdb-api.com/en/API/BoxOffice/k_ztatz119")
    
   guard let newURL = url else{
       print("Error while unwrapping URL")
       return
   }

   let request = URLRequest(url: newURL)
   let session = URLSession(configuration: .default)
   let task = session.dataTask(with: request) { (data, response, error) in
   
       guard let data = data else{
           return
       }
       
       do {
           
           let result = try JSONDecoder().decode(MyResult.self, from: data)
           complitionHandler(result)

       } catch let error {
           print(error.localizedDescription)
           complitionHandler(nil)
       }
   }
    
   task.resume()

}
