//
//  DataStore.swift
//  MultiDragAndDrop
//
//  Created by Daniel Witt on 02.01.23.
//

import SwiftUI

class DataStore: NSObject, ObservableObject {
    @Published var sidebarItems = [SidebarItem(detailItems:
        [DetailItem(), DetailItem(), DetailItem(), DetailItem(), DetailItem(), DetailItem()]),
                                   
    SidebarItem(detailItems:
        [DetailItem(), DetailItem(), DetailItem(), DetailItem()]),
                                   
    SidebarItem(detailItems:
        [DetailItem(), DetailItem(), DetailItem(), DetailItem(), DetailItem()])]
}
