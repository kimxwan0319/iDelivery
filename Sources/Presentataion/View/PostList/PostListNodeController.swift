//
//  PostListNodeController.swift
//  iDelivery
//
//  Created by 김수완 on 2021/09/16.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import AsyncDisplayKit

final class PostListNodeController: ASDKViewController<ASTableNode> {
    private let addPostButtonNode = UIBarButtonItem().then {
        $0.image = UIImage(systemName: "plus")
    }
    
    var items = ["", "", ""]
    
    override init() {
        super.init(node: ASTableNode(style: .plain))
        self.title = "배송목록"
        self.navigationItem.rightBarButtonItem = addPostButtonNode
        self.node.backgroundColor = .systemBackground
        self.node.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostListNodeController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return PostListCellNode(state: "배송중", carrier: "CJ대한통운", number: "123412341234", title: "신발")
        }
    }
}
