//
//  QRCodeGenerator.swift
//  SWC-iDPay-iOS
//
//  Created by Stefania Castiglioni on 22/03/24.
//

import Foundation
import CoreImage.CIFilterBuiltins
import UIKit

class QRCodeGenerator {
    
    static func generateQRCode(from string: String?) -> UIImage {
        
        guard let qrCodeString = string else {
            return UIImage()
        }

        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()

        filter.message = Data(qrCodeString.utf8)

        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }

}
