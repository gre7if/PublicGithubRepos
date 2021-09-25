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
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let shareButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.link.cgColor
        button.layer.borderWidth = 1
        button.setTitle("Share", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.link, for: .normal)
        button.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
        button.imageView?.tintColor = .link
        // Возможность масштабирования содержимого по размеру представления с сохранением соотношения сторон.
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        
        layer.borderWidth = 0.5
        layer.borderColor = Colors.separatorColor.cgColor
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
            nameLabel.trailingAnchor.constraint(equalTo: shareButton.leadingAnchor, constant: 0),
            nameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            ownerLoginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            ownerLoginLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            ownerLoginLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            ownerLoginLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: ownerLoginLabel.bottomAnchor, constant: -4),
            descriptionLabel.leadingAnchor.constraint(equalTo: ownerLoginLabel.leadingAnchor, constant: -4),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            shareButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            shareButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            shareButton.widthAnchor.constraint(equalToConstant: 100),
            shareButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    // метод, который вызывается каждый раз, когда таблица пытается повторно использовать ячейку
    // при этом инициализатор заново не вызывается
    override func prepareForReuse() {
        super.prepareForReuse()
        // сбрасываем все данные ячейки
        idLabel.text = nil
        nameLabel.text = nil
        ownerLoginLabel.text = nil
        descriptionLabel.text = nil
    }
    
    private func addSubviews() {
        addSubview(idLabel)
        addSubview(nameLabel)
        addSubview(ownerLoginLabel)
        addSubview(descriptionLabel)
        addSubview(shareButton)
    }
    
    func configure(viewModel: RepoViewModel) {
        idLabel.text = "\(viewModel.id)"
        nameLabel.text = "\(viewModel.name)"
        ownerLoginLabel.text = "@\(viewModel.ownerLogin)"
        descriptionLabel.text = "\(viewModel.description)"
    }
}

extension ReposCollectionViewCell {
    //------------------ Constants -------------
    private struct Colors {
        static let separatorColor = #colorLiteral(red: 0.9124323726, green: 0.9125853777, blue: 0.9124122262, alpha: 1)
    }
}
