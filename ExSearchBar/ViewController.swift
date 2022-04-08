//
//  ViewController.swift
//  ExSearchBar
//
//  Created by misoKim on 2022/04/08.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var wines: [Wine] = []
    var filteredWines: [Wine] = []
    let searchController = UISearchController(searchResultsController: nil)
   
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
      return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSearchController()
        self.setupTableView()
    }
    
    func setupSearchController() {
        
        wines = Wine.wines()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Wines"
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.scopeButtonTitles = Wine.Category.allCases.map { $0.rawValue }
        searchController.searchBar.delegate = self
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Search"
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setupTableView() {
        self.tableView.dataSource = self
    }
    
    func filterContentForSearchText(_ searchText: String, category: Wine.Category? = nil) {
        filteredWines = wines.filter { (wine: Wine) -> Bool in
        let doesCategoryMatch = category == .all || wine.category == category
        
        if isSearchBarEmpty {
          return doesCategoryMatch
        } else {
          return doesCategoryMatch && wine.name.lowercased().contains(searchText.lowercased())
        }
      }
      
      tableView.reloadData()
    }

}

extension ViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering ? self.filteredWines.count : self.wines.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let wine: Wine
        if self.isFiltering {
            wine = self.filteredWines[indexPath.row]
        } else {
            wine = self.wines[indexPath.row]
        }
        cell.textLabel?.text = wine.name
        return cell
    }
}

extension ViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    let category = Wine.Category(rawValue:
      searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
    filterContentForSearchText(searchBar.text!, category: category)
  }
}

extension ViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    let category = Wine.Category(rawValue:
      searchBar.scopeButtonTitles![selectedScope])
    filterContentForSearchText(searchBar.text!, category: category)
  }
}

