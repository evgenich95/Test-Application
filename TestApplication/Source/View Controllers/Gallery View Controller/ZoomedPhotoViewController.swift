//
//  ZoomedPhotoViewController.swift
//  TestApplication
//
//  Created by developer on 20.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class ZoomedPhotoViewController: UIViewController {

    //MARK: Parameters
    var imageView: UIImageView = UIImageView()

    lazy private var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.view.frame)
        scrollView.backgroundColor = UIColor.blackColor()
        scrollView.contentSize = self.imageView.bounds.size
        scrollView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        scrollView.addSubview(self.imageView)
        scrollView.delegate = self

        return scrollView
    }()
    //MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        setZoomScale()
        setupGestureRecognizer()
    }

    override func viewWillLayoutSubviews() {
        setZoomScale()
    }

    //MARK: Help functions

    private func configureView() {
        scrollView.bouncesZoom = true
        view.addSubview(scrollView)
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.whiteColor()
        edgesForExtendedLayout = UIRectEdge.None
        navigationController?.navigationBar.translucent = false
    }

    func setZoomScale() {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height

        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.zoomScale = scrollView.minimumZoomScale
    }

    func setupGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
    }

    //MARK: addTarget's functions

    @objc func handleDoubleTap(recognizer: UITapGestureRecognizer) {

        if scrollView.zoomScale > scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
            return
        }

        //zooming at the point
        let pointInImageView = recognizer.locationInView(imageView)

        let zoomScale = scrollView.maximumZoomScale

        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / zoomScale
        let h = scrollViewSize.height / zoomScale
        let x = pointInImageView.x - (w / 2.0)
        let y = pointInImageView.y - (h / 2.0)

        let rectToZoomTo = CGRect.init(x: x, y: y, width: w, height: h)

        scrollView.zoomToRect(rectToZoomTo, animated: true)
    }
}
//MARK:-
//MARK: Extensions
//MARK:- UIScrollViewDelegate

extension ZoomedPhotoViewController: UIScrollViewDelegate {

    func scrollViewDidZoom(scrollView: UIScrollView) {
        defer {
            view.layoutIfNeeded()
        }

        let imageViewSize = self.imageView.frame.size
        let scrollViewSize = scrollView.bounds.size

        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0

        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
