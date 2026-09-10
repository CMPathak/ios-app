import SwiftUI
import WebKit

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var currentUrlString = "https://www.thepetstation.in/"
    @State private var isLoading = true
    @State private var webViewProxy: WKWebView? = nil

    private let tabUrls = [
        "https://www.thepetstation.in/",
        "https://www.thepetstation.in/collections/all",
        "https://www.thepetstation.in/search",
        "https://www.thepetstation.in/cart",
        "https://www.thepetstation.in/account"
    ]

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                PetStationWebView(
                    url: URL(string: tabUrls[selectedTab])!,
                    currentUrl: $currentUrlString,
                    isLoading: $isLoading,
                    webViewProxy: $webViewProxy
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(red: 0.88, green: 0.36, blue: 0.15)))
                        .scaleEffect(1.2)
                        .padding(.top, 12)
                }
            }

            Divider()

            // Bottom Navigation Bar respecting iPhone safe area / home indicator
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
            .padding(.top, 10)
            .padding(.bottom, 16) // accounts for home indicator on modern iPhones
            .background(Color(UIColor.systemBackground).shadow(radius: 2))
        }
        .edgesIgnoringSafeArea(.top)
    }

    @ViewBuilder
    private func tabButton(title: String, icon: String, tabIndex: Int) -> some View {
        Button(action: {
            if selectedTab != tabIndex {
                selectedTab = tabIndex
                let targetUrlStr = tabUrls[tabIndex]
                if let url = URL(string: targetUrlStr), let proxy = webViewProxy {
                    proxy.load(URLRequest(url: url))
                }
            }
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
