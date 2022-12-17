//
//  TextStorage.swift
//  square-embrace-swiftui
//
//  Created by Daniel Walton on 9/12/2022.
//

import Foundation

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

class HighlightingTextStorage: NSTextStorage {
  
  var backingStore = NSTextStorage()
  var syntaxHighlighter = SyntaxHighlighter()
  
  override public var string: String {
    get {
      return backingStore.string
    }
  }
  
  override public init() {
    super.init()
  }
  
  override public init(attributedString attrStr: NSAttributedString) {
    super.init(attributedString:attrStr)
    backingStore.setAttributedString(attrStr)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  required public init(itemProviderData data: Data, typeIdentifier: String) throws {
    fatalError("init(itemProviderData:typeIdentifier:) has not been implemented")
  }
  
#if os(macOS)
  required public init?(pasteboardPropertyList propertyList: Any, ofType type: String) {
    fatalError("init(pasteboardPropertyList:ofType:) has not been implemented")
  }
  
  required public init?(pasteboardPropertyList propertyList: Any, ofType type: NSPasteboard.PasteboardType) {
    fatalError("init(pasteboardPropertyList:ofType:) has not been implemented")
  }
#endif
  
  /// Finds attributes within a given range on a String.
  ///
  /// - parameter location: How far into the String to look.
  /// - parameter range:    The range to find attributes for.
  ///
  /// - returns: The attributes on a String within a certain range.
  ///
  override public func attributes(at location: Int, longestEffectiveRange range: NSRangePointer?, in rangeLimit: NSRange) -> [NSAttributedString.Key : Any] {
    return backingStore.attributes(at: location, longestEffectiveRange: range, in: rangeLimit)
  }
  
  /// Replaces edited characters within a certain range with a new string.
  ///
  /// - parameter range: The range to replace.
  /// - parameter str:   The new string to replace the range with.
  ///
  override public func replaceCharacters(in range: NSRange, with str: String) {
    self.beginEditing()
    backingStore.replaceCharacters(in: range, with: str)
    let len = (str as NSString).length
    let change = len - range.length
    self.edited([.editedCharacters, .editedAttributes], range: range, changeInLength: change)
    self.endEditing()
  }
  
  /// Sets the attributes on a string for a particular range.
  ///
  /// - parameter attrs: The attributes to add to the string for the range.
  /// - parameter range: The range in which to add attributes.
  ///
  public override func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
    self.beginEditing()
    backingStore.setAttributes(attrs, range: range)
    self.edited(.editedAttributes, range: range, changeInLength: 0)
    self.endEditing()
  }
  
  /// Retrieves the attributes of a string for a particular range.
  ///
  /// - parameter at: The location to begin with.
  /// - parameter range: The range in which to retrieve attributes.
  ///
  public override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
    return backingStore.attributes(at: location, effectiveRange: range)
  }
  
  /// Processes any edits made to the text in the editor.
  ///
  override public func processEditing() {
    self.syntaxHighlighter.colorize(self.backingStore,range: editedRange)
    super.processEditing()
  }
}
