//
//  ReposViewController.swift
//  PublicGithubRepos
//
//  Created by Rustam Nigmatzyanov on 21.09.2021.
//

import UIKit

protocol ReposViewControllerInput: AnyObject {
    func setupView(viewModel: [RepoViewModel])
    func reloadView()
    func configureUI()
}

protocol ReposViewControllerOutput {
    func prepareData(id: Int)
}

class ReposViewController: UIViewController, ReposViewControllerInput {
    
    var presenter: ReposViewControllerOutput
    private var viewModel = [RepoViewModel]()
    
    // for pagination
    var isLoading = false
    private lazy var loadingView = CollectionReusableView()
        
    private lazy var contentView = ReposView()
    private var collectionView: UICollectionView { contentView.collectionView }
    
    init(presenter: ReposViewControllerOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(viewModel: [RepoViewModel]) {
        self.viewModel += viewModel
    }
    
    func reloadView() {
        collectionView.reloadData()
        isLoading = false
    }
    
    func configureUI() {
        title = "Public repositories"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        presenter.prepareData(id: 0)
    }
}

extension ReposViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let vm = viewModel[safe: indexPath.row] else { return }
        let detailedRepoVC = DetailedRepoViewController(viewModel: vm)
        detailedRepoVC.urlString = "https://github.com/\(vm.ownerLogin)/\(vm.name)"
        navigationController?.pushViewController(detailedRepoVC, animated: true)
    }
}

extension ReposViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReposCollectionViewCell.identifier, for: indexPath) as? ReposCollectionViewCell,
              let repo = viewModel[safe: indexPath.row]
        else { return UICollectionViewCell() }
        cell.configure(viewModel: repo)
        return cell
    }
}

extension ReposViewController: UICollectionViewDelegateFlowLayout {

    // размер элементов
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // высчитываем приблизительную высоту ячейки в зависимости от высоты текста
        if let repo = viewModel[safe: indexPath.row] {
            
            let approximateWidthOfDescriptionTextView = view.frame.width - 12 - 50 - 12 - 2
            let size = CGSize(width: approximateWidthOfDescriptionTextView, height: 1000)
            // размер текста в descriptionTextView
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
            // оценка высоты ячейки на основе текста в repo.description
            let estimatedFrame = NSString(string: repo.description)
                .boundingRect(
                    with: size,
                    options: .usesLineFragmentOrigin,
                    attributes: attributes,
                    context: nil
                )
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 66)
        }
        
        return CGSize(width: view.frame.width, height: 150)
    }

    // интервал между строками
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    // MARK: - Pagination
    
    // метод, чтобы вернуть размер для CollectionReusableView, когда пришло время его показать.
    // for footer
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading {
             return CGSize.zero
         } else {
             return CGSize(width: collectionView.bounds.size.width, height: 55)
         }
    }
    
    // устанавливаем многоразовое view - CollectionReusableView в нижнем колонтитуле (footer)
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionReusableView.identifier, for: indexPath) as! CollectionReusableView
            loadingView = aFooterView
            loadingView.backgroundColor = UIColor.clear
            return aFooterView
        }
        return UICollectionReusableView()
    }
    
    // запускаем и останавливаем spinner, когда footer появляется
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView.spinner.startAnimating()
        }
    }
    
    // запускаем и останавливаем spinner, когда footer исчезает
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView.spinner.stopAnimating()
        }
    }
    
    // Наконец, мы устанавливаем время, в которое мы хотим загрузить больше данных при прокрутке. В этом примере он загрузит больше данных, когда пользователь увидит 10-ю ячейку снизу.
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.count - 1 && !self.isLoading {
            loadMoreData()
        }
    }
    
    func loadMoreData() {
        guard !self.isLoading else { return }
        self.isLoading = true
        DispatchQueue.global().async {
            // Fake background loading task for 2 seconds
            sleep(2)
            // Download more data here
            guard let lastId = self.viewModel.last?.id else { return }
            self.presenter.prepareData(id: lastId)
        }
    }
}
