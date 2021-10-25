//
//  addButton.swift
//  TestStoryboard
//
//  Created by Sepuh Hovhannisyan on 01.09.21.
//

//import Foundation
//import UIKit
//
//
//class AddButton: UIButton {
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configeBtn()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//       super.init(coder: aDecoder)
//        configeBtn()
//    }
//
//    func configeBtn() {
//        self.addTarget(self, action: #selector(btnClicked(_:)), for: .touchUpInside)
//    }
//    @objc func btnClicked (_ sender:UIButton ) {
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let nextView = storyBoard.instantiateViewController(identifier: "input") as! inputViewController
////        self.present(nextView, animated: true, completion: nil)
//    }
//}
