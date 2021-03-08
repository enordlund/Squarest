//
//  SumView.swift
//  Squarest
//
//  Created by Erik Nordlund on 7/8/20.
//

import SwiftUI

struct SumView: View {
	@State var sumInput1: String = ""
	@State var sumInput2: String = ""
	
	@StateObject var summer = Summer()
	
	var body: some View {
		NavigationView {
			VStack {
                Spacer()
				Group {
					if summer.isLoading {
						// result is loading
						ProgressView()
					} else {
						// request is complete, with possible error
						if summer.errorMessage != nil {
							Text(summer.errorMessage!)
						} else if summer.result != nil {
							Text("\(summer.result!)")
						} else {
							Text("Please enter two numbers.")
						}
					}
				}
				.padding()
				
				HStack {
					TextField("Value 1", text: $sumInput1)
						.textFieldStyle(RoundedBorderTextFieldStyle())
					
					Image(systemName: "plus")
					
					TextField("Value 2", text: $sumInput2)
						.textFieldStyle(RoundedBorderTextFieldStyle())
				}
				
				Button("Get Sum", action: {
					summer.requestSum(of: sumInput1, and: sumInput2)
				})
				.padding()
                Spacer()
			}
            .padding()
            .background(Color(.systemGroupedBackground)
                            .edgesIgnoringSafeArea(.all))
			.navigationBarTitle(Text("Sum"), displayMode: .large)
		}
	}
}

struct SumView_Previews: PreviewProvider {
    static var previews: some View {
        SumView()
    }
}
