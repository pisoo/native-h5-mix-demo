//
//  Helper.swift
//  NativeH5MixDemo
//
//  Created by CPHKEP on 2021/4/21.
//

import UIKit


extension String {
    var toDictionary: Dictionary<String, Any>? {
        
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

extension Dictionary {
    
    var JSONString: String {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return ""            
        }
        return String(data: data, encoding: String.Encoding.utf8) ?? ""
    }
}



extension UIImage {
    
    var base64String: String {
        guard let imageData = self.pngData() else {
          return ""
        }
        return imageData.base64EncodedString(options: .endLineWithCarriageReturn)
    }
}



