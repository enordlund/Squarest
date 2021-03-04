//
//  Summer.swift
//  Squarest
//
//  Created by Erik Nordlund on 7/8/20.
//

import Foundation

struct SumRequest: Codable {
	let number1: Double
	let number2: Double
}


struct SumResponse: Codable {
	let result: Double?
	let errorMessage: String?
}

class Summer: NetworkManager, ObservableObject {
	@Published var isLoading = false
	@Published var result: String? = nil
	@Published var errorMessage: String? = nil
	
	// handle assembling request data, and sending the request.
	func requestSum(of: String, and: String) {
		
		guard let number1 = Double(of) else {
			result = nil
			errorMessage = "Only numbers are allowed."
			return
		}
		
		guard let number2 = Double(and) else {
			result = nil
			errorMessage = "Only numbers are allowed."
			return
		}
		
		isLoading = true
		
		let postData = SquarestRequest(requestType: .sum, operand1: number1, operand2: number2, startDate: nil, endDate: nil, timeZone: nil, operationCategories: nil)
		
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
		} else if let sumResponse = response {
			if let responseResult = sumResponse.result {
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
