//
//  CIEReader.swift
//  NFCTagReader
//
//  Created by Stefania Castiglioni on 25/01/24.
//

import Foundation
import CoreNFC

public enum CIEReaderError: Error, CustomStringConvertible {
    case scanNotSupported
    case invalidTag
    case responseError(String)
    
    public var description: String {
        switch self {
        case .scanNotSupported:
            return "This device doesn't support tag scanning"
        case .responseError(let message):
            return message
        default:
            return "Error reading tag"
        }
    }
}

public class CIEReader: NSObject {
    
    private var session: NFCTagReaderSession?
    private var activeContinuation: CheckedContinuation<NisAuthenticated?, Error>?
    
    private var readCardMessage: String
    private var confirmCardReadMessage: String
    
    public init(readCardMessage: String = "Avvicina la CIE al lettore", confirmCardReadMessage: String = "Lettura carta OK") {
        self.readCardMessage = readCardMessage
        self.confirmCardReadMessage = confirmCardReadMessage
    }
    
    public func scan() async throws -> NisAuthenticated? {
        guard NFCTagReaderSession.readingAvailable else {
            throw CIEReaderError.scanNotSupported
        }
        
        let publicKey = try await withCheckedThrowingContinuation { continuation in
            activeContinuation = continuation
            session = NFCTagReaderSession(pollingOption: [.iso14443], delegate: self, queue: DispatchQueue.main)
            session?.alertMessage = readCardMessage
            session?.begin()
        }
        
        session?.invalidate()
        return publicKey
    }
    
}

extension CIEReader: NFCTagReaderSessionDelegate {
    
    public func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("-----  Session started -------")
    }
    
    public func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        
        if let readerError = error as? NFCReaderError, readerError.code == NFCReaderError.readerSessionInvalidationErrorUserCanceled {
            activeContinuation?.resume(returning: nil)
            activeContinuation = nil
        } else {
            activeContinuation?.resume(throwing: error)
            activeContinuation = nil
        }
        print("-----  Session ended -------")
    }
    
    public func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        
        if tags.count > 1 {
            // Restart polling in 500ms
            let retryInterval = DispatchTimeInterval.milliseconds(500)
            session.alertMessage = "More than 1 tag is detected, please remove all tags and try again."
            Task(priority: .userInitiated) {
                session.restartPolling()
            }
            return
        }
        
        let tag = tags.first!
        
        var cieTag: NFCISO7816Tag
        switch tags.first! {
        case let .iso7816(tag):
            cieTag = tag
        default:
            print( "tagReaderSession: invalid tag detected!!!" )
            session.invalidate(errorMessage: "Error reading CIE: Invalid tag detected")
            activeContinuation?.resume(throwing: CIEReaderError.invalidTag)
            activeContinuation = nil
            return
        }
        
        Task { [cieTag] in
            do {
                try await session.connect(to: tag)
                let tagReader = TagReader(tag:cieTag)
                
                do {
                    let responseIAS = try await tagReader.selectIAS()
                    print("ResponseIAS:\(responseIAS)")
                } catch {
                    // In some CIEs, IAS reading returns a file not found error. In these cases continue anyway
                    print("--- IAS file not found in TAG --> Continue reading --->")
//                    try await tagReader.selectMasterFile()
                }
                
                let responseCIE = try await tagReader.selectCIE()
                print("ResponseCIE:\(responseCIE)")
                
                let responseNIS = try await tagReader.readNIS()
                print("ResponseNIS:\(responseNIS)")
                
                let efIntServ1001 = responseNIS.data
                print("NIS:\(String(bytes: efIntServ1001, encoding: .utf8))")
                
                let publicKey = try await tagReader.readPublicKey()
                
                let sod = try await tagReader.readSODFile()
                print("SOD response:\n \(String.hexStringFromBinary(sod, asArray:true))")

                let challengeSigned = try await tagReader.intAuth(challenge: "")

                let nisAuthenticated = NisAuthenticated(
                    nis: String.base64StringFromBinary(efIntServ1001),
                    kpubIntServ: String.base64StringFromBinary(publicKey),
                    haskKpubIntServ: "",
                    sod: String.base64StringFromBinary(sod),
                    challengeSigned: String.base64StringFromBinary(challengeSigned)
                )
                session.alertMessage = confirmCardReadMessage
                activeContinuation?.resume(returning: nisAuthenticated)
                activeContinuation = nil
            } catch {
                if let error = error as? CIEReaderError {
                    session.invalidate(errorMessage: "Error reading CIE: \(error.description)")
                } else {
                    session.invalidate(errorMessage: "Error reading CIE: \(error.localizedDescription)")
                }
                activeContinuation?.resume(throwing: CIEReaderError.responseError("error"))
                activeContinuation = nil
            }
        }
    }
}
