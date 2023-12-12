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
    case pending
    case toBeRefunded
    case refunded
    
    public var backgroundColor: Color {
        switch self {
            case .success:
                return .successLight
            case .failed:
                return .errorLight
            case .pending:
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
            case .pending:
                return .infoDark
            case .refunded:
                return .blueIODark
            case .toBeRefunded:
                return .warningDark
        }
    }
    
    public var description: String {
        switch self {
            case .success:
                return "ESEGUITA"
            case .failed:
                return "FALLITA"
            case .pending:
                return "IN SOSPESO"
            case .refunded:
                return "RIMBORSATA"
            case .toBeRefunded:
                return "DA RIMBORSARE"
        }
    }
}


public struct OperationStatusLabel: View {
    public var status: OperationStatus
    
    public init(status: OperationStatus) {
        self.status = status
    }
    
    public var body: some View {
        Text(status.description)
            .font(.PAFont.caption)
            .foregroundColor(status.textColor)
            .padding(.vertical, Spacings.xsmall.rawValue/2.0)
            .padding(.horizontal, Spacings.xsmall.rawValue)
            .background{
                Capsule()
                    .fill(status.backgroundColor)
            }
    }
}

#Preview {
    VStack {
        OperationStatusLabel(status: .success)
        OperationStatusLabel(status: .pending)
        OperationStatusLabel(status: .failed)
        OperationStatusLabel(status: .toBeRefunded)
        OperationStatusLabel(status: .refunded)
    }
}

