//
//  ASDKViewController.swift
//  iDelivery
//
//  Created by 김수완 on 2021/10/10.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import AsyncDisplayKit

extension ASDKViewController {
    @objc func showAlert(_ message: String) {
        let alert = UIAlertController(
            title: nil,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "Ok",
            style: .default
        ))
        self.present(alert, animated: true)
    }
}
