//
//  TagReader.swift
//  NFCTagReader
//
//  Created by Stefania Castiglioni on 25/01/24.
//

import Foundation
import CoreNFC

class TagReader {
    
    // MARK: - Variables
    private var tag: NFCISO7816Tag
    var loggerManager: CIELogger
    
    // MARK: - Init method
    init( tag: NFCISO7816Tag, logger: CIELogger ) {
        self.tag = tag
        self.loggerManager = logger
    }
    
    // MARK: - Selections
    func selectMasterFile() async throws  {
        loggerManager.log("\nRead Master File -->")
        let apdu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0xA4, p1Parameter: 0x00, p2Parameter: 0x0C, data: Data([0x3f,0x00]), expectedResponseLength: -1)
        
        _ = try await send( cmd: apdu)
    }
    
    func selectIAS() async throws -> ResponseAPDU {
        loggerManager.log("\nRead IAS -->")
        guard let apdu = NFCISO7816APDU(data: Data([0x00, 0xA4, 0x04, 0x0C, 0x0d, 0xA0, 0x00, 0x00, 0x00, 0x30, 0x80, 0x00, 0x00, 0x00, 0x09, 0x81, 0x60, 0x01])) else {
            fatalError("Wrong APDU command")
        }
        
        let IASResponse = try await send(cmd: apdu)
        
        loggerManager.log_APDU_response(IASResponse, message: "Response IAS: ")
        return IASResponse
    }
    
    func selectCIE() async throws -> ResponseAPDU {
        loggerManager.log("\nRead CIE -->")
        guard let apdu = NFCISO7816APDU(data: Data([0x00, 0xA4, 0x04, 0x0C, 0x06, 0xA0, 0x00, 0x00, 0x00, 0x00, 0x39])) else {
            fatalError("Wrong APDU command")
        }
        let CIEResponse = try await send(cmd: apdu)
        
        loggerManager.log_APDU_response(CIEResponse, message: "Response CIE: ")
        return CIEResponse
    }
    
    // MARK: - Reading
    func readNIS() async throws -> ResponseAPDU {
        loggerManager.log("\nRead NIS -->")
        guard let apdu = NFCISO7816APDU(data: Data([0x00, 0xB0, 0x81, 0x00, 0x0C])) else {
            fatalError("Wrong APDU command")
        }
        let NISResponse = try await send(cmd: apdu)
        
        loggerManager.log_APDU_response(NISResponse, message: "Response NIS: ")
        loggerManager.log("NIS string value: \(String.hexStringFromBinary(NISResponse.data))")
        return NISResponse
        
    }
    
    func readPublicKey() async throws -> [UInt8] {
        loggerManager.log("\nRead Public key -->")
        
        guard let firstApdu = NFCISO7816APDU(data: Data([0x00, 0xB0, 0x85, 0x00, 0x00])),
              let secondApdu = NFCISO7816APDU(data: Data([0x00, 0xB0, 0x85, 0xE7, 0x00])) else {
            fatalError("Wrong APDU command")
        }
        do {
            let firstResponse = try await tag.sendCommand(apdu: firstApdu)
            var firstRep = ResponseAPDU(data: [UInt8](firstResponse.0), sw1: firstResponse.1, sw2: firstResponse.2)
            loggerManager.log_APDU_response(firstRep, message: "Public key - First APDU response:")
            let secondResponse = try await tag.sendCommand(apdu: secondApdu)
            var secondRep = ResponseAPDU(data: [UInt8](secondResponse.0), sw1: secondResponse.1, sw2: secondResponse.2)
            loggerManager.log_APDU_response(secondRep, message: "Public key - Second APDU response:")
            
            let mergedBytes = firstRep.data + secondRep.data
//            loggerManager.log("Public key - MERGED:\n \(String.hexStringFromBinary(mergedBytes, asArray:true))")
            
            loggerManager.log("\n------------ START PUBLIC KEY ------------------")
            var publicKeyData: Data = mergedBytes.withUnsafeBufferPointer { Data(buffer: $0) }
            let hexPublicKey: String = publicKeyData.hexEncodedString(options: .upperCase)
            loggerManager.log("\(hexPublicKey)")
            loggerManager.log("------------ END PUBLIC KEY ------------------\n\n")
            
            return mergedBytes
            
        } catch {
            loggerManager.log("ERROR read Public Key: \(error)")
            throw error
        }
    }

    func readSODFile() async throws -> [UInt8] {
        var sodIASData = [UInt8]()
        var idx = 0
        var size = 0xe4
        var sodLoaded = false
        
        var apdu: [UInt8] = [0x00, 0xB1, 0x00, 0x06]
        
        loggerManager.log("\nRead SOD -->")
        while !sodLoaded {
            var offset =  idx.toByteArray(pad: 4)
            var dataInput = [0x54, 0x02, offset[0], offset[1]]
            
            let resp = try await sendApdu(head: apdu, data: dataInput, le: [0xe7])
            var chn = resp.data

            var newOffset = 2
            
            if (chn[1] > 0x80) {
                newOffset += Int(chn[1] - 0x80)
            }
            
            var buf = chn[newOffset..<chn.count]
            var combined = sodIASData + buf
            sodIASData = combined
            
            if resp.sw1 != 0x90 && resp.sw2 != 0x00 {
                sodLoaded = true
            } else {
                idx += size
            }

        }
        
        loggerManager.log("\n------------ START SOD ------------------")
        loggerManager.log(String.hexStringFromBinary(sodIASData, asArray:true))
        loggerManager.log("------------ END SOD ------------------\n\n")

        return sodIASData
    }
    
    func intAuth(challenge: String) async throws -> [UInt8] {
        // REAL CHALLENGE
//        var challengeByte: [UInt8] = challenge.byteArrayFromHexString()
        // TEST CHALLENGE:
        var challengeByte: [UInt8] = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]
        return try await signIntAuth(challengeByte)
    }

    private func signIntAuth(_ dataToSign: [UInt8]) async throws -> [UInt8]  {
        guard let settingAuth = NFCISO7816APDU(data: Data([0x00, 0x22, 0x41, 0xA4, 0x06, 0x80, 0x01, 0x02, 0x84, 0x01, 0x83])) else { return [] }
        let respSettingAuth = try await send(cmd: settingAuth)
        
        let intAuthApdu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0x88, p1Parameter: 0x00, p2Parameter: 0x00, data: Data(dataToSign), expectedResponseLength: 256)
        let responseAuthChallenge = try await send(cmd: intAuthApdu)
        
        // Debug prints
        loggerManager.log("\n\n------- START AUTH CHALLENGE RESPONSE --------")
        loggerManager.log(String(format:"\(String.hexStringFromBinary(responseAuthChallenge.data, asArray:true)), sw1:0x%02x sw2:0x%02x", responseAuthChallenge.sw1, responseAuthChallenge.sw2))
        let hexIntAuth: String = Data(responseAuthChallenge.data).hexEncodedString(options: .upperCase)
        loggerManager.log("------- HEX STRING --------")
        loggerManager.log("\(hexIntAuth)")
        loggerManager.log("------- END AUTH CHALLENGE RESPONSE --------\n\n")
        
        return responseAuthChallenge.data
    }

    
    // MARK: - Commands
    func send(cmd: NFCISO7816APDU) async throws -> ResponseAPDU {
        var toSend = cmd
        
        let (data, sw1, sw2) = try await tag.sendCommand(apdu: toSend)
        var rep = ResponseAPDU(data: [UInt8](data), sw1: sw1, sw2: sw2)
        
        if rep.sw1 != 0x90 && rep.sw2 != 0x00 {
            loggerManager.log( "🔴 [ERROR] reading tag: sw1 - 0x\(String.hexStringFromBinary(sw1)), sw2 - 0x\(String.hexStringFromBinary(sw2))" )
            let tagError: CIEReaderError
            
            if (rep.sw1 == 0x63 && rep.sw2 == 0x00) {
                tagError = .invalidTag
            } else {
                let errorMsg = self.decodeError(sw1: rep.sw1, sw2: rep.sw2)
                loggerManager.log("🔴 [ERROR] reason: \(errorMsg)" )
                tagError = CIEReaderError.responseError(errorMsg)
            }
            throw tagError
        }
        
        return rep
    }
    
    private func sendApdu(head: [UInt8], data: [UInt8], le: [UInt8]?) async throws -> ResponseAPDU {

            var apdu = [UInt8]()
            var headMod = head
            var ds: Int = data.count
            
            if(ds > 255){
                var i = 0
                var cla: UInt8 = head[0]
                
                while(true){
                    var s: [UInt8] = Utils.getSubArray(from: data, start: i, end: min((data.count-i), 255))
                    i += s.count
                    if(i != data.count) {
                        headMod[0] = (UInt8)(cla | 0x10)
                    }
                    else {
                        headMod[0] = cla
                    }
                    
                    apdu.append(contentsOf: headMod)
                    apdu.append(contentsOf: s.count.toByteArray(pad: 2))
                    apdu.append(contentsOf: s)
                    if(le != nil) {
                        apdu += le!
                    }
                    
                    guard var modApdu = NFCISO7816APDU(data: Data(apdu)) else {
                        throw CIEReaderError.responseError("Error constructing apdu")
                    }
                    
                    let (data, sw1, sw2) = try await tag.sendCommand(apdu: modApdu)
                    var rep = ResponseAPDU(data: [UInt8](data), sw1: sw1, sw2: sw2)
                                        
                    if rep.sw1 != 0x90 && rep.sw2 != 0x00 {
                        loggerManager.log( "🔴 [ERROR] reading tag: sw1 - 0x\(String.hexStringFromBinary(sw1)), sw2 - 0x\(String.hexStringFromBinary(sw2))" )
                        let tagError: CIEReaderError
                        
                        if (rep.sw1 == 0x63 && rep.sw2 == 0x00) {
                            tagError = .invalidTag
                        } else {
                            let errorMsg = self.decodeError(sw1: rep.sw1, sw2: rep.sw2)
                            loggerManager.log("🔴 [ERROR] reason: \(errorMsg)" )
                            tagError = CIEReaderError.responseError(errorMsg)
                        }
                        throw tagError
                    }
                    
                    if i == data.count {
                        return rep
                    }

                }
            } else {
                
                if(data.isEmpty == false){
                    apdu.append(contentsOf: headMod)
                    apdu.append(contentsOf: data.count.toByteArray(pad: 2))
                    apdu += data

                    if(le != nil) {
                        apdu += le!
                    }
                    
                } else {
                    apdu += head
                    
                    if(le != nil) {
                        apdu += le!
                    }
                }
                
                guard var modApdu = NFCISO7816APDU(data: Data(apdu)) else {
                    throw CIEReaderError.responseError("Error constructing apdu")
                }
                
                let (data, sw1, sw2) = try await tag.sendCommand(apdu: modApdu)
                var rep = ResponseAPDU(data: [UInt8](data), sw1: sw1, sw2: sw2)
                
                return rep
            }
    }

}

// MARK: - Error Helper
extension TagReader {
    
    private func decodeError( sw1: UInt8, sw2:UInt8 ) -> String {
        
        let errors : [UInt8 : [UInt8:String]] = [
            0x62: [0x00:"No information given",
                   0x81:"Part of returned data may be corrupted",
                   0x82:"End of file/record reached before reading Le bytes",
                   0x83:"Selected file invalidated",
                   0x84:"FCI not formatted according to ISO7816-4 section 5.1.5"],
            
            0x63: [0x81:"File filled up by the last write",
                   0x82:"Card Key not supported",
                   0x83:"Reader Key not supported",
                   0x84:"Plain transmission not supported",
                   0x85:"Secured Transmission not supported",
                   0x86:"Volatile memory not available",
                   0x87:"Non Volatile memory not available",
                   0x88:"Key number not valid",
                   0x89:"Key length is not correct",
                   0xC:"Counter provided by X (valued from 0 to 15) (exact meaning depending on the command)"],
            0x65: [0x00:"No information given",
                   0x81:"Memory failure"],
            0x67: [0x00:"Wrong length"],
            0x68: [0x00:"No information given",
                   0x81:"Logical channel not supported",
                   0x82:"Secure messaging not supported",
                   0x83:"Last command of the chain expected",
                   0x84:"Command chaining not supported"],
            0x69: [0x00:"No information given",
                   0x81:"Command incompatible with file structure",
                   0x82:"Security status not satisfied",
                   0x83:"Authentication method blocked",
                   0x84:"Referenced data invalidated",
                   0x85:"Conditions of use not satisfied",
                   0x86:"Command not allowed (no current EF)",
                   0x87:"Expected SM data objects missing",
                   0x88:"SM data objects incorrect"],
            0x6A: [0x00:"No information given",
                   0x80:"Incorrect parameters in the data field",
                   0x81:"Function not supported",
                   0x82:"File not found",
                   0x83:"Record not found",
                   0x84:"Not enough memory space in the file",
                   0x85:"Lc inconsistent with TLV structure",
                   0x86:"Incorrect parameters P1-P2",
                   0x87:"Lc inconsistent with P1-P2",
                   0x88:"Referenced data not found"],
            0x6B: [0x00:"Wrong parameter(s) P1-P2]"],
            0x6D: [0x00:"Instruction code not supported or invalid"],
            0x6E: [0x00:"Class not supported"],
            0x6F: [0x00:"No precise diagnosis"],
            0x90: [0x00:"Success"] //No further qualification
        ]
        
        // Special cases - where sw2 isn't an error but contains a value
        if sw1 == 0x61 {
            return "SW2 indicates the number of response bytes still available - (\(sw2) bytes still available)"
        } else if sw1 == 0x64 {
            return "State of non-volatile memory unchanged (SW2=00, other values are RFU)"
        } else if sw1 == 0x6C {
            return "Wrong length Le: SW2 indicates the exact length - (exact length :\(sw2))"
        }
        
        if let dict = errors[sw1], let errorMsg = dict[sw2] {
            return errorMsg
        }
        
        return "Unknown error - sw1: 0x\(String.hexStringFromBinary(sw1)), sw2 - 0x\(String.hexStringFromBinary(sw2)) "
    }
    
    
}
