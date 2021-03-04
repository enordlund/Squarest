//
//  SquarestApp.swift
//  Squarest
//
//  Created by Erik Nordlund on 7/8/20.
//

import SwiftUI

@main
struct SquarestApp: App {
	var body: some Scene {
        WindowGroup {
            ContentView()
				.environmentObject(History())
        }
    }
}
