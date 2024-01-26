//
//  TagReader.swift
//  NFCTagReader
//
//  Created by Stefania Castiglioni on 25/01/24.
//

import Foundation
import CoreNFC

class TagReader {
    
    private var tag: NFCISO7816Tag
    
    init( tag: NFCISO7816Tag ) {
        self.tag = tag
    }
    
    func selectMasterFile() async throws  {
        print("Select Master File -->")
        let apdu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0xA4, p1Parameter: 0x00, p2Parameter: 0x0C, data: Data([0x3f,0x00]), expectedResponseLength: -1)
        
        _ = try await send( cmd: apdu)
    }
    
    func selectIAS() async throws -> ResponseAPDU {
        print("Select IAS -->")
        guard let apdu = NFCISO7816APDU(data: Data([0x00, 0xA4, 0x04, 0x0C, 0x0d, 0xA0, 0x00, 0x00, 0x00, 0x30, 0x80, 0x00, 0x00, 0x00, 0x09, 0x81, 0x60, 0x01])) else {
            fatalError("Wrong APDU command")
        }
        
        return try await send(cmd: apdu)
    }
    
    func selectCIE() async throws -> ResponseAPDU {
        print("Select CIE -->")
        guard let apdu = NFCISO7816APDU(data: Data([0x00, 0xA4, 0x04, 0x0C, 0x06, 0xA0, 0x00, 0x00, 0x00, 0x00, 0x39])) else {
            fatalError("Wrong APDU command")
        }
        
        return try await send(cmd: apdu)
    }
    
    func readNIS() async throws -> ResponseAPDU {
        print("Read NIS -->")
        guard let apdu = NFCISO7816APDU(data: Data([0x00, 0xB0, 0x81, 0x00, 0x0C])) else {
            fatalError("Wrong APDU command")
        }
        
        return try await send(cmd: apdu)
    }
    
    func readPublicKey() async throws -> [UInt8] {
        print("Select Public key -->")
        
        guard let firstApdu = NFCISO7816APDU(data: Data([0x00, 0xB0, 0x85, 0x00, 0x00])),
              let secondApdu = NFCISO7816APDU(data: Data([0x00, 0xB0, 0x85, 0xE7, 0x00])) else {
            fatalError("Wrong APDU command")
        }
        do {
            let firstResponse = try await tag.sendCommand(apdu: firstApdu)
            var firstRep = ResponseAPDU(data: [UInt8](firstResponse.0), sw1: firstResponse.1, sw2: firstResponse.2)
            print(String(format:"Public key - First APDU response:\n \(String.binToHexRep(firstRep.data, asArray:true)), sw1:0x%02x sw2:0x%02x", firstRep.sw1, firstRep.sw2))
            
            let secondResponse = try await tag.sendCommand(apdu: secondApdu)
            var secondRep = ResponseAPDU(data: [UInt8](secondResponse.0), sw1: secondResponse.1, sw2: secondResponse.2)
            print(String(format:"Public key - Second APDU response:\n \(String.binToHexRep(secondRep.data, asArray:true)), sw1:0x%02x sw2:0x%02x", secondRep.sw1, secondRep.sw2))
            
            let mergedBytes = firstRep.data + secondRep.data
            return mergedBytes
            // TODO: mergedBytes contiene la chiave pubblica completa, forse è necessario estrapolare l'esponente
            
        } catch {
            print("Error:\(error)")
            throw error
        }
    }
    
    func send( cmd: NFCISO7816APDU ) async throws -> ResponseAPDU {
        print( "TagReader - sending \(cmd)" )
        var toSend = cmd
        
        let (data, sw1, sw2) = try await tag.sendCommand(apdu: toSend)
        var rep = ResponseAPDU(data: [UInt8](data), sw1: sw1, sw2: sw2)
        
        print("\(String(format:"TagReader response: \(String.binToHexRep(rep.data, asArray:true)), sw1:0x%02x sw2:0x%02x", rep.sw1, rep.sw2))" )
            
        if rep.sw1 != 0x90 && rep.sw2 != 0x00 {
            print( "Error reading tag: sw1 - 0x\(String.binToHexRep(sw1)), sw2 - 0x\(String.binToHexRep(sw2))" )
            let tagError: CIEReaderError
            
            if (rep.sw1 == 0x63 && rep.sw2 == 0x00) {
                tagError = .invalidTag
            } else {
                let errorMsg = self.decodeError(sw1: rep.sw1, sw2: rep.sw2)
                print("reason: \(errorMsg)" )
                tagError = CIEReaderError.responseError(errorMsg)
            }
            throw tagError
        }

        return rep
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
        
        return "Unknown error - sw1: 0x\(String.binToHexRep(sw1)), sw2 - 0x\(String.binToHexRep(sw2)) "
    }
    
    
}
