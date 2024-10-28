	//
//  WebView.swift
//  Complexity
//
//  Created by IE14 on 30/08/24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    @Binding var loadError: Bool

    class Coordinator: NSObject, WKNavigationDelegate {
        var isLoading: Binding<Bool>
        var loadError: Binding<Bool>

        init(isLoading: Binding<Bool>, loadError: Binding<Bool>) {
            self.isLoading = isLoading
            self.loadError = loadError
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("Started loading")
            isLoading.wrappedValue = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("Finished loading")
            isLoading.wrappedValue = false
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("Failed loading with error: \(error)")
            isLoading.wrappedValue = false
            loadError.wrappedValue = true
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(isLoading: $isLoading, loadError: $loadError)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if webView.url != url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}



import SwiftUI


struct WebContentView: View {
    let policyURL: URL?
    let title:String 
    
    @State private var isLoading = false
    @State private var loadError = false

    var body: some View {
        ZStack {
            // WebView
            if let url = policyURL {
                WebView(url: url, isLoading: $isLoading, loadError: $loadError)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("Invalid URL")
                    .foregroundColor(.red)
                    .padding()
            }
            
            // Loader
            if isLoading {
                VStack {
                    Spacer()
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                    Spacer()
                }
                .background(Color.white.opacity(0.8))
                .cornerRadius(8) 
                .padding()
            }

            // Error message
            if loadError {
                VStack {
                    Spacer()
                    Text("Failed to load content.")
                        .foregroundColor(.red)
                        .padding()
                    Spacer()
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}




struct WebContentView_Previews: PreviewProvider {
    static var previews: some View {
        WebContentView(policyURL: URL(string: "https://www.google.com/"), title: "")
    }
}
