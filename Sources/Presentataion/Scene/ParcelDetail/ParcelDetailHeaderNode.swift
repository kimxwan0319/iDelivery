//
//  ParcelDetailHeaderNode.swift
//  iDelivery
//
//  Created by 김수완 on 2021/09/20.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import AsyncDisplayKit
import Then

class ParcelDetailHeaderNode: ASDisplayNode {

    // MARK: UI
    private let stateProgressNode = UIProgressView()
    private let stateTextNode = ASTextNode().then {
        $0.attributedText = NSAttributedString(
            string: " ",
            attributes: [
                .font: UIFont.systemFont(ofSize: 45),
                .foregroundColor: UIColor.link
            ]
        )
    }
    private let titleTextNode = ASTextNode().then {
        $0.attributedText = NSAttributedString(
            string: " ",
            attributes: [
                .font: UIFont.systemFont(ofSize: 20),
                .foregroundColor: UIColor.label
            ]
        )
    }
    private let carrierTextNode = ASTextNode().then {
        $0.attributedText = NSAttributedString(
            string: " ",
            attributes: [
                .font: UIFont.systemFont(ofSize: 15),
                .foregroundColor: UIColor.lightGray
            ]
        )
    }

    // MARK: Initializing
    override init() {
        super.init()
        self.bounds = CGRect(x: 0, y: 0, width: (supernode?.view.frame.size.width) ?? 0, height: 300)
        self.automaticallyManagesSubnodes = true
        self.automaticallyRelayoutOnSafeAreaChanges = true
        self.backgroundColor = .cyan
    }

    // MARK: Layout
    override func layoutSpecThatFits(_ constraintedSize: ASSizeRange) -> ASLayoutSpec {
        return ASLayoutSpec()
    }

}
