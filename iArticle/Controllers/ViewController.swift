//
//  ViewController.swift
//  iArticle
//
//  Created by Mavin Sao on 29/9/21.
//

import UIKit
import ProgressHUD

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var articles: [ArticleModel] = []
    var filterArticles: [ArticleModel] = []
    
    //Page
    var page: Int = 1
    var size: Int = 10
    var totalPage: Int = 0
    
    var isLoading = false
    var isShouldFetch: Bool = true
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchData(nPage: page, nSize: size, isMore: false)
        prepareSearchView()
        //Register Loading Cell
        self.tableView.register(UINib(nibName: "LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: "loadingcellid")
        
        //Refresh
        // initializing the refreshControl
        tableView.refreshControl = UIRefreshControl()
        // add target to UIRefreshControl
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
          
    }
    
    @objc func refresh(){
        page = 1
        fetchData(nPage: page, nSize: size, isMore: false)

    }
    
    func prepareSearchView() {
        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search Articles"
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailViewController
        destinationVC.article = articles[self.tableView.indexPathForSelectedRow!.row]
        
    }
    
    
    func fetchData(nPage: Int, nSize: Int, isMore: Bool){
        ArticleService.shared.fetchArticle(page: nPage,size: nSize){ result in
            switch result {
                case .success(let articles):
                    print("fetch", articles.count)
                        if articles.count == 0 {
                            self.isShouldFetch = false
                        }else{
                            self.isShouldFetch = true
                        }
                    
                        if isMore {
                            self.articles += articles
                        }else{
                            self.articles = articles
                        }
                        self.tableView.refreshControl?.endRefreshing()
                        ProgressHUD.dismiss()
                        
                        self.tableView.reloadData()
                case .failure(let error): ProgressHUD.showError(error.localizedDescription)
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
           return filterArticles.count
        }else{
           return articles.count
        }
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleTableViewCell
        cell.selectionStyle = .none
        
        if isFiltering {
            cell.config(article: filterArticles[indexPath.row])
        }else{
            cell.config(article: articles[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !isFiltering {
            if indexPath.row == self.articles.count - 1 && isShouldFetch{
                page += 1
                print(page)
                ProgressHUD.show()
                fetchData(nPage: page, nSize: size, isMore: true)
            }
        }
       
    }
    
    
    
    
}

extension ViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filterArticles = articles.filter { (article: ArticleModel) -> Bool in
            return article.title.lowercased().contains(searchText.lowercased())
      }
      tableView.reloadData()
    }
}
