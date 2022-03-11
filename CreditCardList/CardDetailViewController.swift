//
//  CardDetailViewController.swift
//  CreditCardList
//
//  Created by 강루비 on 2022/03/11.
//

import UIKit
import Lottie

class CardDetailViewController: UIViewController {
  
  var promotionDetail: PromotionDetail?
  
  @IBOutlet var lottieView: AnimationView!
  
  @IBOutlet var titleLabel: UILabel!
  
  @IBOutlet var periodLabel: UILabel!
  @IBOutlet var conditionLabel: UILabel!
  @IBOutlet var benefitConditionLabel: UILabel!
  @IBOutlet var benefitDetailLabel: UILabel!
  @IBOutlet var benefitDateLabel: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      let animationView = AnimationView(name: "money")
      lottieView.contentMode = .scaleAspectFit
      lottieView.addSubview(animationView)
      animationView.frame = lottieView.bounds
      animationView.loopMode = .loop
      animationView.play()
    }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    guard let detail = promotionDetail else { return }
    
    titleLabel.text = """
      \(detail.companyName)카드 쓰면
      \(detail.amount)만원 드려요.
    """
    
    periodLabel.text = detail.period
    conditionLabel.text = detail.condition
    benefitConditionLabel.text = detail.benefitCondition
    benefitDetailLabel.text = detail.benefitDetail
    benefitDateLabel.text = detail.benefitDate
  }


}
