//
//  FaqsVC.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 12/02/2024.
//

import UIKit

class FaqsVC: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var items = [
        FaqsModel(title: "How to create a account?", description: "Open the Tradebase app to get started and follow the steps. Tradebase doesn’t charge a fee to create or maintain your Tradebase account.", isOpen: false),
        FaqsModel(title: "How to add a payment method by this app?", description: "Open the Tradebase app to get started and follow the steps. Tradebase doesn’t charge a fee to create or maintain your Tradebase account.", isOpen: false),
        FaqsModel(title: "What Time Does The Stock Market Open?", description: "Open the Tradebase app to get started and follow the steps. Tradebase doesn’t charge a fee to create or maintain your Tradebase account.", isOpen: false),
        FaqsModel(title: "Is The Stock Market Open On Weekends?", description: "Open the Tradebase app to get started and follow the steps. Tradebase doesn’t charge a fee to create or maintain your Tradebase account.", isOpen: false)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension FaqsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FaqsCell
        cell.configure(model: items[indexPath.item], delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}

extension FaqsVC: FaqsCellDelegate {
    func openCloseDidPress(cell: FaqsCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        items[indexPath.item].isOpen = !items[indexPath.item].isOpen
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
