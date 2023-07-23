//
//  ViewController.swift
//  Marathon8th
//
//  Created by Илья on 7/23/23.
//

import UIKit
import Combine

class ViewController: UIViewController {
    var cancellable: Set<AnyCancellable> = .init()
    private let imageView = UIImageView(image: .init(systemName: "person.crop.circle.fill"))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        setupUI()
        setupMaskLayer()
        binding()
    }

    private func binding() {
        navigationController?.navigationBar
            .publisher(for: \.frame)
            .sink(receiveValue: { [self] frame in
                let maskPath = UIBezierPath(rect: imageView.bounds)
                //delta = 96->44 = 52, height = 36
                let heightToHide: CGFloat = imageView.bounds.width - frame.height + 44 + 6
                let rectToHide = CGRect(x: 0, y: 0, width: imageView.bounds.width,
                                        height: heightToHide)
                maskPath.append(UIBezierPath(rect: rectToHide))
                maskLayer.path = maskPath.cgPath
            }).store(in: &cancellable)
    }

    var maskLayer: CAShapeLayer!

    private func setupMaskLayer() {
        // Create a mask layer with a transparent rectangle initially
        maskLayer = CAShapeLayer()
        maskLayer.fillRule = .evenOdd
        maskLayer.fillColor = UIColor.black.cgColor
        imageView.layer.mask = maskLayer
    }

    private func setupUI() {
        self.title = "Аватарка"

        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.contentSize = CGSize(width: view.bounds.width, height: 1000)
        view.addSubview(scrollView)

        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationBar.addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor,
                                             constant: -12),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor,
                                              constant: -8),
            imageView.heightAnchor.constraint(equalToConstant: 36),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            ])
    }
}

