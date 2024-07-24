//
//  PWAlertViewController.swift
//  Pinsoft-WeatherApp
//
//  Created by Celil Çağatay Gedik on 24.07.2024.
//

import UIKit

final class PWAlertViewController: UIViewController {
    private let containerView = PWAlertContainerView()
    private let titleLabel = PWLabel(textAlignment: .center, fontSize: 20, fontWeight: .bold)
    private let errorImageView = PWImageView(systemName: "wifi.slash", effect: .bounce)
    private let messageLabel = PWLabel(textAlignment: .center, fontSize: 16, fontWeight: .medium)
    private let retryButton = PWButton(backgroundColor: .systemBlue, title: "Retry")
    
    var retryAction: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        configureContainerView()
        configureTitleLabel()
        configureErrorImageView()
        configureRetryButton()
        configureMessageLabel()
    }
    
    init(title: String, message: String) {
        super.init(nibName: nil, bundle: nil)
        self.titleLabel.text = title
        self.messageLabel.text = message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureContainerView() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(330)
            make.height.equalTo(260)
        }
    }
    
    private func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(20)
            make.leading.equalTo(containerView.snp.leading).offset(20)
            make.trailing.equalTo(containerView.snp.trailing).offset(-20)
            make.height.equalTo(28)
        }
    }
    
    private func configureErrorImageView() {
        containerView.addSubview(errorImageView)
        errorImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalTo(containerView.snp.centerX)
            make.width.height.equalTo(60)
        }
    }
    
    private func configureRetryButton() {
        containerView.addSubview(retryButton)
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        
        retryButton.snp.makeConstraints { make in
            make.bottom.equalTo(containerView.snp.bottom).offset(-20)
            make.leading.equalTo(containerView.snp.leading).offset(20)
            make.trailing.equalTo(containerView.snp.trailing).offset(-20)
            make.height.equalTo(44)
        }
    }
    
    private func configureMessageLabel() {
        containerView.addSubview(messageLabel)
        messageLabel.numberOfLines = 0
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(errorImageView.snp.bottom).offset(8)
            make.leading.equalTo(containerView.snp.leading).offset(20)
            make.trailing.equalTo(containerView.snp.trailing).offset(-20)
            make.bottom.equalTo(retryButton.snp.top).offset(-12)
        }
    }
    
    @objc private func retryButtonTapped() {
        dismiss(animated: true) { [weak self] in
            self?.retryAction?()
        }
    }
}
