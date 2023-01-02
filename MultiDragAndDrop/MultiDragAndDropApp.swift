//
//  MultiDragAndDropApp.swift
//  MultiDragAndDrop
//
//  Created by Daniel Witt on 02.01.23.
//

import SwiftUI

@main
struct MultiDragAndDropApp: App {
    @StateObject private var navigationModel = NavigationModel.shared
    @StateObject private var dataStore = DataStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationModel)
                .environmentObject(dataStore)
        }
    }
}
