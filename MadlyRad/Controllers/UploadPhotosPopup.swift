//
//  UploadPhotosPopup.swift
//  MadlyRad
//
//  Created by THXDBase on 31.08.2020.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import UIKit

class UploadPhotosPopup: UIViewController, UIScrollViewDelegate {
    // 321 added scroller view, set in *.storyboard
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var thirdImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    
    var onUpload:(()->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 321
        if shouldFadeTransition {
            scrollView.isScrollEnabled = false
            secondImageView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
            secondImageView.alpha = 0
            thirdImageView.transform = CGAffineTransform(translationX:  -UIScreen.main.bounds.width * 2, y: 0)
            thirdImageView.alpha = 0
            scrollView.setContentOffset(.zero, animated: true)
        } else {
            scrollView.delegate = self
        }
        
        self.view.alpha = 0
        
        let service = LocalStoreImagesService()
        service.load(id: LocalImages.first.name) { [weak self] (image) in
            if let image = image {
                self?.firstImageView.image = image
            }
        }
        service.load(id: LocalImages.second.name) { [weak self] (image) in
            if let image = image {
                self?.secondImageView.image = image
            }
        }
        service.load(id: LocalImages.third.name) { [weak self] (image) in
            if let image = image {
                self?.thirdImageView.image = image//
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.4) {
            self.view.alpha = 1
        }
        // 321
        startLoop()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 321
        stopLoop()
    }
    
    
    // 321 change slide by timer
    // 321 IF YOU WANT TO CLOSE A POPUP AFTER THIRD IMAGE - SET IT TO TRUE! BY DEFAULT - IT WILL BE INFINITE TRANSITION
    private var shouldBeClosedAfterRound = true
    // 321 IF YOU WANT FADE TRANSITION - SET TO TRUE
    private var shouldFadeTransition = true
    private var timer: Timer?
    private let timerInterval = TimeInterval(exactly: 3)
    private var fadeCurrentPage = 0
    // 321 YOU CAN SET SPEED OF FADE HERE.
    private let fadeDuration = TimeInterval(0.5)
    private func changePhoto() {
        fadeCurrentPage = fadeCurrentPage + 1
        if shouldFadeTransition {
            // fade
            if fadeCurrentPage == 1 {
                UIView.animate(withDuration: fadeDuration) { [weak self] in
                    self?.secondImageView.alpha = 1
                }
            } else if fadeCurrentPage == 2 {
                UIView.animate(withDuration: fadeDuration) { [weak self] in
                    self?.thirdImageView.alpha = 1
                }
            } else if fadeCurrentPage == 3 {
                if shouldBeClosedAfterRound {
                    self.dismiss(animated: true, completion: nil)
                    return
                }
                fadeCurrentPage = 0
                secondImageView.alpha = 0
                UIView.animate(withDuration: fadeDuration) { [weak self] in
                    self?.thirdImageView.alpha = 0
                }
            }
            return
        }
        // paging
        let currentPage = (scrollView.contentOffset.x / scrollView.frame.size.width) + 1
        if currentPage == 1 {
            let offset = CGPoint(x: firstImageView.bounds.width, y: .zero)
            scrollView.setContentOffset(offset, animated: true)
        } else if currentPage == 2 {
            let offset = CGPoint(x: firstImageView.bounds.width * 2, y: .zero)
            scrollView.setContentOffset(offset, animated: true)
        } else if currentPage == 3 {
            if shouldBeClosedAfterRound {
                self.dismiss(animated: true, completion: nil)
                return
            }
            let firstImage = firstImageView.image
            firstImageView.image = thirdImageView.image
            scrollView.setContentOffset(.zero, animated: false)
            let secondImage = secondImageView.image
            secondImageView.image = firstImage
            thirdImageView.image = secondImage
            let offset = CGPoint(x: firstImageView.bounds.width, y: .zero)
            scrollView.setContentOffset(offset, animated: true)
        }
    }
    private func startLoop() {
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval ?? 3, repeats: true, block: { [weak self] (timer) in
            self?.changePhoto()
        })
    }
    private func stopLoop() {
        timer?.invalidate()
        timer = nil
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopLoop()
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        startLoop()
    }
    //

    @IBAction func onUploadHandler(_ sender: Any) {
        onUpload?()
    }
    
    // 321
    @IBAction func onCloseHandler(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0
        }) { [weak self] (result) in
            self?.dismiss(animated: false, completion: nil)
        }
    }
}
