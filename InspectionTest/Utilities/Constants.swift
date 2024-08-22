//
//  Constants.swift
//  InspectionTest
//
//  Created by Zubin Gala on 12/08/24.
//

import Foundation
import UIKit

struct Constants {
    struct Static{
        static let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    }
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
