//
//  ProgressCellNode.swift
//  iDelivery
//
//  Created by 김수완 on 2021/09/23.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import Foundation

import AsyncDisplayKit
import Then

class ProgressCellNode: ASCellNode {

    // MARK: UI
    private let dateTextNode = ASTextNode().then {
        $0.attributedText = NSAttributedString(
            string: " ",
            attributes: [
                .font: UIFont.systemFont(ofSize: 10),
                .foregroundColor: UIColor.lightGray
            ]
        )
    }
    private let timeTextNode = ASTextNode().then {
        $0.attributedText = NSAttributedString(
            string: " ",
            attributes: [
                .font: UIFont.systemFont(ofSize: 20),
                .foregroundColor: UIColor.label
            ]
        )
    }
    private let lineImageNode = ASImageNode().then {
        $0.contentMode = .scaleAspectFit
    }
    private let locationTextNode = ASTextNode().then {
        $0.attributedText = NSAttributedString(
            string: " ",
            attributes: [
                .font: UIFont.systemFont(ofSize: 20),
                .foregroundColor: UIColor.label
            ]
        )
    }
    private let discriptionTextNode = ASTextNode().then {
        $0.attributedText = NSAttributedString(
            string: " ",
            attributes: [
                .font: UIFont.systemFont(ofSize: 13),
                .foregroundColor: UIColor.label
            ]
        )
    }

    // MARK: Initializing
    init(dateStr: String, timeStr: String, location: String, discription: String) {
        super.init()

        self.automaticallyManagesSubnodes = true
        self.backgroundColor = .clear

        self.dateTextNode.setString(dateStr)
        self.timeTextNode.setString(timeStr)
        self.locationTextNode.setString(location)
        self.discriptionTextNode.setString(discription)
        self.lineImageNode.image = .State.only
    }

    // MARK: Layout
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15),
            child: self.contentLayoutSpec()
        )
    }
    
    private func contentLayoutSpec() -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 15.0,
            justifyContent: .start,
            alignItems: .stretch,
            children: [
                self.dateTimeLayoutSpec().styled {
                    $0.flexBasis = ASDimension(unit: .fraction, value: 0.2)
                },
                self.imageLayoutSpec().styled {
                    $0.flexBasis = ASDimension(unit: .fraction, value: 0.05)
                },
                self.locationDiscriptionLayoutSpec().styled {
                    $0.flexBasis = ASDimension(unit: .fraction, value: 0.75)
                }
            ]
        )
    }
    private func dateTimeLayoutSpec() -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 0,
            justifyContent: .center,
            alignItems: .start,
            children: [
                self.dateTextNode,
                self.timeTextNode
            ]
        )
    }
    private func imageLayoutSpec() -> ASLayoutSpec {
        return ASRatioLayoutSpec(ratio: 4, child: self.lineImageNode)
    }
    private func locationDiscriptionLayoutSpec() -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 0,
            justifyContent: .center,
            alignItems: .start,
            children: [
                self.locationTextNode,
                self.discriptionTextNode
            ]
        )
    }
}
