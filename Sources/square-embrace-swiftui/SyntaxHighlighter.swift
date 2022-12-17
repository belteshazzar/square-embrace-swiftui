//
//  SyntaxHighlighter.swift
//  square-embrace-swiftui
//
//  Created by Daniel Walton on 8/12/2022.
//
import Foundation
import SwiftUI

#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
import AppKit
#endif

class LineMatch {
  let name : String
  let regex : NSRegularExpression
  let color : [NSAttributedString.Key : XColor]
  
  static func regex(_ re : String) -> NSRegularExpression {
    return try! NSRegularExpression(pattern: re, options: [NSRegularExpression.Options.anchorsMatchLines])
  }
  
  init(name: String, regex: String, r: CGFloat, g: CGFloat, b: CGFloat) {
    self.name = name
    self.regex = LineMatch.regex(regex)
    self.color = [NSAttributedString.Key.foregroundColor: XColor(red: r, green: g, blue: b, alpha: 1.0)]
  }
}

class SyntaxHighlighter {
  
  var patterns : [LineMatch]
  
  init() {
    
    self.patterns = [
      LineMatch(name: "DocumentSeparator", regex: "^---$", r: 1.0, g: 0.0, b: 0.0),
      LineMatch(name: "BlankLine", regex: "^\\s*$", r: 1.0, g: 0.0, b: 0.0),
      LineMatch(name: "Tag", regex: "^\\s*(([a-zA-Z_$][-a-zA-Z\\d_$]*)\\s*:(\\s+(.*?))?)\\s*$", r: 1.0, g: 0.0, b: 0.0),
      LineMatch(name: "ListItemTag", regex: "^\\s*-\\s+([a-zA-Z_$][-a-zA-Z\\d_$]*)(\\s*:(\\s+(.*?))?)?\\s*$", r: 1.0, g: 0.0, b: 0.0),
      LineMatch(name: "Script", regex: "^(\\s*)<%(.*?)\\s*$", r: 1.0, g: 0.0, b: 0.0),
      LineMatch(name: "Footnote", regex: "^\\s*\\[ *\\^ *(\\S+) *\\] *: *(.+?) *$", r: 1.0, g: 0.0, b: 0.0),
      LineMatch(name: "LinkDefinition", regex: "^\\s*\\[ *([^\\]]+) *\\] *: *(.+?) *$", r: 1.0, g: 0.0, b: 0.0),
      LineMatch(name: "CodeBlock", regex: "^\\s*``` *(([a-zA-Z]+)?)\\s*$", r: 1.0, g: 0.0, b: 0.0),
      LineMatch(name: "Div", regex: "^\\s*(<\\s*((\\!doctype)|([a-z]+([a-z0-9]+)?))((?:\\s+[a-z]+(=\"[^\"]*\")?)*)\\s*>?\\s*)$", r: 1.0, g: 0.0, b: 0.0),
      LineMatch(name: "Heading", regex: "^\\s*((=+)\\s*(\\S.*?)\\s*[-=]*)\\s*$", r: 1.0, g: 0.0, b: 0.0),
      LineMatch(name: "HR", regex: "^\\s*[-=_\\*\\s]+$", r: 1.0, g: 0.0, b: 0.0),
      LineMatch(name: "ListItem", regex: "^\\s*(?:(?:([-*+])|(\\d+[\\.)]))\\s+(\\S.*?))\\s*$", r: 1.0, g: 0.0, b: 0.0),
      LineMatch(name: "ListItemTask", regex: "^\\s*\\[ *([xX]?) *\\]\\s+(.*?)\\s*$", r: 1.0, g: 0.0, b: 0.0),
      LineMatch(name: "Table", regex: "^\\s*(\\|(.+?)\\|?)\\s*$", r: 1.0, g: 0.0, b: 0.0),
      LineMatch(name: "TableHeader", regex: "^\\s*[-| ]+$", r: 1.0, g: 0.0, b: 0.0),
      LineMatch(name: "ScriptEnd", regex: "%>\\s*$", r: 1.0, g: 0.0, b: 0.0),
      LineMatch(name: "Paragraph", regex: "^.*$", r: 0.0, g: 0.0, b: 0.0)
    ]
  }
  
  func colorize(_ textStorage: NSTextStorage) {
    let all = textStorage.string
    let range = NSString(string: textStorage.string).range(of: all)

    colorize(textStorage, range: range)
  }
  
  func colorizeLine(lineNumber: Int, textStorage : NSTextStorage, lineStart: Int, lineEnd: Int) {
    let string = textStorage.string
    let lineLength = lineEnd - lineStart
    let range = NSMakeRange(lineStart, lineLength)
    
    for pattern in self.patterns {
      let match = pattern.regex.firstMatch(in: string, range: range)
      if match != nil {
        textStorage.addAttributes(pattern.color, range: range)
        break
      }
    }
  }

  func colorize(_ textStorage: NSTextStorage, range: NSRange) {
    let string = textStorage.string
    var lineNumber = 1
    var lineStart = 0
    
    for i in 0 ... string.count {
      if string[i] == "\n" {
        
        colorizeLine(lineNumber: lineNumber, textStorage: textStorage,lineStart:lineStart,lineEnd:i)
        
        lineStart = i + 1
        lineNumber += 1
      }
    }

    if (lineStart < string.count) {
      colorizeLine(lineNumber: lineNumber, textStorage: textStorage, lineStart: lineStart, lineEnd: string.count)
    }
  }
}
