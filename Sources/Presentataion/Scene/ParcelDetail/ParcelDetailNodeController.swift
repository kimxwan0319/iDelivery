//
//  ParcelDetailNodeController.swift
//  iDelivery
//
//  Created by 김수완 on 2021/09/20.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import AsyncDisplayKit
import Then

class ParcelDetailNodeController: ASDKViewController<ASTableNode> {
    var items = ["", "", ""]

    override init() {
        super.init(node: ASTableNode(style: .plain))
        self.node.backgroundColor = .systemBackground
        self.node.dataSource = self
        self.node.view.separatorStyle = .none
        self.node.view.allowsSelection = false
        // self.node.view.tableHeaderView = PostInfoHeaderNode().view
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ParcelDetailNodeController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return ProgressCellNode(
                dateStr: "0000 - 00 - 00",
                timeStr: "00 : 00",
                location: "location",
                discription: "discription"
            )
        }
    }
}
