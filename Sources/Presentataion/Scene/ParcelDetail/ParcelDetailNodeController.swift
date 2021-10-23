//
//  ParcelDetailNodeController.swift
//  iDelivery
//
//  Created by 김수완 on 2021/09/20.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import ReactorKit
import AsyncDisplayKit
import Then
import RxSwift
import RxCocoa
import RxTexture2
import RxDataSources_Texture
import RxViewController

class ParcelDetailNodeController: ASDKViewController<ASTableNode>, View {

    typealias Reactor = ParcelDetailReactor

    var disposeBag = DisposeBag()
    private let headerNode = ParcelDetailHeaderNode()

    private var progressCount: Int = 0
    lazy var dataSources = RxASTableSectionedReloadDataSource<SectionOfProgress>(
        configureCellBlock: { _, _, indexPath, progress in
            return {
                let cellNode = ProgressCellNode(progress: progress)
                cellNode.setImage(self.lineImageSelect(index: indexPath.row))
                return cellNode
            }
        }
    )

    override init() {
        super.init(node: ASTableNode(style: .plain))
        self.navigationItem.largeTitleDisplayMode = .never
        self.node.backgroundColor = .systemBackground
        self.node.view.separatorStyle = .none
        self.node.view.tableHeaderView = headerNode.view
        self.headerNode.automaticallyRelayoutOnSafeAreaChanges = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(reactor: ParcelDetailReactor) {
        bindAction(reactor)
        bindState(reactor)
    }

    private func lineImageSelect(index: Int) -> ASImageNode.State {
        if progressCount == 1 {
            return .only
        } else if index == 0 {
            return .start
        } else if index == progressCount - 1 {
            return .end
        } else { return .middle }
    }
}

extension ParcelDetailNodeController {
    private func bindAction(_ reactor: Reactor) {
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindState(_ reactor: Reactor) {
        reactor.state
            .map { $0.basicParcelInfo }
            .map { $0.name }
            .bind(to: self.navigationItem.rx.title)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.basicParcelInfo }
            .subscribe(onNext: { [weak self] in
                self?.headerNode.setData(parcel: $0)
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.senderAndReceiver }
            .subscribe(onNext: { [weak self] in
                self?.headerNode.setSenderAndReceiver(
                    sender: $0.sender,
                    receiver: $0.receiver
                )
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.parcelProgress }
            .do(onNext: { self.progressCount = $0.count })
            .map { [SectionOfProgress(items: $0)] }
            .bind(to: node.rx.items(dataSource: dataSources))
            .disposed(by: disposeBag)
    }
}
