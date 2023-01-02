import SwiftUI

final class NavigationModel: ObservableObject {
    static var shared = NavigationModel()
    @Published var selectedSidebarItem: SidebarItem?
    @Published var selectedDetailItems = Set<DetailItem>()
}
