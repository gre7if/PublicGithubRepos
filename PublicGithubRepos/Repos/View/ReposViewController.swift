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
    func stopActivityIndicator()
    func configureUI()
}

protocol ReposViewControllerOutput {
    func prepareData(id: Int)
}

class ReposViewController: UIViewController, ReposViewControllerInput {
    
    var presenter: ReposViewControllerOutput
    private var viewModel = [RepoViewModel]()
    // for pagging
    var sinceID = 0
        
    private lazy var contentView = ReposView()
    private var collectionView: UICollectionView { contentView.collectionView }
    private var spinner: UIActivityIndicatorView { contentView.spinner }
    
    init(presenter: ReposViewControllerOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(viewModel: [RepoViewModel]) {
        self.viewModel = viewModel
    }
    
    func reloadView() {
        collectionView.reloadData()
    }
    
    func stopActivityIndicator() {
        spinner.stopAnimating()
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
        spinner.startAnimating()
        presenter.prepareData(id: sinceID)
    }
}

extension ReposViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let vm = viewModel[safe: indexPath.row] else { return }
        let detailedRepoVC = DetailedRepoViewController(viewModel: vm)
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
}
