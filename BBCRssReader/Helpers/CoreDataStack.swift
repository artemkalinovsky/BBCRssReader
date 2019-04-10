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

    private let modelName: String

    init(modelName: String) {
        self.modelName = modelName
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
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    func fetch<T: NSManagedObject>(_ type: T.Type) -> [T]? {
        return try? viewContext.fetch(T.fetchRequest()) as? [T]
    }

    func save() {
        writeContext.perform { [weak self] in
            guard let _ = try? self?.writeContext.save() else { return }
        }
    }

    @objc private func writeContextDidSave(notification: Notification) {
        viewContext.mergeChanges(fromContextDidSave: notification)
    }
}
