//
//  SurveyAnswerTableViewCell.swift
//  InspectionTest
//
//  Created by Zubin Gala on 12/08/24.
//

import UIKit

class SurveyAnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var selectedAnsImgView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(answer: AnswerChoice) {
        selectedAnsImgView.image = UIImage(systemName: "circle")
        answerLabel.text = answer.name
    }
    
}
