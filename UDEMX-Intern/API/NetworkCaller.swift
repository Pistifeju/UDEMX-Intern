//
//  NetworkCaller.swift
//  UDEMX-Intern
//
//  Created by István Juhász on 2023. 02. 13..
//

import Foundation

class NetworkCaller {
    
    static let shared = NetworkCaller()
    private let iceCreamsURLString = "https://raw.githubusercontent.com/udemx/hr-resources/master/icecreams.json"
    private let extrasURLString = "https://raw.githubusercontent.com/udemx/hr-resources/master/extras.json"
    private init () {}
    
    func getIceCreams(completion: @escaping(Result<IceCreamResponse, Error>) -> Void) {
        guard let url = URL(string: iceCreamsURLString) else {
            completion(.failure(CustomError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
                        
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(CustomError.invalidResponse))
                return
            }
                        
            guard let data = data else {
                completion(.failure(CustomError.invalidData))
                return
            }
                        
            do {
                let iceCreams = try JSONDecoder().decode(IceCreamResponse.self, from: data)
                completion(.success(iceCreams))
            } catch {
                completion(.failure(CustomError.invalidData))
            }
        }
        
        task.resume()
    }
    
    func getExtras(completion: @escaping(Result<[Extra], Error>) -> Void) {
        guard let url = URL(string: extrasURLString) else {
            completion(.failure(CustomError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(CustomError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(CustomError.invalidData))
                return
            }
            do {
                let extras = try JSONDecoder().decode([Extra].self, from: data)
                completion(.success(extras))
            } catch {
                completion(.failure(CustomError.invalidData))
            }
        }
        
        task.resume()
    }
}
