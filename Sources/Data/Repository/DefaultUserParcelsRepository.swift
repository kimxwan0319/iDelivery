//
//  DefaultUserParcelsRepository.swift
//  iDelivery
//
//  Created by 김수완 on 2021/09/28.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

class DefaultUserParcelsRepository: UserParcelsRepository {

    private let disposeBag = DisposeBag()

    func fetchUserParcels() -> Single<[Parcel]> {
        return Single<[Parcel]>.create { single in
            CoreData.shared.performBackgroundTask { context in
                do {
                    let result = try context.fetch(UserParcelEntity.fetchRequest()).map { $0.toDomain() }
                    single(.success(result))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    func saveUserParcel(parcel: Parcel) {
        CoreData.shared.performBackgroundTask { context in
            _ = parcel.toEntity(context)
            do { try context.save() } catch { print(error.localizedDescription) }
        }
    }
    func deleteUserParcel(parcel: Parcel) {
        CoreData.shared.performBackgroundTask { [weak self] context in
            let request = self?.fetchRequest(parcel: parcel)
            do {
                if let result = try context.fetch(request!).first {
                    context.delete(result)
                    do { try context.save() } catch { print(error.localizedDescription) }
                }
            } catch {
                print(error)
            }
        }
    }
    func synchronizeUserParcel(parcel: Parcel) {
        CoreData.shared.performBackgroundTask { [weak self] context in
            let request = self?.fetchRequest(parcel: parcel)
            do {
                if let result = try context.fetch(request!).first {
                    result.setValue(parcel.state.rawValue, forKey: "state")
                    do { try context.save() } catch { print(error.localizedDescription) }
                }
            } catch {
                print(error)
            }
        }
    }

    private func fetchRequest(parcel: Parcel) -> NSFetchRequest<UserParcelEntity> {
        let request: NSFetchRequest = UserParcelEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "deliveryCompanyId == %@ && trackingNumber == %@",
            parcel.deliveryCompany.companyId, parcel.trackingNumber
        )
        return request
    }
}
