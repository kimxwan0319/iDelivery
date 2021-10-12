//
//  ParcelListCellNode.swift
//  iDelivery
//
//  Created by 김수완 on 2021/09/17.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import AsyncDisplayKit
import Then

class ParcelListCellNode: ASCellNode {

    // MARK: UI
    private let stateTextNode = ASTextNode().then {
        $0.attributedText = NSAttributedString(
            string: " ",
            attributes: [
                .font: UIFont.systemFont(ofSize: 25),
                .foregroundColor: UIColor.link
            ]
        )
    }
    private let carrierTextNode = ASTextNode().then {
        $0.attributedText = NSAttributedString(
            string: " ",
            attributes: [
                .font: UIFont.systemFont(ofSize: 10),
                .foregroundColor: UIColor.lightGray
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

    // MARK: Initializing
    init(parcel: Parcel) {
        super.init()

        self.automaticallyManagesSubnodes = true
        self.backgroundColor = .clear

        self.stateTextNode.setString(parcel.state.displayString())
        self.carrierTextNode.setString(parcel.name+" "+parcel.trackingNumber)
        self.titleTextNode.setString(parcel.name)
    }

    // MARK: Layout
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15),
            child: self.contentLayoutSpec()
        )
    }

    private func contentLayoutSpec() -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 30,
            justifyContent: .start,
            alignItems: .start,
            children: [
                self.stateTextNode,
                ASStackLayoutSpec(
                    direction: .vertical,
                    spacing: 0,
                    justifyContent: .center,
                    alignItems: .start,
                    children: [
                        self.carrierTextNode,
                        self.titleTextNode
                    ]
                )
            ]
        )
    }
}
