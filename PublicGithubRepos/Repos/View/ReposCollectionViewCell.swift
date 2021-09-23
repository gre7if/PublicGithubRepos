//
//  ReposCollectionViewCell.swift
//  PublicGithubRepos
//
//  Created by Rustam Nigmatzyanov on 21.09.2021.
//

import UIKit

class ReposCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ReposCollectionViewCell"

    private let idLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ownerLoginLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        
        layer.borderWidth = 0.5
        layer.borderColor = #colorLiteral(red: 0.9124323726, green: 0.9125853777, blue: 0.9124122262, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // метод, который вызывается, когда границы bounds у view меняются (при повороте экрана и т.д.)
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            idLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            idLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            idLabel.widthAnchor.constraint(equalToConstant: 50),
            idLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: idLabel.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: idLabel.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 12),
            nameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            ownerLoginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            ownerLoginLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            ownerLoginLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            ownerLoginLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: ownerLoginLabel.bottomAnchor, constant: -4),
            descriptionTextView.leadingAnchor.constraint(equalTo: ownerLoginLabel.leadingAnchor, constant: -4),
            descriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // метод, который вызывается каждый раз, когда таблица пытается повторно использовать ячейку
    // при этом инициализатор заново не вызывается
    override func prepareForReuse() {
        super.prepareForReuse()
        // при переиспользовании ячейки каждый раз начинаем с nil
        idLabel.text = nil
        nameLabel.text = nil
        ownerLoginLabel.text = nil
        descriptionTextView.text = nil
    }
    
    private func addSubviews() {
        addSubview(idLabel)
        addSubview(nameLabel)
        addSubview(ownerLoginLabel)
        addSubview(descriptionTextView)
    }
    
    func configure(viewModel: RepoViewModel) {
        idLabel.text = "\(viewModel.id)"
        nameLabel.text = "\(viewModel.name)"
        ownerLoginLabel.text = "@\(viewModel.ownerLogin)"
        descriptionTextView.text = "\(viewModel.description)"
    }
}
