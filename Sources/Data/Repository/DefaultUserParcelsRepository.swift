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
        CoreData.shared.performBackgroundTask { context in
            context.delete(parcel.toEntity(context))
            do { try context.save() } catch { print(error.localizedDescription) }
        }
    }
    func synchronizeUserParcel(parcel: Parcel) {
        fetchSpecificParcel(parcel: parcel).subscribe(onSuccess: { result in
            CoreData.shared.performBackgroundTask { context in
                result.setValue(parcel.state.rawValue, forKey: "state")
                do { try context.save() } catch { print(error.localizedDescription) }
            }
        })
        .disposed(by: disposeBag)
    }

    private func fetchSpecificParcel(parcel: Parcel) -> Single<NSManagedObject> {
        return Single<NSManagedObject>.create { single in
            CoreData.shared.performBackgroundTask { context in
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "UserParcelEntity")
                fetchRequest.predicate = NSPredicate(
                    format: "deliveryCompanyId == %@ && trackingNumber == %@",
                    parcel.deliveryCompany.companyId, parcel.trackingNumber
                )
                do {
                    let result = try context.fetch(fetchRequest)[0] as? NSManagedObject
                    single(.success(result!))
                } catch {
                    print(error.localizedDescription)
                }
            }
            return Disposables.create()
        }
    }
}
