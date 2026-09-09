import SwiftUI
import WebKit

struct PetStationWebView: UIViewRepresentable {
    let url: URL
    @Binding var currentUrl: String

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()

        // Hide website footer using CSS injection
        let css = "#shopify-section-footer, footer, .footer, .shopify-section--footer, footer.footer, .site-footer, cookie-bar[section=\"footer\"] { display: none !important; }"
        let js = "var style = document.createElement('style'); style.id = 'petstation-hide-footer-style'; style.innerHTML = '\(css)'; (document.head || document.documentElement).appendChild(style);"

        let userScript = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        config.userContentController.addUserScript(userScript)

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let currentWebViewUrl = uiView.url?.absoluteString.trimmingCharacters(in: CharacterSet(charactersIn: "/")),
           let targetUrl = url.absoluteString.trimmingCharacters(in: CharacterSet(charactersIn: "/")),
           currentWebViewUrl != targetUrl {
            uiView.load(URLRequest(url: url))
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: PetStationWebView

        init(_ parent: PetStationWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if let urlString = webView.url?.absoluteString {
                parent.currentUrl = urlString
            }
        }
    }
}
