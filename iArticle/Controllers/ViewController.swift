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
    
    let searchController            = UISearchController(searchResultsController: nil)
    var articles: [ArticleModel]    = []
    var archieveArticles: [Article] = []
    
    
    var filterArticles: [ArticleModel] = []
    
    //Page
    var page: Int      = 1
    var size: Int      = 10
    var totalPage: Int = 0
    
    var isLoading      = false
    var isShouldFetch: Bool = true
    
    var selectedUpdateRow: Int?
    
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
        
        //Custom Navigation
        
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
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
    
    //MARK: - Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "viewArticle"{
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.article = articles[self.tableView.indexPathForSelectedRow!.row]
        }else if segue.identifier == "updateSegue"{
            let destinationVC = segue.destination as! UpdateViewController
            
            let article = self.articles[selectedUpdateRow!]
            destinationVC.articleUpdate = article
        }
        
        
    }
    
    
    //MARK: - Fetch Data API
    func fetchData(nPage: Int, nSize: Int, isMore: Bool){
        ProgressHUD.show()
        ArticleService.shared.fetchArticle(page: nPage,size: nSize){ result in
            switch result {
                case .success(let articles):
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
    
    //MARK: - Setting

    @IBAction func openSetting(_ sender: Any) {
        
        let settingVC = storyboard?.instantiateViewController(withIdentifier: "settingVC")
        present(settingVC!, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Cell Action
    private func handleMoveToTrash(indexPath:IndexPath) {
        let articleID = self.articles[indexPath.row].id
        ArticleService.shared.deleteArticle(articleId: articleID) { msg in
            ProgressHUD.showSucceed(msg)
            self.articles.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    private func handleMoveToArchive(indexPath:IndexPath) {
        let articleID = self.articles[indexPath.row].id
        ArticleService.shared.archieveArticle(articleId: articleID) { message in
            ProgressHUD.showSucceed(message)
        }
    }
    private func handleUpdateArticle(indexPath:IndexPath) {
       self.selectedUpdateRow = indexPath.row
       performSegue(withIdentifier: "updateSegue", sender: nil)
    }
    
}


//MARK: - Extension

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completion in
            self.handleMoveToTrash(indexPath: indexPath)
            completion(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let archiveAction = UIContextualAction(style: .normal, title: "Archive") { action, view, completion in
            self.handleMoveToArchive(indexPath: indexPath)
            completion(true)
        }
        
        archiveAction.image = UIImage(systemName: "archivebox.fill")
        
        let updateAction = UIContextualAction(style: .normal, title: "Update") { action, view, completion in
            self.handleUpdateArticle(indexPath: indexPath)
            completion(true)
        }
        updateAction.backgroundColor = .brown
        updateAction.image = UIImage(systemName: "pencil.circle.fill")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction,archiveAction,updateAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
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
