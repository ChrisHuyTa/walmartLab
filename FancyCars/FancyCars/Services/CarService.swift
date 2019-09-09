//
//  CarService.swift
//  FancyCars
//
//  Created by Chris Ta on 2019-09-08.
//  Copyright © 2019 WalmartLab. All rights reserved.
//

import Foundation

class CarService {
    
    static let sharedInstance = CarService()
    
    private let urlSession = URLSession.shared
    private let baseUrl = "https://api.fancycars.com/cars"
    private let jsonDecoder = JSONDecoder()

    
    //assuming the api taking page as parameter to fetch next set of records
    //right now it just returns mock value from cars.json
    func fetchCars(page: Int = 0, completion: @escaping (Result<[FancyCar], APIServiceError>) -> Void) {
        guard let url = Bundle.main.url(forResource: "cars", withExtension: "json") else {
            completion(.failure(.noData))
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let cars = try JSONDecoder().decode([FancyCar].self, from: data)
            completion(.success(cars))
        } catch {
            completion(.failure(.decodeError))
        }
        
        
//        guard var urlComponents = URLComponents(url: URL(string: baseUrl)!, resolvingAgainstBaseURL: true) else {
//            completion(.failure(.invalidEndpoint))
//            return
//        }
//
//        urlComponents.queryItems = [URLQueryItem(name: "page", value: "\(page)")]
//
//        guard let finalUrl = urlComponents.url else {
//            completion(.failure(.invalidEndpoint))
//            return
//        }
//        urlSession.dataTask(with: finalUrl) { (result) in
//            switch result {
//                case .success(let (response, data)):
//                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
//                    completion(.failure(.invalidResponse))
//                    return
//                }
//                do {
//                    let values = try self.jsonDecoder.decode([FancyCar].self, from: data)
//                    completion(.success(values))
//                } catch {
//                    completion(.failure(.decodeError))
//                }
//                case .failure(let _):
//                completion(.failure(.apiError))
//            }
//        }.resume()
    }
    
    
}

extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
}

public enum APIServiceError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodeError
}
