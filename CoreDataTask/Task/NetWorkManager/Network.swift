//
//  Network.swift
//  Task
//
//  Created by Bhanuja Tirumareddy on 25/06/20.
//  Copyright © 2020 Bhanuja Tirumareddy. All rights reserved.
//

import Foundation
class Network {
    static let Shared = Network()
    func saveUser(url: String, users: [String: Any], completions: @escaping(_ success: String) -> ()) {
        
        guard let url = URL(string: url) else { fatalError("Invalid Url!")}
        var postrequest = URLRequest(url: url)
        postrequest.httpMethod = "POST"
        postrequest.addValue("application/json", forHTTPHeaderField: "Accept")
        postrequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // Body encryption
        do {
            let bodyData = try JSONSerialization.data(withJSONObject: users, options: .prettyPrinted)
            postrequest.httpBody = bodyData
        } catch {
            print("error is : \(error)")
        }
        URLSession.shared.dataTask(with: postrequest){ (data, resp, error) in
            if let  data = data  {
                do {
                    let resp = try JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)
                    print(resp)
                    completions("Success")
                }
                catch {
                    
                }
            } else if let error = error {
                completions(error.localizedDescription)
            }
            
        }.resume()
    }
}

