//
//  UIViewController+Extension.swift
//  share
//
//  Created by Yi-Chin Hsu on 2023/4/4.
//

import SafariServices

extension UIViewController {
    func showWebView(_ urlString: String) {
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            self.present(vc, animated: true)
        }
    }
}
