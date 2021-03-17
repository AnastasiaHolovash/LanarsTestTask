//
//  ViewController.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 17.03.2021.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    private func tableViewSetup() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: PersonTableViewCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: PersonTableViewCell.identifier)
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        
        let viewController = AddNewPersonViewController.create()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension ListViewController: UITableViewDelegate {
    
}

