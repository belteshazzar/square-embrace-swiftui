//
//  SqrmWebView.swift
//  square-embrace-swiftui
//
//  Created by Daniel Walton on 1/12/2022.
//
import SwiftUI
import WebKit

struct SqrmWebView: XViewRepresentable {
  static let html = Bundle.main.url(forResource: "html", withExtension: nil)!
  static let index = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "html")!
  
#if os(iOS)
  public func makeUIView(context: Context) -> WKWebView {
    load(context: context)
  }
  
  public func updateUIView(_ uiView: WKWebView, context: Context) {
    update(uiView, context: context)
  }
#endif
  
#if os(macOS)
  public func makeNSView(context: Context) -> WKWebView {
    load(context: context)
  }
  
  public func updateNSView(_ view: WKWebView, context: Context) {
    update(view, context: context)
  }
#endif
  
  @Binding var text: String
  
  class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    }
    
    private var owner: SqrmWebView
    init(owner: SqrmWebView) {
      self.owner = owner
    }
    
    var webView: WKWebView?
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      self.webView = webView
      self.owner.updateText(webView)
    }
  }
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(owner: self)
  }
  
  func load(context: Context) -> WKWebView {
    let _wkwebview = WKWebView(frame: .zero)
    _wkwebview.navigationDelegate = context.coordinator
    _wkwebview.loadFileURL(SqrmWebView.index, allowingReadAccessTo: SqrmWebView.html)
    return _wkwebview
  }
  
  func update(_ webView: WKWebView, context: Context) {
    updateText(webView)
  }
  
  func updateText(_ webView: WKWebView) {
    let newString = text
      .replacingOccurrences(of: "\n", with: "\\n", options: .literal, range: nil)
      .replacingOccurrences(of: "’", with: "'", options: .literal, range: nil)
      .replacingOccurrences(of: "“", with: "\"", options: .literal, range: nil)
      .replacingOccurrences(of: "\"", with: "\\\"", options: .literal, range: nil)
    
    webView.evaluateJavaScript("render(\"\(newString)\")") {result,error in
      print(result as Any)
      print(error as Any)
    }
  }
}
