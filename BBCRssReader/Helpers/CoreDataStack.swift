//
//  CoreDataStack.swift
//  BBCRssReader
//
//  Created by Artem Kalinovsky on 4/9/19.
//  Copyright © 2019 DataArt. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStack {

    enum PersistentStoreType {
        case inMemory, sqlite

        var coreDataIdentifier: String {
            switch self {
            case .inMemory:
                return NSInMemoryStoreType
            case .sqlite:
                return NSSQLiteStoreType
            }
        }
    }

    private let modelName: String
    private let persistentStoreType: PersistentStoreType

    init(modelName: String, persistentStoreType: PersistentStoreType = .sqlite) {
        self.modelName = modelName
        self.persistentStoreType = persistentStoreType
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(writeContextDidSave(notification:)),
                                               name: .NSManagedObjectContextDidSave,
                                               object: writeContext)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    lazy var viewContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()

    lazy var writeContext: NSManagedObjectContext = {
        let writeContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        writeContext.parent = self.viewContext
        return writeContext
    }()

    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        if self.persistentStoreType == .inMemory {
            let persistentStoreDescription = NSPersistentStoreDescription()
            persistentStoreDescription.type = self.persistentStoreType.coreDataIdentifier
            container.persistentStoreDescriptions = [persistentStoreDescription]
        }
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    func fetch<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate? = nil) -> [T]? {
    func fetch<T: NSManagedObject>(_ type: T.Type,
                                   predicate: NSPredicate? = nil,
                                   fetchBatchSize: Int? = nil) -> [T]? {
        let fetchRequest = T.fetchRequest()
        fetchRequest.predicate = predicate
            fetchRequest.fetchBatchSize = fetchBatchSize
        }
        let feched = try? viewContext.fetch(fetchRequest)
        return feched as? [T]
    }

    func save() {
        writeContext.perform { [weak self] in
            guard let _ = try? self?.writeContext.save() else { return }
        }
    }

    @objc private func writeContextDidSave(notification: Notification) {
        viewContext.mergeChanges(fromContextDidSave: notification)
        try? viewContext.save()
    }
}
