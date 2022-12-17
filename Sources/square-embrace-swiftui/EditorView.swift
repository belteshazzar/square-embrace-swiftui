//
//  EditorView.swift
//  square-embrace-swiftui
//
//  Created by Daniel Walton on 8/12/2022.
//

import SwiftUI

struct EditorView: XViewRepresentable {
  
  @Binding var text: String
  
  let textStorage = HighlightingTextStorage()
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(self)
  }
  
#if os(iOS)
  public func makeUIView(context: Context) -> UITextView {
    let layoutManager = NSLayoutManager()
    textStorage.addLayoutManager(layoutManager)
    let textContainer = NSTextContainer()
    textContainer.widthTracksTextView  = true // those are key!
    layoutManager.addTextContainer(textContainer)
    let textView = UITextView(frame: .zero, textContainer: textContainer)
    textView.smartDashesType = .no;
    textView.smartQuotesType = .no;
    textView.smartInsertDeleteType = .no
    textView.delegate = context.coordinator
    textView.text = self.text
    textView.font = UIFont.monospacedSystemFont(ofSize: 16, weight: .regular)
    return textView
  }
  
  class Coordinator: NSObject, UITextViewDelegate {
    var parent: EditorView
    
    init(_ parent: EditorView) {
      self.parent = parent
    }
    
    func textViewDidChange(_ textView: UITextView) {
      self.parent.text = textView.text
    }
    
    func textDidChange(_ notification: Notification) {
      guard let textView = notification.object as? UITextView else {return}

      self.parent.text = textView.text
    }
  }

  public func updateUIView(_ uiView: UITextView, context: Context) {
  }
#endif
  
#if os(macOS)
  
  public func makeNSView(context: Context) -> NSScrollView {
    let scrollView = NSTextView.scrollableTextView()
    guard let textView = scrollView.documentView as? NSTextView else { return scrollView }
    
    textView.allowsUndo = true
    textView.isRichText = true
    textStorage.addLayoutManager(textView.layoutManager!)
    textView.textStorage?.setAttributedString(NSMutableAttributedString(string: text))
    textView.delegate = context.coordinator
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    textView.font = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
    textView.lnv_setUpLineNumberView()
    return scrollView
  }
  
  class Coordinator: NSObject, NSTextViewDelegate {
    var parent: EditorView
    
    init(_ parent: EditorView) {
      self.parent = parent
    }
    
    func textViewDidChange(_ textView: NSTextView) {
      self.parent.text = textView.string
    }
    
    func textDidChange(_ notification: Notification) {
      guard let textView = notification.object as? NSTextView else {return}
      self.parent.text = textView.string
    }
  }
  
  public func updateNSView(_ view: NSScrollView, context: Context) {
  }
#endif
}
