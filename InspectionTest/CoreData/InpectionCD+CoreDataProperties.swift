//
//  InpectionCD+CoreDataProperties.swift
//  InspectionTest
//
//  Created by Zubin Gala on 22/08/24.
//
//

import Foundation
import CoreData


extension InpectionCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InpectionCD> {
        return NSFetchRequest<InpectionCD>(entityName: "InpectionCD")
    }

    @NSManaged public var area: Data?
    @NSManaged public var id: Int16
    @NSManaged public var inspectionType: Data?
    @NSManaged public var survey: Data?

}

extension InpectionCD : Identifiable {

}
