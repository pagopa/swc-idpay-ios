//
//  File.swift
//  
//
//  Created by Stefania Castiglioni on 26/01/24.
//

import Foundation

extension String {

    public static func binToHexRep( _ val : [UInt8], asArray : Bool = false ) -> String {
        var string = asArray ? "[" : ""
        for x in val {
            if asArray {
                string += String(format:"0x%02x, ", x )

            } else {
                string += String(format:"%02x", x )
            }
        }
        string += asArray ? "]" : ""
        return asArray ? string : string.uppercased()
    }

    public static func binToHexRep( _ val : UInt8 ) -> String {
        let string = String(format:"%02x", val ).uppercased()
        return string
    }

}
