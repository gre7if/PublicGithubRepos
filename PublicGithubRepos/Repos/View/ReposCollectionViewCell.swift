//
//  ReposCollectionViewCell.swift
//  PublicGithubRepos
//
//  Created by Rustam Nigmatzyanov on 21.09.2021.
//

import UIKit

class ReposCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ReposCollectionViewCell"
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.backgroundColor = .white
        return stackView
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
//        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let ownerLoginLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // метод, который вызывается, когда границы bounds у view меняются (при повороте экрана и т.д.)
    override func layoutSubviews() {
        super.layoutSubviews()
        idLabel.frame = CGRect(
            x: 0,
            y: 0,
            width: 50,
            height: contentView.frame.size.height
        )

        stackView.frame = CGRect(
            x: idLabel.frame.size.width,
            y: 0,
            width: contentView.frame.size.width - idLabel.frame.size.width,
            height: contentView.frame.size.height
        )
    }

    // метод, который вызывается каждый раз, когда таблица пытается повторно использовать ячейку
    // при этом инициализатор заново не вызывается
    override func prepareForReuse() {
        super.prepareForReuse()
        // при переиспользовании ячейки каждый раз начинаем с nil
        idLabel.text = nil
        nameLabel.text = nil
        ownerLoginLabel.text = nil
        descriptionLabel.text = nil
    }
    
    private func addSubviews() {
        stackView.addArrangedSubview(ownerLoginLabel)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(descriptionLabel)
        contentView.addSubview(idLabel)
        contentView.addSubview(stackView)
    }
    
    func configure(viewModel: RepoViewModel) {
        idLabel.text = "\(viewModel.id)"
        nameLabel.text = "\(viewModel.name)"
        ownerLoginLabel.text = "@\(viewModel.ownerLogin)"
        descriptionLabel.text = "\(viewModel.description)"
    }
}
