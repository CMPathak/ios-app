import SwiftUI

struct ContentView: View {
    @State private var activeUrl = "https://www.thepetstation.in/"
    @State private var selectedTab = 0

    private let tabUrls = [
        "https://www.thepetstation.in/",
        "https://www.thepetstation.in/collections/all",
        "https://www.thepetstation.in/search",
        "https://www.thepetstation.in/cart",
        "https://www.thepetstation.in/account"
    ]

    private var currentTabUrl: URL {
        URL(string: tabUrls[selectedTab]) ?? URL(string: "https://www.thepetstation.in/")!
    }

    var body: some View {
        VStack(spacing: 0) {
            PetStationWebView(url: currentTabUrl, currentUrl: $activeUrl)

            Divider()

            // Lightweight Single-Instance Bottom Navigation
            HStack {
                tabButton(title: "Home", icon: "house.fill", tabIndex: 0)
                Spacer()
                tabButton(title: "Shop", icon: "bag.fill", tabIndex: 1)
                Spacer()
                tabButton(title: "Search", icon: "magnifyingglass", tabIndex: 2)
                Spacer()
                tabButton(title: "Cart", icon: "cart.fill", tabIndex: 3)
                Spacer()
                tabButton(title: "Account", icon: "person.fill", tabIndex: 4)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 6)
            .background(Color(UIColor.systemBackground))
        }
        .edgesIgnoringSafeArea(.bottom)
    }

    @ViewBuilder
    private func tabButton(title: String, icon: String, tabIndex: Int) -> some View {
        Button(action: {
            selectedTab = tabIndex
        }) {
            VStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(title)
                    .font(.system(size: 11, weight: selectedTab == tabIndex ? .bold : .regular))
            }
            .foregroundColor(selectedTab == tabIndex ? Color(red: 0.88, green: 0.36, blue: 0.15) : .gray)
        }
    }
}

#Preview {
    ContentView()
}
