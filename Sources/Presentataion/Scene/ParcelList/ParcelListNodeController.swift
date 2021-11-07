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
        }, canEditRowAtIndexPath: { _, _ in
            return true
        }
    )

    private let registerParcel = PublishSubject<(deliveryCompanyIndex: Int, trackingNumber: String, name: String)>()
    private let deliveryCompanyPickerView = UIPickerView()
    private lazy var registerParcelAlert = UIAlertController(
        title: "등록",
        message: "운송장 정보",
        preferredStyle: .alert
    ).then { alert in
        alert.addTextField { nameTextField in
            nameTextField.placeholder = "택배 이름 (선택)"
        }
        alert.addTextField { deliveryCompanyNameTextField in
            deliveryCompanyNameTextField.placeholder = "택배 회사"
            deliveryCompanyNameTextField.tintColor = .clear
            deliveryCompanyNameTextField.inputView = self.deliveryCompanyPickerView
            self.deliveryCompanyPickerView.rx.itemSelected
                .subscribe(onNext: { [weak self] in
                    deliveryCompanyNameTextField.text = self?.reactor?.deliveryCompanies[$0.row].companyName ?? ""
                })
                .disposed(by: self.disposeBag)
        }
        alert.addTextField { trackingNumberTextField in
            trackingNumberTextField.placeholder = "운송장 번호"
            trackingNumberTextField.keyboardType = .numberPad
        }
        alert.addAction(UIAlertAction(title: "등록", style: .default) { _ in
            self.registerParcel.onNext((
                deliveryCompanyIndex: self.deliveryCompanyPickerView.selectedRow(inComponent: 0),
                trackingNumber: alert.textFields![2].text ?? "",
                name: alert.textFields![0].text ?? ""
            ))
            alert.textFields!.forEach { $0.text = "" }
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
    }

    private let addParcelButtonNode = UIBarButtonItem().then {
        $0.image = UIImage(systemName: "plus")
    }

    // MARK: Initializing
    override init() {
        super.init(node: ASTableNode(style: .plain))
        self.node.backgroundColor = .systemBackground
        self.setNavigationBar()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(reactor: Reactor) {
        bindAction(reactor)
        bindState(reactor)
    }

    private func setNavigationBar() {
        self.title = "배송목록"
        self.navigationItem.rightBarButtonItem = addParcelButtonNode
    }
}

extension ParcelListNodeController {
    private func bindAction(_ reactor: Reactor) {
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.addParcelButtonNode.rx.tap
            .map { Reactor.Action.tapPlusButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.registerParcel
            .map { Reactor.Action.registerParcel(
                deliveryCompanyIndex: $0,
                trackingNumber: $1,
                name: $2
            )}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.node.rx.itemSelected
            .do(onNext: { [weak self] in self?.node.deselectRow(at: $0, animated: true) })
            .map { $0.row }
            .map { Reactor.Action.parcelIsPicked(parcelIndex: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.node.rx.itemDeleted
            .map { $0.row }
            .map { Reactor.Action.deleteParcel(parcelIndex: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindState(_ reactor: Reactor) {
        reactor.state
            .map { $0.parcelList }
            .map { [SectionOfParcel(items: $0)] }
            .bind(to: node.rx.items(dataSource: dataSources))
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.deliveryCompanyList }
            .bind(to: self.deliveryCompanyPickerView.rx.itemTitles) {
                $1.companyName
            }
            .disposed(by: disposeBag)

        reactor.pulse(\.$alert)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .notification(let message):
                    self?.showAlert(message)
                case .registerParcel:
                    self?.present(
                        self!.registerParcelAlert,
                        animated: true
                    )
                }
            })
            .disposed(by: disposeBag)
    }
}
