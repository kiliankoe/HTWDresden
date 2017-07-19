import Foundation

protocol APIResource {
    static var url: URL { get }
}

enum Network {
    static func dataTask<T: Decodable>(request: URLRequest, session: URLSession = .shared, completion: @escaping (Result<T>) -> Void) {
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(Result(failure: error!))
                return
            }

            guard
                let response = response as? HTTPURLResponse,
                let data = data
            else {
                completion(Result(failure: Error.network))
                return
            }

            guard response.statusCode / 100 == 2 else {
                completion(Result(failure: Error.server(statusCode: response.statusCode)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(Result(success: decoded))
            } catch {
                completion(Result(failure: error))
                return
            }

        }.resume()
    }
}
