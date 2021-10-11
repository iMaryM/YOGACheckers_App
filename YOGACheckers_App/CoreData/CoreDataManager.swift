//
//  CoreDataManager.swift
//  YOGACheckers_App
//
//  Created by Мария Манжос on 11.10.21.
//

import UIKit
import CoreData

class CoreDataManager {
    public static let shared = CoreDataManager()
    
    // MARK: - Core Data stack
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModelEntity")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    private func saveContext () {
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
    
    func addResult(result_m: Results_m) {
        
        //получаем модель теблицы
        let result = Results(context: persistentContainer.viewContext)
        
        //записываем значения из переданного объекта в модель таблицы
        result.convert(from: result_m)
        
        //добавляем запись в таблицу
        persistentContainer.viewContext.insert(result)
        saveContext()
        
    }
    
    func getResults() -> [Results_m] {
        var arr: [Results_m] = []
        do {
            let results = try persistentContainer.viewContext.fetch(Results.fetchRequest())
            results.forEach { result in
                arr.append(Results_m(player_1: result.player_1, checker_image_player_1: result.checker_image_player_1, player_2: result.player_2, checker_image_player_2: result.checker_image_player_2, winner: result.winner, date_of_win: result.date_of_win, duration: result.duration))
            }
        } catch (let e) {
            print(e)
        }
        
        return arr
    }
    
    func deleteResults() {
        do {
            let results = try persistentContainer.viewContext.fetch(Results.fetchRequest())
            results.forEach { result in
                persistentContainer.viewContext.delete(result)
            }
            saveContext()
        } catch (let e) {
            print(e)
        }
    }
    
}
