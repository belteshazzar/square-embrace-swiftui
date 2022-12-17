//
//  SqrmJS.swift
//  square-embrace-notes
//
//  Created by Daniel Walton on 13/12/2022.
//

import Foundation
import JavaScriptCore

// https://nshipster.com/javascriptcore/
public class SqrmJS {
    
    public static let sharedInstance = SqrmJS()
    
    let context : JSContext
    
    private init() {
        self.context = JSContext()!
        
        guard let url = Bundle.module.url(forResource: "sqrm-0.1.7.iife", withExtension: "js") else {
            fatalError("missing resource sqrm-0.1.7.iife.js")
        }
        let str = try! String(contentsOf: url)
        
        self.context.evaluateScript(str, withSourceURL: url)
    }
    
    public func extractTags(text: String) -> [String] {

        let result : NSDictionary = context.objectForKeyedSubscript("sqrm")
            .call(withArguments: [text])!.toDictionary()! as NSDictionary

//        let json : Data = try! JSONSerialization.data(withJSONObject: result)
//        let jsonStr : String? = String(data: json, encoding: .utf8)
//        print(jsonStr as Any)
//
//        let r = NSDictionary.fromString(text: jsonStr!)!
//        print(r.value(forKey: "json") as Any)
//
//        let tags : NSDictionary = r.value(forKey: "json")! as! NSDictionary

        let json : NSDictionary = result.value(forKey: "json")! as! NSDictionary
        let keys : [String] = json.allKeys as! [String]
        
        let sortedKeys = keys.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
                
        return sortedKeys
    }
}
