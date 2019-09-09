//
//  FancyCarViewController.swift
//  FancyCars
//
//  Created by Chris Ta on 2019-09-08.
//  Copyright © 2019 WalmartLab. All rights reserved.
//

import UIKit

class FancyCarViewController: UIViewController, CarCellDelegate {

    @IBOutlet weak var carTable: UITableView!
    
    var carList = [FancyCar]()
    var carService = CarService.sharedInstance
    
    private let reuseId = "CarCell"
    //assume there are total 20 pages; each page contains 20 records
    var currentPage = 0
    var totalPageCount = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Fancy Cars"
        
        setupNavigationBar()
        setupCarTable()
        carService.fetchCars { (result) in
            switch result {
            case .success(let cars):
                self.carList.append(contentsOf: cars)
                DispatchQueue.main.async {
                    self.carTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    func setupCarTable() {
        carTable.dataSource = self
        carTable.delegate = self
        carTable.register(UINib(nibName: "CarTableViewCell", bundle: nil), forCellReuseIdentifier: reuseId)
        carTable.estimatedRowHeight = 120
    }
    
    func setupNavigationBar() {
        let sortBtn = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(didTapSort))
        self.navigationItem.rightBarButtonItem = sortBtn
    }

    @objc func didTapSort() {
        let alertVC = UIAlertController(title: "Sort", message: nil, preferredStyle: .actionSheet)
        let sortByName = UIAlertAction(title: "By name A-Z", style: .default) { [weak self] (action) in
            guard self != nil else { return }
            self!.carList = self!.carList.sorted(by: { (a, b) -> Bool in
                return a.name < b.name
            })
            self!.carTable.reloadData()
        }
        alertVC.addAction(sortByName)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func didBuy(from cell: CarTableViewCell) {
//        let selectedCar = carList[cell.tag]
        //call buycar service to handle it
    }
}

extension FancyCarViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! CarTableViewCell
        
        let car = carList[indexPath.row]
        cell.delegate = self
        cell.populate(car: car)
        cell.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //fetch next set of records when at the end of current list
        if indexPath.row == carList.count - 1 {
            if currentPage < totalPageCount {
                carService.fetchCars(page: currentPage+1) { (result) in
                    switch result {
                    case .success(let newCars):
                        self.carList.append(contentsOf: newCars)
                        self.currentPage += 1
                        print("\(self.currentPage)")
                        DispatchQueue.main.async {
                            self.carTable.reloadData()
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
