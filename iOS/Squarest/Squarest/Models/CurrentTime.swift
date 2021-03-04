//
//  CurrentTime.swift
//  Squarest
//
//  Created by Erik Nordlund on 7/13/20.
//

import Foundation
import SwiftUI

final class CurrentTime: NSObject, ObservableObject {
	private var timer: Timer?
	private var displayLink: CADisplayLink?
	private var invalidated = false
	@Published var date: Date
	
	private var count = 0
	
	override init() {
		date = Date()
		timer = nil
		super.init()
	}
	
	deinit {
		stop()
	}
	
	func start() {
		debugPrint("STARTING TIMER")
		
		invalidated = false
		displayLink = CADisplayLink(target: self, selector: #selector(refreshDate))
		displayLink?.add(to: .current, forMode: .common)
	}
	
	func stop() {
		debugPrint("STOPPING TIMER")
		invalidated = true
	}
	
	@objc func refreshDate() {
		debugPrint("running")
		if !invalidated {
			debugPrint("refreshing date")
			count = count + 1
			if Calendar.current.isDate(date, equalTo: Date(), toGranularity: .minute) == false {
				// new minute
				date = Date()
			}
		} else {
			debugPrint("invalidating")
			displayLink?.invalidate()
			displayLink = nil
		}
	}
	
	var timerIsRunning: Bool {
		if displayLink == nil {
			return false
		} else {
			return true
		}
	}
}



class CurrentTimeLayer: CALayer {
	var shouldDisplay: Bool = true
	
	override func display() {
		if shouldDisplay {
			super.display()
		}
	}
}
