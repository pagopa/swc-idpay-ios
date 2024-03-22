//
//  CIELogger.swift
//
//
//  Created by Pier Domenico Bonamassa on 31/01/24.
//

import Foundation

public enum LogMode {
    case enabled
    case localFile
    case disabled
}

internal struct CIELogger {
    
    private let mode: LogMode
    
    private var fileName: String = "LogCIE"
    private var urlLogFile: URL 
    
    internal init(mode: LogMode = .disabled) {
        self.mode = mode
        if mode == .localFile {
        urlLogFile = FileManager.default.temporaryDirectory
                .appendingPathComponent(fileName)
                .appendingPathExtension("log")
        }
    }
    
    internal func log(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {

        guard mode != .disabled else { return }
        var msg = ""
        if !message.isEmpty { msg = "\(message)" }
        
        #if DEBUG
        print(msg)
        #else
        if self.mode == .localFile {
            //Write log to local file
            try? msg.write(to: self.urlLogFile, atomically: true, encoding: .utf8)
        }
        #endif
        
    }
    
    internal func log_APDU_response(_ apduResp: ResponseAPDU, function: String = #function, message: String? = nil) {

        guard mode != .disabled else { return }

        let apduRes = "APDU RESPONSE: " + String.hexStringFromBinary(apduResp.data, asArray: true) + "\n"
        let sw1 = "SW1: " + String.hexStringFromBinary(apduResp.sw1) + "\n"
        let sw2 = "SW2: " + String.hexStringFromBinary(apduResp.sw2)
        
        var msg = ""
        if let message = message {
            msg = "\(message) \n"
        }
        
        if !apduRes.isEmpty {
            msg += apduRes
        }
        if !sw1.isEmpty {
            msg += sw1
        }
        if !sw2.isEmpty {
            msg += sw2
        }
        
        let hexString: String = Data(apduResp.data).hexEncodedString(options: .upperCase)
        msg += "------- APDU RESPONSE HEX STRING --------"
        msg += hexString
        
    #if DEBUG
        print(msg)
    #else
        if self.mode == .localFile {
            //Write log to local file
            try? msg.write(to: self.urlLogFile, atomically: true, encoding: .utf8)
        }
    #endif
    }
}
