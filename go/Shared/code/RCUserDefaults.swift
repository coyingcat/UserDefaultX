//
//  RCUserDefaults.swift
//  RCUserDefaults
//
//  Created by roy.cao on 2019/3/24.
//  Copyright © 2019 roy. All rights reserved.
//

import Foundation

class RCUserDefaults: NSObject {

    public static let standard = RCUserDefaults()

    public let userDefaults = UserDefaults.standard

    private static var mapping = [String: Property]()

    public init(placeHolder nan: Bool? = nil){
        super.init()

        exchangeAccessMethods()
    }
    
    private static func defaultKeyForSelector(_ sel: Selector) -> String {
        let selName = NSStringFromSelector(sel)
        return mapping[selName]!.name
    }
}

/// Exchange access methods
extension RCUserDefaults {

    private func exchangeAccessMethods(){
        let properties = RCUserDefaults.properties

        for property in properties{

            let getterKey = property.customGetter ?? property.name
            let setterKey = property.customSetter ?? objCDefaultSetterName(for: property.name)
            RCUserDefaults.mapping[getterKey] = property
            RCUserDefaults.mapping[setterKey] = property

            let getterSel : Selector = NSSelectorFromString(getterKey)
            let setterSel : Selector = NSSelectorFromString(setterKey)

            var getterImp: IMP!
            var setterImp: IMP!
            switch property.typeEncoding {
            case .int, .longLong:
                getterImp = unsafeBitCast(RCUserDefaults.longGetter, to: IMP.self)
                setterImp = unsafeBitCast(RCUserDefaults.longSetter, to: IMP.self)
            case .bool, .char:
                getterImp = unsafeBitCast(RCUserDefaults.boolGetter, to: IMP.self)
                setterImp = unsafeBitCast(RCUserDefaults.boolSetter, to: IMP.self)
            case .float:
                getterImp = unsafeBitCast(RCUserDefaults.floatGetter, to: IMP.self)
                setterImp = unsafeBitCast(RCUserDefaults.floatSetter, to: IMP.self)
            case .double:
                getterImp = unsafeBitCast(RCUserDefaults.doubleGetter, to: IMP.self)
                setterImp = unsafeBitCast(RCUserDefaults.doubleSetter, to: IMP.self)
            case .object:
                getterImp = unsafeBitCast(RCUserDefaults.objectGetter, to: IMP.self)
                setterImp = unsafeBitCast(RCUserDefaults.objectSetter, to: IMP.self)
            default:
                NSException(name:NSExceptionName(rawValue: "exchange Access Methods"), reason:"Unsupported type of property", userInfo:nil).raise()
            }

            let setterTypes = "v@:\(property.typeEncoding)"
            let getterTypes = "\(property.typeEncoding)@:"

            setterTypes.withCString { typesCString in
                _ = class_addMethod(classForCoder, setterSel, setterImp, typesCString)
            }

            getterTypes.withCString { typesCString in
                _ = class_addMethod(classForCoder, getterSel, getterImp, typesCString)
            }
        }
    }

    private func objCDefaultSetterName(for propertyName: String) -> String {
        let head = propertyName.uppercased().first!
        let tail = propertyName[propertyName.index(after: propertyName.startIndex)...]
        return "set\(head)\(tail):"
    }
}

/// Getter and Setter Methods
extension RCUserDefaults {

    private static let objectGetter: @convention(c) (RCUserDefaults, Selector) -> Any? = { _userDefault, _cmd in
        let key = defaultKeyForSelector(_cmd)
        return _userDefault.userDefaults.object(forKey: key)
    }

    private static let objectSetter: @convention(c) (RCUserDefaults, Selector, Any?) -> Void = { _userDefault, _cmd, value in
        let key = RCUserDefaults.defaultKeyForSelector(_cmd)
        _userDefault.userDefaults.set(value, forKey: key)
    }

    private static let boolGetter: @convention(c) (RCUserDefaults, Selector) -> Bool = { _userDefault, _cmd in
        let key = RCUserDefaults.defaultKeyForSelector(_cmd)
        return _userDefault.userDefaults.bool(forKey: key)
    }

    private static let boolSetter: @convention(c) (RCUserDefaults, Selector, Bool) -> Void = { _userDefault, _cmd, value in
        let key = RCUserDefaults.defaultKeyForSelector(_cmd)
        _userDefault.userDefaults.set(value, forKey: key)
    }

    private static let longGetter: @convention(c) (RCUserDefaults, Selector) -> CLong = { _userDefault, _cmd in
        let key = defaultKeyForSelector(_cmd)
        return _userDefault.userDefaults.integer(forKey: key)
    }

    private static let longSetter: @convention(c) (RCUserDefaults, Selector, CLong) -> Void = { _userDefault, _cmd, value in
        let key = RCUserDefaults.defaultKeyForSelector(_cmd)
        _userDefault.userDefaults.set(value, forKey: key)
    }

    private static let longLongGetter: @convention(c) (RCUserDefaults, Selector) -> CLongLong = { _userDefault, _cmd in
        let key = defaultKeyForSelector(_cmd)
        let value = _userDefault.userDefaults.integer(forKey: key)
        return CLongLong(value)
    }

    private static let longLongSetter: @convention(c) (RCUserDefaults, Selector, CLongLong) -> Void = { _userDefault, _cmd, value in
        let key = RCUserDefaults.defaultKeyForSelector(_cmd)
        _userDefault.userDefaults.set(Int(value), forKey: key)
    }

    private static let doubleGetter: @convention(c) (RCUserDefaults, Selector) -> CDouble = { _userDefault, _cmd in
        let key = defaultKeyForSelector(_cmd)
        let value = _userDefault.userDefaults.double(forKey: key)
        return CDouble(value)
    }

    private static let doubleSetter: @convention(c) (RCUserDefaults, Selector, CDouble) -> Void = { _userDefault, _cmd, value in
        let key = RCUserDefaults.defaultKeyForSelector(_cmd)
        _userDefault.userDefaults.set(Double(value), forKey: key)
    }

    private static let floatGetter: @convention(c) (RCUserDefaults, Selector) -> CFloat = { _userDefault, _cmd in
        let key = defaultKeyForSelector(_cmd)
        let value = _userDefault.userDefaults.float(forKey: key)
        return CFloat(value)
    }

    private static let floatSetter: @convention(c) (RCUserDefaults, Selector, CFloat) -> Void = { _userDefault, _cmd, value in
        let key = RCUserDefaults.defaultKeyForSelector(_cmd)
        _userDefault.userDefaults.set(value, forKey: key)
    }
}
