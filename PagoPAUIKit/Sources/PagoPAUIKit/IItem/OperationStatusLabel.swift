//
//  OperationStatusLabel.swift
//  
//
//  Created by Pier Domenico Bonamassa on 12/12/23.
//

import SwiftUI

public enum OperationStatus {
    case success
    case failed
    case cancelled
    case pending
    case toBeRefunded
    case refunded
    
    public var backgroundColor: Color {
        switch self {
        case .success:
            return .successLight
        case .failed:
            return .errorLight
        case .pending, .cancelled:
            return .infoLight
        case .refunded:
            return .blueIOLight
        case .toBeRefunded:
            return .warningLight
        }
    }
    
    public var textColor: Color {
        switch self {
        case .success:
            return .successGraphic
        case .failed:
            return .errorDark
        case .pending, .cancelled:
            return .infoDark
        case .refunded:
            return .blueIODark
        case .toBeRefunded:
            return .warningDark
        }
    }
}

public struct OperationStatusLabel: View {
    public var statusType: OperationStatus
    public var statusDescription: String
    
    public init(statusType: OperationStatus, statusDescription: String) {
        self.statusType = statusType
        self.statusDescription = statusDescription
    }
    
    public var body: some View {
        Text(statusDescription)
            .font(.PAFont.caption)
            .foregroundColor(statusType.textColor)
            .padding(.vertical, Constants.xsmallSpacing/2.0)
            .padding(.horizontal, Constants.xsmallSpacing)
            .background {
                Capsule()
                    .fill(statusType.backgroundColor)
            }
    }
}

#Preview {
    VStack {
        OperationStatusLabel(statusType: .success, statusDescription: "ESEGUITA")
        OperationStatusLabel(statusType: .pending, statusDescription: "IN SOSPESO")
        OperationStatusLabel(statusType: .failed, statusDescription: "ANNULATA")
        OperationStatusLabel(statusType: .toBeRefunded, statusDescription: "DA RIMBORSARE")
        OperationStatusLabel(statusType: .refunded, statusDescription: "RIMBORSATA")
    }
}
