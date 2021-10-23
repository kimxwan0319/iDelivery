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
    private let stateProgressNode = ASDisplayNode(viewBlock: { () -> UIProgressView in
        return UIProgressView()
    })
    private let stateTextNode = ASTextNode().then {
        $0.setAttribute(
            font: .systemFont(ofSize: 45),
            color: .link
        )
    }
    private let deliveryCompanyTextNode = ASTextNode().then {
        $0.setAttribute(
            font: .systemFont(ofSize: 20),
            color: .label
        )
    }
    private let trackingNumberTextNode = ASTextNode().then {
        $0.setAttribute(
            font: .systemFont(ofSize: 15),
            color: .lightGray
        )
    }
    private let senderAndReceiverDisplayNode = SenderAndReceiverDisplayNode()

    // MARK: Initializing
    override init() {
        super.init()
        self.bounds = CGRect(x: 0, y: 0, width: (supernode?.view.frame.size.width) ?? 0, height: 250)
        self.automaticallyManagesSubnodes = true
        self.automaticallyRelayoutOnSafeAreaChanges = true
    }

    public func setData(parcel: Parcel) {
        stateTextNode.setString(parcel.state.displayString())
        deliveryCompanyTextNode.setString(parcel.deliveryCompany.companyName)
        trackingNumberTextNode.setString(parcel.trackingNumber)
        setProgress(percent: parcel.state.progressPercent())
    }
    public func setSenderAndReceiver(sender: String, receiver: String) {
        senderAndReceiverDisplayNode.setSenderAndReceiver(sender: sender, receiver: receiver)
    }
    public func changeParcelState(state: ParcelState) {
        self.stateTextNode.setString(state.displayString())
    }

    private func setProgress(percent: Int) {
        (self.stateProgressNode.view as? UIProgressView)?.setProgress(Float(percent/100), animated: true)
    }

    // MARK: Layout
    override func layoutSpecThatFits(_ constraintedSize: ASSizeRange) -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 50,
            justifyContent: .start,
            alignItems: .stretch,
            children: [
                stateProgressNode,
                parcelInfoLayoutSpec(),
                senderAndReceiverDisplayNode
            ]
        )
    }
    private func parcelInfoLayoutSpec() -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 5,
            justifyContent: .center,
            alignItems: .center,
            children: [
                self.stateTextNode,
                self.deliveryCompanyTextNode,
                self.trackingNumberTextNode
            ]
        )
    }
}
