//
//  CoreData.swift
//  iDelivery
//
//  Created by 김수완 on 2021/09/28.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import CoreData
import Then

final class CoreData {

    static let shared = CoreData()

    private init() {}

    // MARK: - Core Data stack
    private lazy var persistentContainer = NSPersistentContainer(name: "CoreData").then {
        $0.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    func resetAllRecords(in entity: String) {
        let context = persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("There was an error")
        }
    }

    // MARK: - Core Data Saving support
    public func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    public func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}
