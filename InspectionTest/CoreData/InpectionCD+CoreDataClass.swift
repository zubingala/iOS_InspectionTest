//
//  InpectionCD+CoreDataClass.swift
//  InspectionTest
//
//  Created by Zubin Gala on 22/08/24.
//
//

import Foundation
import CoreData

@objc(InpectionCD)
public class InpectionCD: NSManagedObject {
    
    //MARK: - fetch inspection
    
    static func fetchInspections() -> [InpectionCD] {
        let context = CoreDataStack.shared.context
        let fetchRequest: NSFetchRequest<InpectionCD> = InpectionCD.fetchRequest()
        
        do {
            let inspections = try context.fetch(fetchRequest)
            return inspections
        } catch {
            print("Failed to fetch inspections: \(error)")
            return []
        }
    }

    static func fetchInspection(byId id: Int16) -> InpectionCD? {
        let context = CoreDataStack.shared.context
        let fetchRequest: NSFetchRequest<InpectionCD> = InpectionCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let inspections = try context.fetch(fetchRequest)
            return inspections.first
        } catch {
            print("Failed to fetch inspection with id \(id): \(error)")
            return nil
        }
    }
    
    //MARK: - create inspection
   static func createInspection(id: Int16, inspectionType: Data, area: Data, survey: Data) {
        let moc = CoreDataStack.shared.context
        let newInspection = InpectionCD(context: moc)
        
        newInspection.id = id
        newInspection.inspectionType = inspectionType
        newInspection.area = area
        newInspection.survey = survey
        
       CoreDataStack.shared.saveContext()
    }
    
    func deleteInspection(inspection: InpectionCD) {
        let context = CoreDataStack.shared.context
        context.delete(inspection)
        
        CoreDataStack.shared.saveContext()
    }

    func deleteInspection(byId id: Int16) {
        if let inspection = InpectionCD.fetchInspection(byId: id) {
            deleteInspection(inspection: inspection)
        }
    }
}
