//
//  InspectionViewModel.swift
//  InspectionTest
//
//  Created by Zubin Gala on 12/08/24.
//

import Foundation

protocol UpdateInspectionVCProtocol: AnyObject {
    func loadNewData()
    func showAlert(message: String)
}

class InspectionViewModel {
    
    var inspectionData: InspectModel?
    var formFieldData = [FormFieldType]()
    
    weak var updateDelegate: UpdateInspectionVCProtocol?
    private var networkManager = NetworkManager()
    
    func startInspection() {
        //fetching from coreData
        let inspectArray = InpectionCD.fetchInspections()
        if inspectArray.count > 0{
            guard let lastData = inspectArray.last, let inspectionTemp = lastData.inspectionType,
                  let inspectType = try? JSONDecoder().decode(InspectionType.self, from: inspectionTemp) else { return }
            print("Name: \(inspectType.name)", "access:\(inspectType.access)")
        }else{
            networkManager.getInspectionDataAndStart { [weak self] result in
                switch result {
                case .success(let inspectionData):
                    self?.inspectionData = inspectionData
                    self?.addFormFieldData(inspectionData: inspectionData)
                    self?.updateDelegate?.loadNewData()
                    
                case .failure(let error):
                    self?.updateDelegate?.showAlert(message: error.localizedDescription)
                }
            }
            
        }
    }
    
    
    func submitInspection() {
        guard let inspectionData = inspectionData, let inspection = inspectionData.inspection else { return }
        networkManager.submitInspectionData(inspectionData: inspectionData) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                let scoreMessage = self.getInspectionScore(inspectionData: inspectionData)
                if let inspection = inspectionData.inspection{
                    
                    do {
                        let inspectionTypeData = try JSONEncoder().encode(inspection.inspectionType)
                        let inspectionAreaData = try JSONEncoder().encode(inspection.area)
                        let surveyData = try JSONEncoder().encode(inspection.survey)
                        //saving the data to coredata
                        InpectionCD.createInspection(id: Int16(inspection.id ?? 0),
                                                     inspectionType: inspectionTypeData,
                                                     area: inspectionAreaData,
                                                     survey: surveyData)
                    } catch {
                        print("Error encoding inspection data: \(error)")
                    }
                }
                
                self.updateDelegate?.showAlert(message: scoreMessage)
                self.resetInspectionData()
                
            case .failure(let error as NSError):
                let message = (error.code == 500) ? AppString.inspectDataInvalid : error.localizedDescription
                self.updateDelegate?.showAlert(message: message)
            }
        }
    }
    
    func getAndAddInspectionDataFromLocalJsonFile() {
        guard let path = Bundle.main.path(forResource: "inspection", ofType: "json") else { return }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            if let jsonResult = try? JSONDecoder().decode(InspectModel.self, from: data) {
                handleInspectionData(jsonResult)
            }
        } catch {
            print("Failed to load or decode JSON: \(error.localizedDescription)")
        }
    }
    
    private func handleInspectionData(_ data: InspectModel) {
        inspectionData = data
        addFormFieldData(inspectionData: data)
        updateDelegate?.loadNewData()
    }
    
    private func addFormFieldData(inspectionData: InspectModel) {
        guard let inspection = inspectionData.inspection else { return }
        formFieldData.append(.inspectionType(inspection.inspectionType?.name ?? ""))
        formFieldData.append(.area(inspection.area?.name ?? ""))
        inspection.survey?.categories?.forEach { category in
            formFieldData.append(.survey(category))
        }
    }
    
    private func getInspectionScore(inspectionData: InspectModel) -> String {
        var score: Float = .zero
        guard let categories = inspectionData.inspection?.survey?.categories else { return "\(AppString.inspectionScore): \(score)" }
        categories.forEach { category in
            category.questions?.forEach({ question in
                let ansScore = question.answerChoices?.first(where: {$0.id == question.selectedAnswerChoiceId})?.score
                score += ansScore ?? .zero
            })
        }
        return "\(AppString.inspectionScore): \(score)"
    }
    
    private func resetInspectionData() {
        inspectionData = nil
        updateDelegate?.loadNewData()
    }
}

