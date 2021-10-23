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
        $0.setAttribute(
            font: .systemFont(ofSize: 10),
            color: .lightGray
        )
    }
    private let timeTextNode = ASTextNode().then {
        $0.setAttribute(
            font: .systemFont(ofSize: 20),
            color: .label
        )
    }
    private let lineImageNode = ASImageNode().then {
        $0.contentMode = .scaleAspectFit
    }
    private let locationTextNode = ASTextNode().then {
        $0.setAttribute(
            font: .systemFont(ofSize: 20),
            color: .label
        )
    }
    private let descriptionTextNode = ASTextNode().then {
        $0.maximumNumberOfLines = 0
        $0.truncationMode = .byTruncatingTail
        $0.setAttribute(
            font: .systemFont(ofSize: 13),
            color: .label
        )
    }

    // MARK: Initializing
    init(progress: ParcelInformation.Progress) {
        super.init()

        self.automaticallyManagesSubnodes = true
        self.backgroundColor = .clear

        self.dateTextNode.setString(progress.dateString())
        self.timeTextNode.setString(progress.timeString())
        self.locationTextNode.setString(progress.location)
        self.descriptionTextNode.setString(progress.description)
    }
    public func setImage(_ state: ASImageNode.State) {
        self.lineImageNode.setLineImage(state: state)
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
                    $0.flexBasis = ASDimension(unit: .fraction, value: 0.15)
                },
                self.imageLayoutSpec().styled {
                    $0.flexBasis = ASDimension(unit: .fraction, value: 0.05)
                },
                self.locationDescriptionLayoutSpec().styled {
                    $0.flexBasis = ASDimension(unit: .fraction, value: 0.8)
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
    private func locationDescriptionLayoutSpec() -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 0,
            justifyContent: .center,
            alignItems: .stretch,
            children: [
                self.locationTextNode,
                self.descriptionTextNode
            ]
        )
    }
}
