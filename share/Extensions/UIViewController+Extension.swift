//
//  UIViewController+Extension.swift
//  share
//
//  Created by Yi-Chin Hsu on 2023/4/4.
//

import UIKit

extension UIViewController {
    func showWebView(_ urlString: String, didDisappear: (() -> Void)?) {
        guard let url = URL(string: urlString) else { return }
        let vc = SafariViewController(url: url, didDisappear: didDisappear)
        self.present(vc, animated: true)
    }
}
