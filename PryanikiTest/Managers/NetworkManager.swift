//
//  NetworkManager.swift
//  PryanikiTest
//
//  Created by Николаев Никита on 30.01.2021.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchDataByTestURL(completion: @escaping (Result<PryanikiResponse, NetworkError>) -> ()) {
        let testURL = AppConstants.API.testURL
        fetchData(by: testURL, completion: completion)
    }
    
    func fetchData(by urlString: String, completion: @escaping (Result<PryanikiResponse, NetworkError>) -> ()) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil else {
                completion(.failure(error as! NetworkError))
                return
            }
            guard let data = data else {
                completion(.failure(.emptyData))
                return
            }
            guard let decodedData = self.parseJSON(data: data, type: PryanikiResponse.self) else {
                completion(.failure(.decodeError))
                return
            }
            completion(.success(decodedData))
        }.resume()
    }

    func parseJSON<T: Decodable>(data: Data, type: T.Type) -> T? {
        let decoder = JSONDecoder()
        do {
            let responseModel = try decoder.decode(type, from: data)
            return responseModel
        } catch {
            print(error)
        }
        return nil
    }
}

enum NetworkError: Error {
    case invalidURL
    case emptyData
    case decodeError
}
