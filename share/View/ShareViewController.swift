//
//  ShareViewController.swift
//  share
//
//  Created by Yi-Chin Hsu on 2023/4/4.
//

import UIKit
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
            
            if let image, let urlString = image.getURLFromImage() {
                DispatchQueue.main.async {
                    self.showWebView(urlString) { [weak self] in
                        self?.extensionContext?.completeRequest(returningItems: nil)
                    }
                }
            } else {
                self.showAlert(with: "Oops! URL not found...")
            }
        }
    }
    
    private func showAlert(with message: String) {
        let controller = UIAlertController(
            title: nil,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.extensionContext?.completeRequest(returningItems: nil)
        }
        controller.addAction(okAction)
        DispatchQueue.main.async {
            self.present(controller, animated: true)
        }
    }
}
