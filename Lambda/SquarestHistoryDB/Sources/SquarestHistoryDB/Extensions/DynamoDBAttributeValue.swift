//
//  File.swift
//  
//
//  Created by Erik Nordlund on 7/9/20.
//

import Foundation
import DynamoDB

extension DynamoDB.AttributeValue {
	func operandsDoubles(from: [String]) -> [Double] {
		var doubles = [Double]()
		
		for operand in from {
			guard let double = Double(operand) else {
				continue
			}
			doubles.append(double)
		}
		
		return doubles
	}
	
	var asString: String? {
		guard case .s(let value) = self else {
			return nil
		}
		return value
	}
	
	var asNumber: Double? {
		guard case .n(let value) = self,
			  let number = Double(value) else {
			return nil
		}
		
		return number
	}
	
	var asNumberSet: [Double]? {
		guard case .ns(let value) = self else {
			return nil
		}
		
		// value is an array of strings
		return operandsDoubles(from: value)
	}
}
