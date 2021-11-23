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
    var searchWord : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.layer.backgroundColor = UIColor(red: 0.914, green: 0.916, blue: 0.938, alpha: 1).cgColor
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(red: 0.914, green: 0.916, blue: 0.938, alpha: 1)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
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
        
        cell.layer.borderColor = UIColor(red: 0.914, green: 0.916, blue: 0.938, alpha: 1)
            .cgColor
        cell.backgroundColor = .white
        cell.layer.borderWidth = 10
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        
        
        if self.isFiltering {
            
            let filterRow = filteredStock[indexPath.row]
            
            cell.stockNameLabel.text = filterRow.stockName
            cell.stockNameLabel.KeywordBlue(searchWord ?? "" )
            cell.updateDateLabel.text = formatter.string(from: filterRow.updateDate)
            
        } else {
            
            let row = tasks[indexPath.row]
            
            cell.stockNameLabel.text = row.stockName
            cell.updateDateLabel.text =  formatter.string(from: row.updateDate)
            
        }
       
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StockStudyDetailViewController") as! StockStudyDetailViewController
        
        vc.studyData = self.isFiltering ? filteredStock[indexPath.row] : tasks[indexPath.row]
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        
        self.present(nav,animated: true, completion: nil)
        
        
    }
        
}


extension StockStudyViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        //대소문자
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        
        self.searchWord = text
        
        self.filteredStock = self.localRealm.objects(UserStockStudy.self).filter("stockName CONTAINS %@" ,text)
        
        self.collectionView.reloadData()
    }
    
}
