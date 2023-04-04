//
//  ShareViewController.swift
//  share
//
//  Created by Yi-Chin Hsu on 2023/4/4.
//

import UIKit
import Social
import UniformTypeIdentifiers

@objc(ShareViewController)
class ShareViewController: UIViewController {
    
    private let imageTypeIdentifier = UTType.image.identifier
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleShareItem()
    }
    
    private func handleShareItem() {
        guard
            let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
            let itemProvider = extensionItem.attachments?.first,
            itemProvider.hasItemConformingToTypeIdentifier(imageTypeIdentifier)
        else {
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
            return
        }
        handleImage(with: itemProvider)
    }
    
    private func handleImage(with itemProvider: NSItemProvider) {
        itemProvider.loadItem(forTypeIdentifier: imageTypeIdentifier, options: nil) { (item, error) in
            let image: UIImage? = {
                if let itemURL = item as? URL {
                    return UIImage(contentsOfFile: itemURL.path)
                } else {
                    return item as? UIImage
                }
            }()
            guard let image, let urlString = image.getURLFromImage() else { return }
        }
    }
}

extension UIImage {
    func getURLFromImage() -> String? {
        guard let image = CIImage(image: self) else { return "" }

        let detector = CIDetector(
            ofType: CIDetectorTypeQRCode,
            context: nil,
            options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        )

        let features = detector?.features(in: image) ?? []

        return features
            .compactMap { ($0 as? CIQRCodeFeature)?.messageString }
            .first
    }
}
