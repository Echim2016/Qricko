//
//  SafariViewController.swift
//  share
//
//  Created by Yi-Chin Hsu on 2023/4/4.
//

import SafariServices

final class SafariViewController: SFSafariViewController {
    private var didDisappear: (() -> Void)?
    
    convenience init(url: URL, didDisappear: (() -> Void)?) {
        self.init(url: url)
        self.didDisappear = didDisappear
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        didDisappear?()
    }
}
