//
//  Squarer.swift
//  Squarest
//
//  Created by Erik Nordlund on 7/8/20.
//

import Foundation

//struct SquarestRequest: Codable {
//	let number: Double
//}
//
//struct SquarestResponse: Codable {
//	let result: Double?
//	let errorMessage: String?
//}

class Squarer: NetworkManager, ObservableObject {
	@Published var isLoading = false
	@Published var result: String? = nil
	@Published var errorMessage: String? = nil
	
	// handle assembling request data, and sending the request.
	func requestSquare(of: String) {
		
		guard let number = Double(of) else {
			result = nil
			errorMessage = "Only numbers are allowed."
			
			return
		}
		
		isLoading = true
		
		let postData = SquarestRequest(requestType: .square, operand1: number, operand2: nil, startDate: nil, endDate: nil, timeZone: nil, operationCategories: nil)
		
		post(responseType: SquarestResponse.self, postData: postData, endpoint: nil, completion: ({response, errorMessage in
			self.handle(response: response, postErrorMessage: errorMessage)
			
			self.isLoading = false
		}))
		
	}
	
	internal func handle(response: SquarestResponse?, postErrorMessage: String?) {
		if let postError = postErrorMessage {
			// post error happened
			result = nil
			errorMessage = postError
		} else if let squarestResponse = response {
			if let responseResult = squarestResponse.result {
				result = String(responseResult.interfaceFormat())
				errorMessage = nil
			} else {
				result = nil
				errorMessage = "Empty Response"
			}
		} else {
			result = nil
			errorMessage = "Empty Completion"
		}
	}
}
