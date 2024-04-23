//
//  AboutPageViewController.swift
//  ProjectMarvel
//
//  Created by Dustin Tong on 2/14/24.
//

import UIKit

class AboutPageViewController: UIViewController {

    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }
    func setupUI() {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        self.versionLabel.text = appVersion
    }
}
