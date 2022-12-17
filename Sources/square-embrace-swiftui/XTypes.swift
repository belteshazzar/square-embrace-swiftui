//
//  Types.swift
//  square-embrace-swiftui
//
//  Created by Daniel Walton on 9/12/2022.
//

import SwiftUI

#if os(iOS)
    import UIKit
    public typealias XColor = UIColor
    public typealias XFont = UIFont
    public typealias XFontDescriptor = UIFontDescriptor
    public typealias XTraits = UIFontDescriptor.SymbolicTraits
    public typealias XViewRepresentable = UIViewRepresentable
#elseif os(macOS)
    import AppKit
    public typealias XColor = NSColor
    public typealias XFont = NSFont
    public typealias XFontDescriptor = NSFontDescriptor
    public typealias XTraits = NSFontDescriptor.SymbolicTraits
    public typealias XViewRepresentable = NSViewRepresentable
#endif
