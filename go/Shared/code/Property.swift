//
//  Property.swift
//  RCUserDefaults
//
//  Created by roy.cao on 2019/3/24.
//  Copyright © 2019 roy. All rights reserved.
//

import Foundation
import ObjectiveC

/// Objective-C type encoding
enum ObjCTypeEncoding {
    case int
    case longLong
    case float
    
    case double
    case bool
    case char
    
    case object
    case uInt8
    case unknown(String)

    init(e encoding: String) {
        switch encoding {
        case "i": self = .int
        case "q": self = .longLong
        case "f": self = .float
        case "d": self = .double
        case "B": self = .bool
        case "c": self = .char
        case "C": self = .uInt8
        case "@": self = .object   // string
        default:
            self = .unknown(encoding)
        }
    }
}

struct Property {

    let name: String

    private(set) var typeEncoding = ObjCTypeEncoding.unknown("?")

    private(set) var type: NSObject.Type?

    /// The property defines a custom getter selector name. The name follows the G (for example, GcustomGetter,).
    private(set) var customGetter: String?

    /// The property defines a custom setter selector name. The name follows the S (for example, ScustomSetter:,).
    private(set) var customSetter: String?

    init(x property: objc_property_t) {
        name = String(cString: property_getName(property))

        var count: UInt32 = 0
        let attributeList = property_copyAttributeList(property, &count)!
        
        for i in 0..<Int(count) {
            let attribute = attributeList[i]

            let nick = String(cString: attribute.name)
            let value = String(cString: attribute.value)
            
            switch nick {
            case "T":
                var value = value
                if value.hasPrefix("@\"") && value.hasSuffix("\"") { // id
                    value = value
                        .replacingOccurrences(of: "@\"", with: "")
                        .replacingOccurrences(of: "\"", with: "")
                }
                else if value.hasPrefix("r") { // const
                    value = value.replacingOccurrences(of: "r", with: "")
                }
                
                if value.classExists{
                    //  string
                    //  stringOptional
                    //  data
                    typeEncoding = ObjCTypeEncoding(e: "@")
                    type = value.getClass
                }
                else {
                    //  bool
                    //  double
                    // print(name)
                    typeEncoding = ObjCTypeEncoding(e: value)
                }
            case "G":
                // 没走
                customGetter = value
            case "S":
                // 没走
                customSetter = value
            default: break
            }
        }

        free(attributeList)
    }
}

extension NSObject {

    static var properties: [Property] {
        var count: UInt32 = 0
        guard let propertyList = class_copyPropertyList(self, &count) else { return [] }

        var properties = [Property]()
        let cnt = Int(count)
        for i in 0..<cnt{
            properties.append(Property(x: propertyList[i]))
        }
        free(propertyList)
        return properties
    }
}


extension String{
    
    var classExists: Bool {
        return objc_getClass(cString(using: .utf8)!) != nil
    }

    var getClass: NSObject.Type? {
        return objc_getClass(cString(using: .utf8)!) as? NSObject.Type
    }
    
    
}
