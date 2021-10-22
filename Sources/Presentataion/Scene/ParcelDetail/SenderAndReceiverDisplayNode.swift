//
//  SenderAndReceiverDisplayNode.swift
//  iDelivery
//
//  Created by 김수완 on 2021/10/20.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import AsyncDisplayKit
import UIKit
import RxSwift
import RxCocoa
import RxTexture2
import RxViewController
import Then

class SenderAndReceiverDisplayNode: ASDisplayNode {

    private let disposeBag = DisposeBag()

    // MARK: UI
    private let senderDescriptionTextNode = ASTextNode().then {
        $0.setAttribute(
            font: .systemFont(ofSize: 17),
            color: .label
        )
        $0.setString("보내는분")
    }
    private let senderTextNode = ASTextNode().then {
        $0.setAttribute(
            font: .systemFont(ofSize: 17),
            color: .lightGray
        )
    }
    private let receiverDescriptionTextNode = ASTextNode().then {
        $0.setAttribute(
            font: .systemFont(ofSize: 17),
            color: .label
        )
        $0.setString("받는분")
    }
    private let receiverTextNode = ASTextNode().then {
        $0.setAttribute(
            font: .systemFont(ofSize: 17),
            color: .lightGray
        )
    }

    // MARK: Initializing
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true

        // Demodata
        self.senderTextNode.setString("김수완");
        self.receiverTextNode.setString("이서준");
    }

    // MARK: Layout
    override func layoutSpecThatFits(_ constraintedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8),
            child: self.contentLayoutSpec()
        )
    }
    private func contentLayoutSpec() -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 12,
            justifyContent: .center,
            alignItems: .stretch,
            children: [
                ASLineNode(direction: .horizontal, color: .systemGray5, width: 1),
                informationLayoutSpec(),
                ASLineNode(direction: .horizontal, color: .systemGray5, width: 1)
            ]
        )
    }
    private func informationLayoutSpec() -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 20,
            justifyContent: .start,
            alignItems: .stretch,
            children: [
                senderLayoutSpec().styled {
                    $0.flexBasis = ASDimension(unit: .fraction, value: 0.5)
                },
                receiverLayoutSpec().styled {
                    $0.flexBasis = ASDimension(unit: .fraction, value: 0.5)
                }
            ]
        )
    }
    private func senderLayoutSpec() -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 8,
            justifyContent: .start,
            alignItems: .stretch,
            children: [
                senderDescriptionTextNode,
                senderTextNode
            ]
        )
    }
    private func receiverLayoutSpec() -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 8,
            justifyContent: .start,
            alignItems: .stretch,
            children: [
                receiverDescriptionTextNode,
                receiverTextNode
            ]
        )
    }
}
