//
//  ContentView.swift
//  MultiDragAndDrop
//
//  Created by Daniel Witt on 02.01.23.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @EnvironmentObject private var navigationModel: NavigationModel
    @EnvironmentObject private var dataStore: DataStore

    var body: some View {
        NavigationSplitView {
            List(selection: $navigationModel.selectedSidebarItem) {
                ForEach(dataStore.sidebarItems, id: \.self) { sidebarItem in
                    SidebarItemView(sidebarItem: sidebarItem)
                }
            }

        } detail: {
            if let selectedSidebarItem = navigationModel.selectedSidebarItem {
                List(selection: $navigationModel.selectedDetailItems) {
                    ForEach(selectedSidebarItem.detailItems) { detailItem in
                        NavigationLink(value: detailItem) {
                            Text(detailItem.id.uuidString)
                                .draggable(detailItem)
                        }
                    }
                }
            }
        }
    }
}

struct SidebarItemView: View {
    @ObservedObject var sidebarItem: SidebarItem
    @State private var isTargeted = false

    var body: some View {
        NavigationLink(value: sidebarItem) {
            Text(sidebarItem.id.uuidString.dropLast(20))
                .badge(sidebarItem.detailItems.count)
        }
        .listRowBackground(
            Color.secondary
                .cornerRadius(5)
                .opacity(isTargeted ? 1.0 : 0.0)
                .padding(.horizontal, 10)
        )
        .onDrop(of: [UTType.text], isTargeted: $isTargeted, perform: { itemProviders in
            print("itemProviders: \(itemProviders)")
            for itemProvider in itemProviders {
                _ = itemProvider.loadTransferable(type: Data.self) { result in
                    switch result {
                        case .success(let stringData):

                            if let uuidString = String(data: stringData, encoding: .utf16) {
                                print("uuidString: \(uuidString)")

                                let detailItem = DetailItem(id: UUID(uuidString: uuidString)!)
                                Task {
                                    await addDetailToSidebarItem(detailItem: detailItem)
                                }
                                return
                            }

                        case .failure(let error):
                            print(error.localizedDescription)
                    }
                }
            }
            return true
        })
    }

    func addDetailToSidebarItem(detailItem: DetailItem) {
        sidebarItem.detailItems.append(detailItem)
    }
}
