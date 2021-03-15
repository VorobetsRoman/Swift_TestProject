//
//  KeyChain.swift
//  TestIssue
//
//  Created by Роман Воробец on 14.03.2021.
//

import Foundation

class KeyChain {
    class func save(key: String, string: String) -> OSStatus {
        let query: [String : Any] = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : string ]
        
        SecItemDelete(query as CFDictionary)
        
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    
    
    
    //===============================================
    class func load(key: String) -> String? {
        let query: [String : Any]  = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ]
        
//        var dataTypeRef: AnyObject? = nil
        
//        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
          SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        // Check the return status and throw an error if appropriate.
        guard status != errSecItemNotFound else { return "" } //throw KeychainError.noPassword }
        guard status == noErr else { return "" }// throw KeychainError.unhandledError(status: status) }
        
        // Parse the password string from the query result.
        guard let existingItem = queryResult, // as? [String : AnyObject],
              let passwordData = existingItem as? Data,
//          let passwordData = existingItem[kSecValueData as String] as? Data,
          let password = String(data: passwordData, encoding: String.Encoding.utf8)
          else {
            return ""
//            throw KeychainError.unexpectedPasswordData
        }
        
//        return existingItem
        return password
//        if status == noErr {
//            return dataTypeRef as! String?
//        } else {
//            return nil
//        }
    }
    
    
    
    
    //===============================================
//    class func createUniqueID() -> String {
//        let uuid: CFUUID = CFUUIDCreate(nil)
//        let cfStr: CFString = CFUUIDCreateString(nil, uuid)
//
//        let swiftString: String = cfStr as String
//        return swiftString
//    }
}




//===============================================
//extension Data {
//
//    init<T>(from value: T) {
//        var value = value
//        var myData = Data()
//        withUnsafePointer(to:&value, { (ptr: UnsafePointer<T>) -> Void in
//            myData = Data( buffer: UnsafeBufferPointer(start: ptr, count: 1))
//        })
//        self.init(myData)
////        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
//    }
//
//    func to<T>(type: T.Type) -> T {
//        return self.withUnsafeBytes { $0.load(as: T.self) }
//    }
//}
//extension Data {
//    init<T>(value: T) {
//        self = withUnsafePointer(to: value) { (ptr: UnsafePointer<T>) -> Data in
//            return Data(buffer: UnsafeBufferPointer(start: ptr, count: 1))
//        }
//    }
//
//    mutating func append<T>(value: T) {
//        withUnsafePointer(to: value) { (ptr: UnsafePointer<T>) in
//            append(UnsafeBufferPointer(start: ptr, count: 1))
//        }
//    }
//}
