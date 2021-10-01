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
    func fetchUserParcels() -> Single<[UserParcel]> {
        return Single<[UserParcel]>.create { single in
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
    func saveUserParcel(parcel: UserParcel) {
        CoreData.shared.performBackgroundTask { context in
            _ = parcel.toEntity(context)
            do { try context.save() } catch { print(error.localizedDescription) }
        }
    }
    func deleteUserParcel(parcel: UserParcel) {
        CoreData.shared.performBackgroundTask { context in
            context.delete(parcel.toEntity(context))
            do { try context.save() } catch { print(error.localizedDescription) }
        }
    }
}
