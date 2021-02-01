//
//  TableViewController.swift
//  PryanikiTest
//
//  Created by Николаев Никита on 30.01.2021.
//

import UIKit

class TableViewController: UITableViewController {
    
    var sortedData: [DataBlock]?
    
    // MARK:  Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: AppConstants.Identifiers.cell)
        tableView.tableFooterView = UIView()
        fetchTestData()
    }

    // MARK:  Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedData?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.Identifiers.cell, for: indexPath) as! TableViewCell
        guard let currentDataItem = sortedData?[indexPath.row] else { return cell }
        cell.setup(by: currentDataItem)
        cell.selectorHandler = { [weak self] index in
            guard let variant = currentDataItem.data.variants?[index].text else { return }
            self?.showAlert(with: variant)
        }
        return cell
    }
    
    // MARK:  Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let index = tableView.indexPathForSelectedRow?.row else { return }
        let selectedData = sortedData?[index]
        showAlert(with: selectedData?.data.text)
    }

    // MARK:  Fetch data
    
    private func showAlert(with message: String?) {
        let alertController = UIAlertController(title: AppConstants.UI.Messages.alertTitle,
                                                message: message,
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: AppConstants.UI.Messages.cancelTitle, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    private func fetchTestData() {
        NetworkManager.shared.fetchDataByTestURL { result in
            switch result {
            case .success(let pryanikiResponse):
                let data = pryanikiResponse.data
                let views = pryanikiResponse.view
                self.sortedData = self.sort(data, by: views)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func sort(_ data: [DataBlock], by views: [String]) -> [DataBlock] {
        var localData = data
        var sortedData = [DataBlock]()
        for view in views {
            for (index, item) in localData.enumerated() {
                if view == item.name {
                    let foundItem = localData.remove(at: index)
                    sortedData.append(foundItem)
                    break
                }
            }
        }
        return sortedData
    }
}
