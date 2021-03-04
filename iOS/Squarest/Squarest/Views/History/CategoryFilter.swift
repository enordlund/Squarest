//
//  CategoryFilter.swift
//  Squarest
//
//  Created by Erik Nordlund on 7/16/20.
//

import Foundation
import SwiftUI

class CategoryFilter: ObservableObject {
	@Published var categories: [OperationCategory]?
	
	@Published var includeSum: Bool {
		didSet {
			objectWillChange.send()
			refreshCategories()
		}
	}
	@Published var includeSquare: Bool {
		didSet {
			objectWillChange.send()
			refreshCategories()
		}
	}
	
	init(operationCategories: [OperationCategory]?) {
		categories = operationCategories
		
		includeSum = false
		includeSquare = false
		
		if let hasCategories = operationCategories {
			if hasCategories.contains(.sum) {
				includeSum = true
			}
			if hasCategories.contains(.square) {
				includeSquare = true
			}
		}
	}
	
	func refreshCategories() {
		if includeSum || includeSquare {
			var newCategories = [OperationCategory]()
			
			if includeSum {
				newCategories.append(.sum)
			}
			
			if includeSquare {
				newCategories.append(.square)
			}
			
			categories = newCategories
		} else {
			withAnimation {
				categories = nil
			}
		}
	}
	
	func restoreState() {
		if categories != nil {
			if (categories!.contains(.sum) == true) {
				includeSum = true
			} else {
				includeSum = false
			}
			if (categories!.contains(.square) == true) {
				includeSquare = true
			} else {
				includeSquare = false
			}
		}
	}
	
	func clear() {
		includeSum = false
		includeSquare = false
	}
}
