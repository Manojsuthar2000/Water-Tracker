import UIKit
import CoreData

struct CoreDataManager {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func createData(entity: String, record: [String:Any]) {
        let entityD = NSEntityDescription.entity(forEntityName: entity, in: context)!
        let object = NSManagedObject(entity: entityD, insertInto: context)
        for (key,value) in record {
            object.setValue(value, forKey: key)
        }
        saveChanges()
    }
    
    func retriveData(entity: String, keys: [String]) -> [[String:Any]] {
        var records = [[String:Any]]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            for data in result {
                var record = [String:Any]()
                for key in keys {
                    record[key] = data.value(forKey: key)
                }
                records.append(record)
            }
            return records
        } catch {
            print(error)
        }
        return records
    }
    
    func retriveData(entity: String, predicate: NSPredicate, keys: [String]) -> [[String:Any]] {
        var records = [[String:Any]]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.predicate = predicate
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            for data in result {
                var record = [String:Any]()
                for key in keys {
                    record[key] = data.value(forKey: key)
                }
                records.append(record)
            }
            return records
        } catch {
            print(error)
        }
        return records
    }
    
    func retriveData(entity: String, index: Int, keys: [String]) -> [String:Any] {
        var record = [String:Any]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            for key in keys {
                record[key] = result[index].value(forKey: key)
            }
            return record
        } catch {
            print(error)
        }
        return record
    }
    
    func updateData(entity: String, index: Int, record: [String:Any]) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            let object = result[index] 
            for (key,value) in record {
                object.setValue(value, forKey: key)
            }
            saveChanges()
        } catch {
            print(error)
        }
    }
    
    func updateData(entity: String, predicate: NSPredicate, record: [String:Any]) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.predicate = predicate
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            let object = result[0]
            for (key,value) in record {
                object.setValue(value, forKey: key)
            }
            saveChanges()
        } catch {
            print(error)
        }
    }
    
    func deleteData(entity: String, index: Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            context.delete(result[index])
            saveChanges()
        } catch {
            print(error)
        }
    }
    
    private func saveChanges() {
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
