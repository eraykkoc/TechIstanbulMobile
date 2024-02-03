import SwiftUI

struct User: Codable {
    let id: Int
    let name: String
    let email: String
}

struct UserDetail: Codable {
    let id: Int
    let name: String
    let email: String
}

struct AddUserRequest: Codable {
    let name: String
    let email: String
}

class APIManager {
    static let shared = APIManager()
    
    private let baseURL = "https://userlistapi.netlify.app/api"
    
    func getUsers(completion: @escaping ([User]?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/users") else {
            completion(nil, NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                completion(users, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    func getUser(id: Int, completion: @escaping (UserDetail?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/users/\(id)") else {
            completion(nil, NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let userDetail = try JSONDecoder().decode(UserDetail.self, from: data)
                completion(userDetail, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    func addUser(request: AddUserRequest, completion: @escaping (User?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/users") else {
            completion(nil, NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            completion(nil, error)
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let newUser = try JSONDecoder().decode(User.self, from: data)
                completion(newUser, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    func updateUser(id: Int, request: AddUserRequest, completion: @escaping (User?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/users/\(id)") else {
            completion(nil, NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            completion(nil, error)
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let updatedUser = try JSONDecoder().decode(User.self, from: data)
                completion(updatedUser, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    func deleteUser(id: Int, completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/users/\(id)") else {
            completion(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
}
