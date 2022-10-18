//
//  NetworkManager.swift
//  notesapp
//
//  Created by Rehan Sarwar on 10/12/22.
//  Copyright © 2020 Confiz. All rights reserved.
//

import Foundation

final class NetworkManager {

  private let domainUrlString = "https://reqres.in/api/"
  
    func login(req: [String: String], completionHandler: @escaping (LoginRes) -> Void) {
      let url = URL(string: domainUrlString + "login")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
       
         do {
               request.httpBody = try JSONSerialization.data(withJSONObject: req, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
           } catch let error {
               print(error.localizedDescription)
           }

    let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
      if let error = error {
        let res = LoginRes(token: "", error: "unexpected error \(error)")
         completionHandler(res)
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
          let res = LoginRes(token: "", error: "unexpected status code: \(String(describing: response))")
                 completionHandler(res)
          print("Error with the response, unexpected status code: \(String(describing: response))")
        return
      }

      if let data = data,
        let loginRes = try? JSONDecoder().decode(LoginRes.self, from: data) {
        completionHandler(loginRes)
      }
    })
    task.resume()
  }
}
