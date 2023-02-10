//
//  Monte_CarloApp.swift
//  Monte-Carlo
//
//  Created by IIT PHYS 440 on 2/3/23.
//

import SwiftUI

@main
struct Monte_CarloApp: App {
    @StateObject var plotData = PlotClass()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(plotData)
                .tabItem {
                    Text("Plot")
                }

        }
    }
}
