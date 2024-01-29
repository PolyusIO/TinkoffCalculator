//
//  CalculationsListViewController.swift
//  TinkoffCalculator
//
//  Created by Сергей Поляков on 30.01.2024.
//

import UIKit

class CalculationsListViewController: UIViewController {

    
    @IBOutlet weak var calculationLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculationLabel.text = result
    }
    
    var result = ""
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
