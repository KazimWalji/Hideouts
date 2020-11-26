//
//  PhotoViewer.swift
//  MadlyRad
//
//  Created by JOJO on 7/24/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//


import UIKit
import SDWebImage

final class PhotoViewerViewController: UIViewController {

    private let url: URL

    init(with url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photo"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .black
        view.addSubview(imageView)
        imageView.sd_setImage(with: url, completed: nil)
        NotificationCenter.default.addObserver(
                     forName: UIApplication.userDidTakeScreenshotNotification,
                     object: nil, queue: nil) { _ in
                       print("I see what you did there3")
                   }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = view.bounds
    }


}
