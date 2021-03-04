//
//  File.swift
//  
//
//  Created by Erik Nordlund on 7/9/20.
//

import Foundation
import AWSLambdaRuntime

enum Handler: String {
	case create
	case read
	case list
	
	static var current: Handler? {
		guard let handler = Lambda.env("_HANDLER") else {
			return nil
		}
		
		return Handler(rawValue: handler)
	}
	
	
}
