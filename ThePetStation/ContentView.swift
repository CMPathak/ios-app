import SwiftUI

struct ContentView: View {
    @State private var activeUrl = "https://www.thepetstation.in/"
    @State private var selectedTab = 0

    private let homeUrl = URL(string: "https://www.thepetstation.in/")!
    private let shopUrl = URL(string: "https://www.thepetstation.in/collections/all")!
    private let searchUrl = URL(string: "https://www.thepetstation.in/search")!
    private let cartUrl = URL(string: "https://www.thepetstation.in/cart")!
    private let accountUrl = URL(string: "https://www.thepetstation.in/account")!

    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Home
            PetStationWebView(url: homeUrl, currentUrl: $activeUrl)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            // Tab 2: Shop
            PetStationWebView(url: shopUrl, currentUrl: $activeUrl)
                .tabItem {
                    Label("Shop", systemImage: "bag.fill")
                }
                .tag(1)

            // Tab 3: Search
            PetStationWebView(url: searchUrl, currentUrl: $activeUrl)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(2)

            // Tab 4: Cart
            PetStationWebView(url: cartUrl, currentUrl: $activeUrl)
                .tabItem {
                    Label("Cart", systemImage: "cart.fill")
                }
                .tag(3)

            // Tab 5: Account
            PetStationWebView(url: accountUrl, currentUrl: $activeUrl)
                .tabItem {
                    Label("Account", systemImage: "person.fill")
                }
                .tag(4)
        }
        .accentColor(Color(red: 0.88, green: 0.36, blue: 0.15)) // Primary Orange
    }
}

#Preview {
    ContentView()
}
