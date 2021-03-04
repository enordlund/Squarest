//
//  NetworkManager.swift
//  Squarest
//
//  Created by Erik Nordlund on 7/8/20.
//

import Foundation

class NetworkManager {
	//testDB: Optional("{\"result\":[]}")
    #warning("Assign root URL and API key below.")
    private let rootURL: String = "https://abcd.execute-api.us-west-2.amazonaws.com/squarest"
	
	private let apiKey: String = "abcd1234"
	
	internal enum PostError {
		case urlError
		case serverError
		case dataGuardError
		case otherError
	}
	
	internal func errorMessage(fromPostError: PostError) -> String {
		switch fromPostError {
		case .urlError:
			return "URL Error"
		case .serverError:
			return "Server Error"
		case .dataGuardError:
			return "Data Guard Error"
		default:
			return "Unknown Error"
		}
	}
	
	internal func encodeJSON<T: Encodable>(encodable: T) -> Data? {
		guard let data = try? JSONEncoder().encode(encodable) else {
			return nil
		}
		
		return data
	}
	
	internal func post<T: Codable, U: Codable>(responseType: T.Type, postData: U, endpoint: String?, completion: @escaping (T?, String?) -> Void) {
		
		guard let requestURL = URL(string: rootURL + (endpoint ?? "")) else {
			print("Error with url")
			self.handlePostCompletion(responseType: responseType, data: nil, error: nil, postError: .urlError, completion: { response, errorMessage in
				
				DispatchQueue.main.async {
					completion(response, errorMessage)
				}
			})
			
			return
		}
		
		var request = URLRequest(url: requestURL)
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
		request.httpMethod = "POST"
		request.httpBody = encodeJSON(encodable: postData)
		
		print("request:")
		print(String(data: request.httpBody!, encoding: .utf8) as Any)
		
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			if let error = error {
				print("error: \(error)")
				self.handlePostCompletion(responseType: responseType, data: nil, error: error, postError: .otherError, completion: { response, errorMessage in
					DispatchQueue.main.async {
						completion(response, errorMessage)
					}
				})
				return
			}
			
			#warning("TO DO: Check response for 200 OK")
			guard let response = response as? HTTPURLResponse,
				(200...299).contains(response.statusCode) else {
				print("server error")
				self.handlePostCompletion(responseType: responseType, data: nil, error: error, postError: .serverError, completion: { response, errorMessage in
					DispatchQueue.main.async {
						completion(response, errorMessage)
					}
				})
				return
			}
			
			guard let data = data else {
				print("Error with data guard")
				self.handlePostCompletion(responseType: responseType, data: nil, error: error, postError: .dataGuardError, completion: { response, errorMessage in
					DispatchQueue.main.async {
						completion(response, errorMessage)
					}
				})
				return
			}
			
			let dataString = String(data: data, encoding: .utf8)
			print(dataString as Any)
			
			DispatchQueue.main.async {
				self.handlePostCompletion(responseType: responseType, data: data, error: nil, postError: nil, completion: { response, errorMessage in
					DispatchQueue.main.async {
						completion(response, errorMessage)
					}
				})
			}
			
		}.resume()
	}
	
	internal func handlePostCompletion<T: Codable>(responseType: T.Type, data: Data?, error: Error?, postError: PostError?, completion: @escaping (T?, String?) -> Void) {
		if let data = data {
			// decode the data, and make it available to the view
			do {
				// construct entries from JSON
				let decodedData = try JSONDecoder().decode(responseType, from: data)
				
				DispatchQueue.main.async {
					// pass decoded data to the handler
					completion(decodedData, nil)
				}
				
			} catch let jsonError {
				print("Error decoding JSON: ", jsonError)
				let dataString = String(data: data, encoding: .utf8)
				let errorMessage = jsonError.localizedDescription
				print(dataString as Any)
				
				DispatchQueue.main.async {
					completion(nil, errorMessage)
				}
			}
		} else if let postError = postError {
			let errorMessage = self.errorMessage(fromPostError: postError)
			
			DispatchQueue.main.async {
				completion(nil, errorMessage)
			}
		}
	}
}

