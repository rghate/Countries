//
//  CountryListViewController.swift
//  Countries
//
//  Created by Syft on 03/03/2020.
//  Copyright © 2020 Syft. All rights reserved.
//

import UIKit
import CoreData


class CountryListViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var countryTableView: UITableView!
    
    var countries: [Country]?
    
    var fetchedResultController: NSFetchedResultsController<Country> = NSFetchedResultsController()
        
    let cellId = "CountryInfoCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        countryTableView.rowHeight = UITableView.automaticDimension
        countryTableView.estimatedRowHeight = 100
        countryTableView.dataSource = self
        countryTableView.accessibilityIdentifier = "CountryTable"
        
        fetchCountries()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        HUD.show(in: view.window!)
        Server.shared.countryList() { (error) in
            HUD.dismiss(from: self.view.window!)
            guard error == nil else {
                assertionFailure("There was an error: \(error!)")
                return
            }

            self.countryTableView.reloadData()
        }
    }
    
    //MARK:- Added by Rupali
    fileprivate func fetchCountries() {
        let dataStore = DataStore.shared
        let managedObjectContext =  dataStore.viewContext
        
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        // fetch countris by the ascending order of their names
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        self.fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest,  managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultController.delegate = self
        
        dataStore.performBackgroundTask { context in
            do {
                try self.fetchedResultController.performFetch()
            } catch let error {
                CustomAlert.showAlert(withTitle: "Error", message: "Unable to fetch countries.\n\n\(error.localizedDescription)", viewController: self)
            }
        }
    }

    // MARK:- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! CountryTableViewCell
        
        if let country = countries?[indexPath.row] {
            cell.country.text = country.name
            cell.capital.text = country.capital
            cell.population.text = NSNumber(value: country.population).formattedValue
            //MARK:- Added by Rupali - Region and Area
            cell.region.text = country.region
            if country.area > 0 {
                cell.area.text = NSNumber(value: country.area).formattedValue! + " km²"
            } else {
                cell.area.text = ""
            }

            cell.accessibilityIdentifier = "\(country.name!)-Cell"
            cell.country.accessibilityIdentifier = "Country"
            cell.capital.accessibilityIdentifier = "\(country.name!)-Capital"
            if country.capital?.isEmpty == false {
                cell.capitalLabel.accessibilityIdentifier = "\(country.name!)-Capital-Label"
            }
            cell.population.accessibilityIdentifier = "\(country.name!)-Population"
            cell.populationLabel.accessibilityIdentifier = "\(country.name!)-Population-Label"
            //MARK:- Added by Rupali - Region and Area
            cell.region.accessibilityIdentifier = "\(country.name!)-Region"
            cell.area.accessibilityIdentifier = "\(country.name!)-Area"
        }
        return cell
    }
}

// MARK:- Extension
extension CountryListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.countries = controller.fetchedObjects as? [Country]
    }
}

