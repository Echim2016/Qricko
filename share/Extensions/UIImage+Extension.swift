//
//  UIImage+Extension.swift
//  share
//
//  Created by Yi-Chin Hsu on 2023/4/4.
//

import UIKit

extension UIImage {
    func getURLFromImage() -> String? {
        guard let image = CIImage(image: self) else { return nil }

        let detector = CIDetector(
            ofType: CIDetectorTypeQRCode,
            context: nil,
            options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        )

        return detector?.features(in: image)
            .compactMap { ($0 as? CIQRCodeFeature)?.messageString }
            .first
    }
}
