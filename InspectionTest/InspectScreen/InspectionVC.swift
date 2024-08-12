//
//  InspectionVC.swift
//  InspectionTest
//
//  Created by Zubin Gala on 12/08/24.
//

import UIKit

class InspectionVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let inspectionVM = InspectionViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        inspectionVM.updateDelegate = self
        setupTableView()
        inspectionVM.startInspection()
        // Do any additional setup after loading the view.
    }

    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        self.tableView.register(UINib(nibName: "SurveyQuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "SurveyQuestionTableViewCell")
    }

    @IBAction func submitButtonAction(_ sender: UIButton) {
        inspectionVM.submitInspection()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension InspectionVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return inspectionVM.formFieldData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < inspectionVM.formFieldData.count else { return .zero }
        switch inspectionVM.formFieldData[section] {
        case .inspectionType, .area:
            return 1
        case .survey(let category):
            return category.questions?.count ?? .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section < inspectionVM.formFieldData.count else { return UITableViewCell() }
        switch inspectionVM.formFieldData[indexPath.section] {
        case .inspectionType(let name):
            let title = "Inspection Type: " + name
            return getCellWithTitle(title: title, tableView: tableView, indexPath: indexPath)
        case .area(let name):
            let title = "Area: " + name
            return getCellWithTitle(title: title, tableView: tableView, indexPath: indexPath)
        case .survey(let category):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyQuestionTableViewCell", for: indexPath) as? SurveyQuestionTableViewCell else { return UITableViewCell() }
            guard let questions = category.questions, indexPath.row < questions.count else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.tag = category.id ?? .zero
            cell.configureCell(question: questions[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section < inspectionVM.formFieldData.count else { return .zero }
        switch inspectionVM.formFieldData[indexPath.section] {
        case .inspectionType, .area:
            return 40
        case .survey:
            return UITableView.automaticDimension
        }
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section < inspectionVM.formFieldData.count else { return UIView() }
        switch inspectionVM.formFieldData[section] {
        case .inspectionType, .area:
            return UILabel()
        case .survey(let category):
            return getSectionHeaderView(name: category.name ?? "")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section < inspectionVM.formFieldData.count else { return .zero }
        switch inspectionVM.formFieldData[section] {
        case .inspectionType, .area:
            return .zero
        case .survey:
            return 24
        }
    }
        
    func getCellWithTitle(title: String, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = title
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        cell.backgroundColor = .clear
        return cell
    }
    
    func getSectionHeaderView(name: String) -> UIView {
        let view = UIView(frame: CGRect(x: .zero, y: .zero, width: tableView.frame.width, height: 24))
        view.backgroundColor = .clear
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.text = "Survey: \(name)"
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .zero).isActive = true
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return view
    }
    
}
extension InspectionVC: UpdateInspectionVCProtocol{
    func loadNewData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func showAlert(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.showAlertMessage(message)
        }
    }
}
