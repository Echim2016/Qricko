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
    private let urlTypeIdentifier = UTType.url.identifier
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleShareItem()
    }
    
    private func handleShareItem() {
        guard
            let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
            let itemProvider = extensionItem.attachments?.first
        else {
            self.extensionContext?.completeRequest(returningItems: nil)
            return
        }
        
        if itemProvider.hasItemConformingToTypeIdentifier(imageTypeIdentifier) {
            handleImage(with: itemProvider)
        } else if itemProvider.hasItemConformingToTypeIdentifier(urlTypeIdentifier){
            handleUrl(with: itemProvider)
        } else {
            self.extensionContext?.completeRequest(returningItems: nil)
        }
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
    
    private func handleUrl(with itemProvider: NSItemProvider) {
        itemProvider.loadItem(forTypeIdentifier: urlTypeIdentifier, options: nil) { (item, error) in
            guard let url = item as? URL else { return }
            DispatchQueue.main.async {
                self.showWebView(url.absoluteString) { [weak self] in
                    self?.extensionContext?.completeRequest(returningItems: nil)
                }
            }
        }
    }
}

extension ShareViewController {
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
