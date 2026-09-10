import SwiftUI
import WebKit

struct PetStationWebView: UIViewRepresentable {
    let url: URL
    @Binding var currentUrl: String
    @Binding var isLoading: Bool
    @Binding var webViewProxy: WKWebView?

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        if #available(iOS 14.0, *) {
            config.defaultWebpagePreferences.allowsContentJavaScript = true
        }

        // Robust CSS + MutationObserver to hide footer and add bottom padding so content isn't covered by bottom nav
        let css = """
        #shopify-section-footer, footer, .footer, .shopify-section--footer, footer.footer, .site-footer, cookie-bar[section="footer"] { display: none !important; }
        body { padding-bottom: 75px !important; }
        """
        let js = """
        (function() {
            var style = document.createElement('style');
            style.id = 'petstation-hide-footer-style';
            style.innerHTML = '\(css)';
            (document.head || document.documentElement).appendChild(style);

            var observer = new MutationObserver(function(mutations) {
                if (!document.getElementById('petstation-hide-footer-style')) {
                    var s = document.createElement('style');
                    s.id = 'petstation-hide-footer-style';
                    s.innerHTML = '\(css)';
                    (document.head || document.documentElement).appendChild(s);
                }
            });
            observer.observe(document.documentElement, { childList: true, subtree: true });
        })();
        """

        let userScript = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        config.userContentController.addUserScript(userScript)

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.contentInsetAdjustmentBehavior = .automatic

        DispatchQueue.main.async {
            webViewProxy = webView
        }

        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Prevent unwanted/repeated page reloads caused by regular SwiftUI state updates.
        // Only load if explicitly requested by a tab switch or external navigation command.
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: PetStationWebView

        init(_ parent: PetStationWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
            if let urlString = webView.url?.absoluteString {
                parent.currentUrl = urlString
            }
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            decisionHandler(.allow)
        }
    }
}
