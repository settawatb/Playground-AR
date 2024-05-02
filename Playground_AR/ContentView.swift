//
//  ContentView.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 18/11/2566 BE.
//

import SwiftUI

struct ContentView: View {
    // Log Status
    @AppStorage("log_Status") var log_Status: Bool = false
    var body: some View {
        // initial page
        Group{
            if log_Status{
                MainPage()
            }
            else{
                OnBoardingPage()
            }
        }
    }
}

#Preview {
    ContentView()
}
