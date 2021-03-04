//
//  DateFilter.swift
//  Squarest
//
//  Created by Erik Nordlund on 7/16/20.
//

import Foundation
import SwiftUI
import Combine

class DateFilter: ObservableObject {
	@Published var start: Date = Date().advanced(by: -86400)
	
	@Published var end: Date = Date()
	
	@Published var applyStartFilter = false
	@Published var applyEndFilter = false
	
	var requestStart: Date? {
		if applyStartFilter {
			return start
		} else {
			return nil
		}
	}
	
	var requestEnd: Date? {
		if applyEndFilter {
			return end
		} else {
			return nil
		}
	}
	
	func clear() {
		applyStartFilter = false
		applyEndFilter = false
	}
	
}
