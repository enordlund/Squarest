//
//  Double+InterfaceFormat.swift
//  Squarest
//
//  Created by Erik Nordlund on 7/13/20.
//

import Foundation

extension Double {
	func interfaceFormat() -> String {
		let formatter = NumberFormatter()
		formatter.minimumFractionDigits = 0
		formatter.maximumFractionDigits = Int.max
		
		if let output = formatter.string(from: NSNumber(value: self)) {
			return output
		} else {
			return ""
		}
	}
}
