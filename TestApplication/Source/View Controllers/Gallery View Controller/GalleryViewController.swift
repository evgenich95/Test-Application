//
//  ViewController.swift
//  GalleryViewController
//
//  Created by Joyce Echessa on 6/3/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit
import AssetsLibrary

class GalleryViewController: UIViewController {

    //MARK: Parameters

    private lazy var imageNames: [String] = {
        var names = [String]()
        let fileManager = NSFileManager.defaultManager()
        let str = NSBundle.mainBundle().resourcePath
        let resource = str! + "/Images"
        do {
            let contents = try fileManager.contentsOfDirectoryAtPath(resource)
            for image in contents {
                let imagePath = resource + "/\(image)"
                names.append(imagePath)
            }
        } catch {
        }

        return names
    }()

    var viewFrame = CGRect()

    var pageWidth: CGFloat {
        return self.view.frame.width
    }

    var pageHeight: CGFloat {
        return self.view.frame.height
    }

    var imageViews  = [UIImageView]()

    var canChangePhoto = true
    var screenIsRotating = false
    var canResizePhotos = false {
        didSet {
            lastPage = currentVisiblePage
        }
    }
    var indexLastTransition: (Int, Int) = (0, 0)

    var lastPage: Int = 0
    var currentVisiblePage: Int {
        return Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
    }

    //MARK:-

    //MARK: Lazy parameters

    lazy private var leftArrowBarButton: UIBarButtonItem = {
        let leftButton = UIBarButtonItem(
            image: UIImage(imageLiteral: "leftarrow"),
            style: .Plain,
            target: self,
            action: #selector(arrowBarButtonAction))
        leftButton.tag = -1
        return leftButton
    }()

    lazy private var rightArrowBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(imageLiteral: "rightarrow"),
            style: .Plain,
            target: self,
            action: #selector(arrowBarButtonAction))
        button.tag = 1
        return button
    }()

    lazy private var scrollView: UIScrollView = {

        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollEnabled = true
        scrollView.pagingEnabled = true
        scrollView.bounces = false
        scrollView.backgroundColor = UIColor.blackColor()
        scrollView.delegate = self

        self.view.addSubview(scrollView)

        return scrollView
    }()
    //MARK:-

    override func viewWillLayoutSubviews() {

        if canResizePhotos {
            screenIsRotating = true

            print("\n---------\nviewWillLayoutSubviews")
            print("OLD viewFrame = \(viewFrame)")
            print("New view.frame= \(view.frame)")

            self.scrollView.contentSize = CGSize(
                width: CGFloat(imageViews.count)*pageWidth,
                height: pageHeight
            )

            print("lastPage = \(lastPage)")
            print("currentVisiblePage  before scrolling= \(currentVisiblePage)")

            self.scrollView.scrollRectToVisible(imageViews[lastPage].frame,
                                                animated: false)
            screenIsRotating = false
        }
    }

    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Photo gallery"

        configureView()
        setupNavigationItem()
        setupAutoLayoutConstrains()

        //Load the templates for future photo
        for _ in imageNames {
            loadTemplateForImage()
        }

        imageViews[0].setImageWithoutCache(imageNames[0])
        imageViews[1].setImageWithoutCache(imageNames[1])

        disableBarButtonIfNeed()
        viewFrame = view.frame
        print("viewFrame = \(viewFrame)")
    }

    //MARK: Help functions
    func loadImagesForCurrentPage() {

        var direction: Int = 0

        if lastPage - currentVisiblePage > 0 {
            direction = -1
        } else if lastPage - currentVisiblePage < 0 {
            direction = 1
        }

        if screenIsRotating ||
            direction == 0  ||
            (lastPage, currentVisiblePage) == indexLastTransition {
            return
        }

        let deletionIdx = currentVisiblePage - 2 * direction
        let loadingIdx = currentVisiblePage + direction

        if deletionIdx >= 0 && deletionIdx < imageViews.count {
            print("---->delete for index = \(deletionIdx)")
            imageViews[deletionIdx].image = nil
        }

        if loadingIdx >= 0 && loadingIdx < imageViews.count {
            print("load for index = \(loadingIdx)")
            imageViews[loadingIdx].setImageWithoutCache(imageNames[loadingIdx])
        }
        indexLastTransition = (lastPage, currentVisiblePage)
    }

    func loadTemplateForImage() {
//        let frame = CGRect.init(
//            x: pageWidth*CGFloat(imageViews.count),
//            y: 0,
//            width: pageWidth,
//            height: pageHeight)
        let newImage = UIImageView()

        var leftView: UIView = self.scrollView

        if let lastImage = imageViews.last {
            leftView = lastImage
        }
        scrollView.addSubview(newImage)

        newImage.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self.view)
            make.left.equalTo(leftView.snp_right)
            make.width.equalTo(self.view)
        }

        newImage.contentMode = .ScaleAspectFit

        imageViews.append(newImage)

        self.scrollView.contentSize = CGSize.init(
            width: self.scrollView.contentSize.width + pageWidth,
            height: pageHeight)
    }

    func moveToPage (nextPage: Int) {
        canResizePhotos = false
        self.scrollView.scrollRectToVisible(imageViews[nextPage].frame,
                                            animated: true)
    }

    //MARK: Setup functions

    private func configureView() {
        self.view.backgroundColor = UIColor.whiteColor()
        self.edgesForExtendedLayout = UIRectEdge.None
        self.navigationController?.navigationBar.translucent = false
    }

    func setupNavigationItem() {
        self.navigationItem.leftBarButtonItem = leftArrowBarButton
        self.navigationItem.rightBarButtonItem = rightArrowBarButton
    }

    func setupAutoLayoutConstrains() {
        scrollView.snp_makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(view)
        }
    }

    //MARK: addTarget's function
    @objc func arrowBarButtonAction(sender: UIBarButtonItem) {
        if !canChangePhoto {return}

        //leftButton.tag = -1 and rightButton.tag = 1
        moveToPage(currentVisiblePage+sender.tag)
    }

    func disableBarButtonIfNeed() {
        self.navigationItem.rightBarButtonItem?.enabled = true
        self.navigationItem.leftBarButtonItem?.enabled = true

        if currentVisiblePage+1 >= imageViews.count {
            self.navigationItem.rightBarButtonItem?.enabled = false
        }

        if currentVisiblePage-1 < 0 {
            self.navigationItem.leftBarButtonItem?.enabled = false
        }
    }
}

//MARK: -
//MARK: Extension
//MARK: - UIScrollViewDelegate

extension GalleryViewController: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        canResizePhotos = false
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        canChangePhoto = false
        disableBarButtonIfNeed()
        loadImagesForCurrentPage()
        canChangePhoto = true
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        canResizePhotos = true
    }
}
