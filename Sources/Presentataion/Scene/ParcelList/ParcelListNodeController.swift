//
//  ParcelListNodeController.swift
//  iDelivery
//
//  Created by 김수완 on 2021/09/16.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import ReactorKit
import AsyncDisplayKit
import Then
import RxSwift
import RxCocoa
import RxFlow
import RxTexture2
import RxDataSources_Texture
import RxViewController

final class ParcelListNodeController: ASDKViewController<ASTableNode>, View {

    typealias Reactor = ParcelListReactor

    var disposeBag = DisposeBag()

    let dataSources = RxASTableSectionedReloadDataSource<SectionOfParcel>(
        configureCellBlock: { _, _, _, parcel in
            return { ParcelListCellNode(parcel: parcel) }
        }
    )

    private let addParcelButtonNode = UIBarButtonItem().then {
        $0.image = UIImage(systemName: "plus")
    }

    override init() {
        super.init(node: ASTableNode(style: .plain))
        self.title = "배송목록"
        self.navigationItem.rightBarButtonItem = addParcelButtonNode
        self.node.backgroundColor = .systemBackground
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(reactor: Reactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

extension ParcelListNodeController {
    private func bindAction(_ reactor: Reactor) {
        self.rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        self.addParcelButtonNode.rx.tap
            .map { Reactor.Action.tapPlusButton }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }

    private func bindState(_ reactor: Reactor) {
        reactor.state
            .map { $0.parcelList }
            .map { [SectionOfParcel(items: $0)] }
            .bind(to: node.rx.items(dataSource: dataSources))
            .disposed(by: disposeBag)
    }
}
