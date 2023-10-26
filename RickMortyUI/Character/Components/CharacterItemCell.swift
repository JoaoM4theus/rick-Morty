//
//  CharacterItemCell.swift
//  RickMortyUI
//
//  Created by Joao Matheus on 17/10/23.
//

import UIKit

public protocol ViewCodeHelper {
    func buildViewHierarchy()
    func setupConstraints()
    func setupAdditionalConfiguration()
    func setupView()
}

public extension ViewCodeHelper {
    func setupView() {
        buildViewHierarchy()
        setupConstraints()
        setupAdditionalConfiguration()
    }
    func setupAdditionalConfiguration() {}
}

extension UITableViewCell {
    static var identifier: String {
        return "\(type(of: self))"
    }
}

class CharacterItemCell: UITableViewCell {

    private(set) lazy var hStack = renderStack(axis: .horizontal, spacing: 8, alignment: .center)
    private(set) lazy var vStack = renderStack(axis: .vertical, spacing: 2, alignment: .leading)
    private(set) lazy var characterImage = renderImage()
    private(set) lazy var name = renderLabel(font: .preferredFont(forTextStyle: .body))
    private(set) lazy var moreInfo = renderLabel(font: .preferredFont(forTextStyle: .body))
    private(set) lazy var disclosureIndicator = renderSystemImage(name: "arrow.right.to.line")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func renderLabel(font: UIFont, textColor: UIColor = .black) -> UILabel {
        let label = UILabel()
        label.font = font
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func renderStack(axis: NSLayoutConstraint.Axis, spacing: CGFloat, alignment: UIStackView.Alignment) -> UIStackView {
        let stack = UIStackView()
        stack.axis = axis
        stack.spacing = spacing
        stack.alignment = alignment
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }

    private func renderSystemImage(name: String?) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: name ?? "")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor.gray
        return imageView
    }

    private func renderImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}

extension CharacterItemCell: ViewCodeHelper {
    
    private var margin: CGFloat {
        return 16
    }

    func buildViewHierarchy() {
        contentView.addSubview(hStack)
        hStack.addArrangedSubview(characterImage)
        hStack.addArrangedSubview(vStack)
        vStack.addArrangedSubview(name)
        vStack.addArrangedSubview(moreInfo)
        hStack.addArrangedSubview(disclosureIndicator)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin)
        ])
        NSLayoutConstraint.activate([
            characterImage.widthAnchor.constraint(equalToConstant: 60),
            characterImage.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

}
