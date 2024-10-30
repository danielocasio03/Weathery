//
//  DetailsView.swift
//  Weathery
//
//  Created by Daniel Efrain Ocasio on 10/29/24.
//

import Foundation
import UIKit

class DetailsView: UIView {
	
	lazy var boxIcon: UIImageView = {
		let image = UIImageView()
		image.translatesAutoresizingMaskIntoConstraints = false
		image.contentMode = .scaleAspectFit
		return image
	}()
	
	lazy var boxTitle: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "AvenirNext-Bold", size: 14)
		label.textColor = .white.withAlphaComponent(0.85)
		return label
	}()
	
	lazy var boxDetailOne: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "AvenirNext-Medium", size: 12)
		label.textColor = .white.withAlphaComponent(0.80)
		return label
	}()
	
	lazy var boxDetailTwo: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "AvenirNext-Medium", size: 12)
		label.textColor = .white.withAlphaComponent(0.80)
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		generalUISetup()
		setupAttributes()
		setupConstraints()
	}
	
	// MARK: - General UI setup
	func generalUISetup() {
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = .systemIndigo
		layer.cornerRadius = 20
		
		// Shadow properties
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOpacity = 0.3
		layer.shadowOffset = CGSize(width: 2, height: 2)
		layer.shadowRadius = 6
	}
	
	// MARK: - Box Attributes
	func setupAttributes() {
		// Box Icon
		addSubview(boxIcon)
		boxIcon.tintColor = .white.withAlphaComponent(0.70)
		
		// Box Title
		addSubview(boxTitle)
		
		// Box Detail One
		addSubview(boxDetailOne)
		
		// Box Detail Two
		addSubview(boxDetailTwo)
	}
	
	// MARK: - Constraints
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			// Box Icon
			boxIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
			boxIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
			boxIcon.widthAnchor.constraint(equalToConstant: 24),
			boxIcon.heightAnchor.constraint(equalToConstant: 24),
			
			// Box Title
			boxTitle.topAnchor.constraint(equalTo: topAnchor, constant: 5),
			boxTitle.leadingAnchor.constraint(equalTo: boxIcon.trailingAnchor, constant: 8),
			boxTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
			
			// Box Detail One
			boxDetailOne.topAnchor.constraint(equalTo: boxTitle.bottomAnchor, constant: 2),
			boxDetailOne.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -5),
			boxDetailOne.leadingAnchor.constraint(equalTo: boxIcon.trailingAnchor, constant: 8),
			boxDetailOne.trailingAnchor.constraint(lessThanOrEqualTo: centerXAnchor),
			
			// Box Detail Two
			boxDetailTwo.topAnchor.constraint(equalTo: boxDetailOne.topAnchor),
			boxDetailTwo.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 2),
			boxDetailTwo.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
			boxDetailTwo.bottomAnchor.constraint(equalTo: boxDetailOne.bottomAnchor)
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

