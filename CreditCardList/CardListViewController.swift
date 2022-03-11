//
//  CardListViewController.swift
//  CreditCardList
//
//  Created by 강루비 on 2022/03/11.
//

import UIKit
import Kingfisher
import FirebaseDatabase

class CardListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  var ref: DatabaseReference! // Firebase Realtime Database
  
  var creditCardList: [CreditCard] = []
  
  @IBOutlet var tableView: UITableView!
  
    override func viewDidLoad() {
      super.viewDidLoad()
      
      tableView.delegate = self
      tableView.dataSource = self
      
      // UITableView Cell Register
      let nibName = UINib(nibName: "CardListCell", bundle: nil)
      tableView.register(nibName, forCellReuseIdentifier: "CardListCell")
      
      ref = Database.database().reference()
      
      ref.observe(.value) { snapshot in
        guard let value = snapshot.value as? [String: [String: Any]] else { return }
        
        do {
          let jsonData = try JSONSerialization.data(withJSONObject: value)
          let cardData = try JSONDecoder().decode([String: CreditCard].self, from: jsonData)
          let cardList = Array(cardData.values)
          self.creditCardList = cardList.sorted { $0.rank < $1.rank }
          
          DispatchQueue.main.async {
            self.tableView.reloadData()
          }
        } catch let error {
          print("ERROR JSON parsing \(error.localizedDescription)")
        }
        
      }
    }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return creditCardList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCell", for: indexPath) as? CardListCell else { return UITableViewCell() }
    
    cell.rankLabel.text = "\(creditCardList[indexPath.row].rank)위"
    cell.promotionLabel.text = "\(creditCardList[indexPath.row].promotionDetail.amount)만원 증정"
    cell.cardNameLabel.text = "\(creditCardList[indexPath.row].name)"
    
    let imageURL = URL(string: creditCardList[indexPath.row].cardImageURL)
    cell.cardImageView.kf.setImage(with: imageURL)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // 상세화면 전달
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    guard let detailViewController = storyboard.instantiateViewController(withIdentifier: "CardDetailViewController") as? CardDetailViewController else { return }
    
    detailViewController.promotionDetail = creditCardList[indexPath.row].promotionDetail
    self.show(detailViewController, sender: nil)
    
    // option 1
    let cardID = creditCardList[indexPath.row].id
    ref.child("Item\(cardID)/isSelected").setValue(true)
    
    // option 2
//    ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) {[weak self] snapshot in
//        guard let self = self,
//              let value = snapshot.value as? [String: [String: Any]],
//              let key = value.keys.first else { return }
//
//        self.ref.child("\(key)/isSelected").setValue(true)
    //}
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      // option 1
      let cardID = creditCardList[indexPath.row].id
      ref.child("Item\(cardID)").removeValue()
      
      // option 2
//      ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) { [weak self] snapshot in
//        guard let self = self,
//              let value = snapshot.value as? [String: [String: Any]],
//              let key = value.keys.first else { return }
//
//        ref.child(key).removeValue()
//      }
      
    }
    
  }
    
}
