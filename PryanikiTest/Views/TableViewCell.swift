//
//  TableViewCell.swift
//  PryanikiTest
//
//  Created by Николаев Никита on 30.01.2021.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    // MARK:  Properties
    
    var selectorHandler: ((_ index: Int) -> Void)?
    
    private lazy var selector: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(frame: CGRect.zero)
        segmentedControl.addTarget(self, action: #selector(selectSegment(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    private lazy var informationLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var pictureImageView: ReusableLoadedImageView = {
        let imageView = ReusableLoadedImageView(frame: CGRect.zero)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [selector, informationLabel, pictureImageView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK:  Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubviews()
        setSubviewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:  Setup cell
    
    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
    }
    
    private func setSubviewsConstraints() {
        let containerBottomConstraint = containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        containerBottomConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            containerBottomConstraint,
            pictureImageView.heightAnchor.constraint(equalToConstant: CGFloat(AppConstants.UI.Constraints.heightOfImage)),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
    func setup(by dataBlock: DataBlock) {
        stackView.subviews.forEach { $0.isHidden = true }
        switch dataBlock.name {
        case "hz":
            informationLabel.text = dataBlock.data.text
            informationLabel.isHidden = false
        case "selector":
            let variants = dataBlock.data.variants
            variants?.forEach { selector.insertSegment(withTitle: $0.text, at: $0.id, animated: false) }
            selector.selectedSegmentIndex = dataBlock.data.selectedId!
            selector.isHidden = false
        case "picture":
            guard let urlString = dataBlock.data.url,
                  let url = URL(string: urlString) else { break }
            pictureImageView.loadImage(from: url)
            pictureImageView.isHidden = false
        default:
            break
        }
    }
    
    override func prepareForReuse() {
        stackView.subviews.forEach { $0.isHidden = true }
        selector.removeAllSegments()
    }
    
    // MARK:  Actions
    
    @objc private func selectSegment(_ sender: UISegmentedControl) {
        selectorHandler?(sender.selectedSegmentIndex)
    }
    
}
