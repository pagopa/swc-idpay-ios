//
//  CIEReader.swift
//  NFCTagReader
//
//  Created by Stefania Castiglioni on 25/01/24.
//

import Foundation
import CoreNFC

public enum CIEReaderError: Error, CustomStringConvertible, Equatable {
    case scanNotSupported
    case invalidTag
    case sendCommandForResponse
    case responseError(String)
    
    public var description: String {
        switch self {
        case .scanNotSupported:
            return "This device doesn't support tag scanning"
        case .responseError(let message):
            return message
        case .invalidTag:
            return "Error reading tag"
        case .sendCommandForResponse:
            return "Send command to read response"
        default:
            return "Generic error retrived reading tag"
        }
    }
}

public class CIEReader: NSObject, CIEReadable {
    
    private var session: NFCTagReaderSession?
    private var activeContinuation: CheckedContinuation<NisAuthenticated?, Error>?
    
    private var readCardMessage: String
    private var confirmCardReadMessage: String
    var loggerManager: CIELogger
    var urlLogFile: URL? = nil
    var challenge: String?
    
    required public init(readCardMessage: String = "Avvicina la CIE al lettore", confirmCardReadMessage: String = "Lettura carta OK", logMode: LogMode = .disabled) {
        self.readCardMessage = readCardMessage
        self.confirmCardReadMessage = confirmCardReadMessage
        loggerManager = CIELogger(mode: logMode)
    }
    
    public func scan(challenge: String) async throws -> NisAuthenticated? {
        guard NFCTagReaderSession.readingAvailable else {
            throw CIEReaderError.scanNotSupported
        }
        
        self.challenge = challenge
        let publicKey = try await withCheckedThrowingContinuation { continuation in
            activeContinuation = continuation
            session = NFCTagReaderSession(pollingOption: [.iso14443], delegate: self, queue: DispatchQueue.main)
            session?.alertMessage = readCardMessage
            session?.begin()
        }
        
        session?.invalidate()
        loggerManager.log("-------------------------------------\n" +
                        "          Session ENDED              \n" +
                        "-------------------------------------\n")
        return publicKey
    }
    
}

extension CIEReader: NFCTagReaderSessionDelegate {
    
    public func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        loggerManager.log("-------------------------------------\n" +
                        "          Session STARTED            \n" +
                        "-------------------------------------")
        session.alertMessage = "LETTURA IN CORSO\ntieni ferma la carta per qualche secondo..."
    }
    
    public func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        
        if let readerError = error as? NFCReaderError{
            switch readerError.code {
            case .readerSessionInvalidationErrorUserCanceled:
                activeContinuation?.resume(returning: nil)
                activeContinuation = nil
            default:
                session.alertMessage = NFCReaderError.decodeError(readerError) ?? ""
                activeContinuation?.resume(throwing: error)
                activeContinuation = nil
            }
        } else {
            activeContinuation?.resume(throwing: error)
            activeContinuation = nil
        }
        loggerManager.log("-------------------------------------\n" +
                        "          Session ENDED              \n" +
                        "-------------------------------------\n")
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
            loggerManager.log(CIEReaderError.invalidTag.description)
            session.invalidate(errorMessage: CIEReaderError.invalidTag.description)
            activeContinuation?.resume(throwing: CIEReaderError.invalidTag)
            activeContinuation = nil
            return
        }
        
        Task { [cieTag] in
            do {
                try await session.connect(to: tag)
                let tagReader = TagReader(tag:cieTag, logger: self.loggerManager)
                
                do {
                    let responseIAS = try await tagReader.selectIAS()
                } catch {
                    // In some CIEs, IAS reading returns a file not found error. In these cases continue anyway
                    loggerManager.log("IAS file not found in TAG\n\nContinue reading --->")
//                    try await tagReader.selectMasterFile()
                }
                
                let responseCIE = try await tagReader.selectCIE()
                
                let responseNIS = try await tagReader.readNIS()
                
                let efIntServ1001 = Data(responseNIS.data)
                
                let publicKey = try await tagReader.readPublicKey()
                
                let sod = try await tagReader.readSODFile()

                guard let challenge = challenge else {
                    throw CIEReaderError.responseError("Challenge is nil")
                }
                
                let challengeSigned = try await tagReader.intAuth(challenge: challenge)

                guard let nis = String(data: efIntServ1001, encoding: .utf8) else {
                    throw CIEReaderError.responseError("Cannot encode NIS")
                }
                
                let nisAuthenticated = NisAuthenticated(
                    nis: nis,
                    kpubIntServ: String.base64StringFromBinary(publicKey),
                    haskKpubIntServ: "",
                    sod: String.base64StringFromBinary(sod),
                    challengeSigned: String.base64StringFromBinary(challengeSigned)
                )
                session.alertMessage = confirmCardReadMessage
                activeContinuation?.resume(returning: nisAuthenticated)
                activeContinuation = nil
            } catch {
                if let CIE_error = error as? CIEReaderError {
                    session.invalidate(errorMessage: "Error reading CIE: \(CIE_error.description)")
                } else if let NFC_error = error as? NFCReaderError {
                    if let message = NFCReaderError.decodeError(NFC_error) {
                        session.invalidate(errorMessage: message)
                    } else {
                        session.invalidate()
                    }
                }
                activeContinuation?.resume(throwing: error)
                activeContinuation = nil
            }
        }
    }
}

extension NFCReaderError {
    
    public static func decodeError(_ error: NFCReaderError) -> String? {
        switch error.code {
        case .readerTransceiveErrorTagConnectionLost, .readerTransceiveErrorTagResponseError:
            return "Hai rimosso la carta troppo presto"
        case .readerSessionInvalidationErrorUserCanceled:
            return nil
        default:
            return "Lettura carta non riuscita"
        }
    }

}
