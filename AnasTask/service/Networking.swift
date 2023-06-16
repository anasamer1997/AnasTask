//
//  Networking.swift
//  AnasTask
//
//  Created by mac on 16/06/2023.
//

import Foundation

class Networking{
    static let shared = Networking()
    


    enum Endpoints{
        static let baseUrl = "https://api.github.com/orgs/square/"
        
        
        case repos(Int)
        
        
        var stringValue:String{
            switch self{
                
            case .repos(let page):
                return Endpoints.baseUrl + "repos?page=\(page)"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
  private func taskForGetRequest<ResponseType: Codable> (url: URL, response: ResponseType.Type, completion: @escaping (ResponseType?,String?) -> Void) {
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                if let statusCodeMessage = self.getErrorMessageFor(statusCode: httpResponse.statusCode)  {
                    guard statusCodeMessage == "success" else{
                        completion(nil , statusCodeMessage)
                        return
                    }
                }
            }
            guard let data = data else {
                completion(nil, error?.localizedDescription)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(ResponseType.self, from: data)
                print(result)
                completion(result,nil)
            }
//            catch let DecodingError.typeMismatch(type, context)  {
//
//                print("Type '\(type)' mismatch:", context.debugDescription)
//                print("codingPath:", context.codingPath)
//
//            } catch let DecodingError.dataCorrupted(context) {
//                print(context)
//
//            } catch let DecodingError.keyNotFound(key, context) {
//
//                print("Key '\(key)' not found:", context.debugDescription)
//                print("codingPath:", context.codingPath)
//
//            } catch let DecodingError.valueNotFound(value, context) {
//
//                print("Value '\(value)' not found:", context.debugDescription)
//                print("codingPath:", context.codingPath)
//
//            }
            catch {
                completion(nil, "couldn't decode data!!")
            }
        }
        
        task.resume()
        
        
    }
    private func getErrorMessageFor(statusCode: Int) -> String? {
        if (200...299).contains(statusCode) {
            //If no error message is returned assume that the request was a success
            return "success"
        } else if (400...499).contains(statusCode) {
            return "Please make sure you filled in the all the required fields."
        } else if (500...599).contains(statusCode) {
            return "Sorry, couldn't reach our server."
        } else if (700...).contains(statusCode) {
            return "Sorry, something went wrong. Try again later."
        } else {
            return "Message for other errors?"
        }
    }
    
    
    
    func fetchRepository(currentPage:Int,completion:@escaping([RepositoryResponse]?,String?) -> Void){
        taskForGetRequest(url: Endpoints.repos(currentPage).url, response: [RepositoryResponse].self) { data,error in
            guard data != nil else{
                completion(nil,error)
                return
            }
            completion(data,nil)
        }
        
    }
}
