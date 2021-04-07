//
//  extern.swift
//  go
//
//  Created by Jz D on 2021/4/7.
//

import Foundation




extension RCUserDefaults {

    @NSManaged var string: String
    @NSManaged var stringOptional: String?

    @NSManaged var bool: Bool
    @NSManaged var bool2: Bool

    @NSManaged var int: Int
    @NSManaged var int2: Int

    @NSManaged var double: Double
    @NSManaged var double2: Double

    @NSManaged var float: Float
    @NSManaged var float2: Float

    @NSManaged var data: Data
    @NSManaged var dataOptional: Data?

    @NSManaged var any: Any
    @NSManaged var anyOptional: Any?

    @NSManaged var array: [Int]
    @NSManaged var arrayOptional: [Int]?
    @NSManaged var arrayEmpty: [Int]

    @NSManaged var dictionary: [String: Int]
    @NSManaged var dictionaryOptional: [String: Int]?
    @NSManaged var dictionaryEmpty: [String: Int]
    
    
    @NSManaged var name: String
}
