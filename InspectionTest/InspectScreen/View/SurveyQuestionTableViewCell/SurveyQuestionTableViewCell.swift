//
//  SurveyQuestionTableViewCell.swift
//  InspectionTest
//
//  Created by Zubin Gala on 12/08/24.
//

import UIKit

class SurveyQuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var questionTxt: UILabel!
    @IBOutlet weak var questionTblView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    weak var question: Question?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        questionTblView.delegate = self
        questionTblView.dataSource = self
        self.questionTblView.separatorStyle = .none
        self.questionTblView.showsHorizontalScrollIndicator = false
        self.questionTblView.showsVerticalScrollIndicator = false
        self.questionTblView.register(UINib(nibName: "SurveyAnswerTableViewCell", bundle: nil), forCellReuseIdentifier: "SurveyAnswerTableViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(question: Question) {
        self.question = question
        questionTxt.text = question.name
        guard let answerChoices = question.answerChoices else { return }
        tableViewHeightConstraint.constant = CGFloat(30 * answerChoices.count)
        questionTblView.reloadData()
    }
    
}

extension SurveyQuestionTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let answers = question?.answerChoices else { return .zero }
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let answers = question?.answerChoices, indexPath.row < answers.count else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyAnswerTableViewCell", for: indexPath) as? SurveyAnswerTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.configureCell(answer: answers[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let answers = question?.answerChoices, indexPath.row < answers.count else { return .zero }
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SurveyAnswerTableViewCell else { return }
        guard let answerID = question?.answerChoices?[indexPath.row].id else { return }
        cell.selectedAnsImgView.image = UIImage(systemName: "checkmark.circle.fill")
        question?.selectedAnswerChoiceId = answerID
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SurveyAnswerTableViewCell else { return }
        cell.selectedAnsImgView.image = UIImage(systemName: "circle")
    }
}
