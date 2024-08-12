//
//  Constants.swift
//  InspectionTest
//
//  Created by Zubin Gala on 12/08/24.
//

import Foundation

struct Constants {
    struct Webservices {
        static let baseURL = "http://localhost:5001"
        struct Endpoints {
            static let login = "/api/login"
            static let register = "/api/register"
            static let startInspection = "/api/inspections/start"
            static let submitInspection = "/api/inspections/submit"
        }
    }
    
}
