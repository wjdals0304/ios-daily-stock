//
//  StockStudyViewController.swift
//  DailyStock
//
//  Created by 김정민 on 2021/11/19.
//

import UIKit
import RealmSwift


class StockStudyViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    let localRealm = try! Realm()
    var tasks : Results<UserStockStudy>!
    var filteredStock : Results<UserStockStudy>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nibName = UINib(nibName: StockStudyCollectionViewCell.identifier, bundle: nil)
        self.collectionView.register(nibName, forCellWithReuseIdentifier: StockStudyCollectionViewCell.identifier)
        
        self.tasks = localRealm.objects(UserStockStudy.self)
        self.navigationItem.title = "종목 분석"
        
        // collection view layout
        let spacing: CGFloat = 15
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 170  , height:150 )
        layout.sectionInset = UIEdgeInsets(top:spacing,left:spacing,bottom:spacing,right:spacing)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        
        setUpSearchController()
                
    }
    
    var isFiltering : Bool {
    
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        
        return isActive && isSearchBarHasText
    }
    
    
    
    @IBAction func addButtonClicked(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StockStudyDetailViewController") as! StockStudyDetailViewController
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav,animated: true, completion: nil)
        
    }
    
    
    func setUpSearchController() {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "종목 검색"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self

        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
}


extension StockStudyViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.isFiltering ? filteredStock.count : tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:StockStudyCollectionViewCell.identifier , for: indexPath )  as? StockStudyCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if self.isFiltering {
            
            let filterRow = filteredStock[indexPath.row]
            
            cell.stockNameLabel.text = filterRow.stockName
            cell.updateDateLabel.text = formatter.string(from: filterRow.updateDate)
            
        } else {
            
            let row = tasks[indexPath.row]
            
            cell.stockNameLabel.text = row.stockName
            cell.updateDateLabel.text =  formatter.string(from: row.updateDate)
            
        }
                
        return cell
    }
        
}



extension StockStudyViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        //대소문자
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        
        self.filteredStock = self.localRealm.objects(UserStockStudy.self).filter("stockName CONTAINS %@" ,text)
        
        self.collectionView.reloadData()
    }
    
}