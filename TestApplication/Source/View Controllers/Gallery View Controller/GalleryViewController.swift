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
            return array
        }
    }
    var viewFrame = CGRect()

    func canLoadNextPhoto() -> Bool {
        return (currentVisiblePage+1) > (imageNames.count-1) ?  false : true

    }

    func canLoadPreviousPhoto() -> Bool {
        return (currentVisiblePage-1) < 0 ? false : true

    }

    var pageWidth: CGFloat {
        return self.view.frame.width
    }

    var pageHeight: CGFloat {
        return self.view.frame.height
    }

    var imageViews  = [UIImageView]()
//    var currentImageIndex: Int = 0
    var canChangePhoto = true {
        didSet {
//            print("canChangePhoto has changed on \(canChangePhoto)")
        }
    }

    var canResizePhotos = false {
        didSet {
//            print("canResizePhotos has changed on \(canResizePhotos)")
        }
    }
    var indexTransition: (Int, Int) = (0, 0)

    var lastPage: Int = 0
    var currentVisiblePage: Int {
        let contentSize = scrollView.contentOffset.x + pageWidth / 2
        return Int(contentSize / pageWidth)
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
//        if false {

            print("\n---------\nviewWillLayoutSubviews")
            print("OLD viewFrame = \(viewFrame)")
            print("New view.frame= \(view.frame)")

            self.scrollView.contentSize = CGSize(
                width: CGFloat(imageViews.count)*self.view.frame.width,
                height: self.view.frame.height
            )

            print("lastPage = \(lastPage)")
            self.scrollView.scrollRectToVisible(imageViews[lastPage].frame, animated: false)
            print("currentVisiblePage = \(currentVisiblePage)")
            canResizePhotos = true
//            self.scrollView.scrollRectToVisible(CGRect.init(
//                x: self.view.frame.width*CGFloat(lastPage),
//                y: self.view.frame.minY,
//                width: self.view.frame.width,
//                height: self.view.frame.height
//                ), animated: true)

//            for image in imageViews {
//                self.scrollView.contentSize = CGSize.init(
//                    width: self.scrollView.contentSize.width + pageWidth,
//                    height: pageHeight)
//                print("NEW image.bounds.size = \(image.bounds.size)")
//            }
//            loadImagesForCurrentPage()

//            self.scrollView.scrollRectToVisible(CGRect.init(
//                x: pageWidth*CGFloat(lastPage), y: 0, width: pageWidth, height: pageHeight), animated: true)
//            canResizePhotos = true
        }

//        print("currentVisiblePage = \(currentVisiblePage)")
//        меняем размер картинок и contentSize у scrollView

        //        если все картинки прогрузились и отобразились
        if false {
            print("--->viewWillLayoutSubviews")
            self.scrollView.contentSize = CGSize(width: 0, height: 0)
            for image in imageViews {

                guard let index = imageViews.indexOf(image)
                    else { return }
                var leftConstrain = self.scrollView.snp_left
                if index > 0 {
                    leftConstrain = imageViews[index-1].snp_right
                }
                //                        let img = imageViews[index-1]
                image.snp_updateConstraints {(make) in
//                    make.left.equalTo(leftConstrain)
////                    make.size.equalTo(view)
//                     make.top.equalTo(view)

                    make.left.equalTo(leftConstrain)
                    make.centerY.equalTo(view)
                    make.width.equalTo(view)
                }
                self.scrollView.contentSize = CGSize.init(
                    width: self.scrollView.contentSize.width + pageWidth,
                    height: pageHeight)
            }

            print("scrollView.ContentOffset BEFORE = \(scrollView.contentOffset)")
            print("перемещаюсь в прежнею картинку")

            print("lastPage BEFORE =   \(lastPage)")

            print("imageViews[lastPage].frame = \(imageViews[lastPage].frame)")
            print("view.frame = \(view.frame)")
//                                scrollView.setContentOffset(imageViews[lastPage].frame.origin, animated: false)
                                self.scrollView.scrollRectToVisible(imageViews[lastPage].frame, animated: false)

            print("scrollView.ContentOffset  AFTER= \(scrollView.contentOffset)")

        }
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

        if (lastPage, currentVisiblePage) == indexTransition {
            return
        }

        let deletionIdx: Int, loadingIdx: Int, direction: Int

        if lastPage - currentVisiblePage > 0 {
            direction = -1
        } else if lastPage - currentVisiblePage < 0 {
            direction = 1
        } else {
            return
        }

//        canChangePhoto = false

        deletionIdx = currentVisiblePage - 2 * direction
        loadingIdx = currentVisiblePage + direction

        if deletionIdx >= 0 && deletionIdx < imageViews.count {
            print("delete for index = \(deletionIdx)")
            imageViews[deletionIdx].image = nil
        }

        if loadingIdx >= 0 && loadingIdx < imageViews.count {
//            print("load for index = \(loadingIdx)")
            imageViews[loadingIdx].setImageWithoutCache(imageNames[loadingIdx])
        }
        indexTransition = (lastPage, currentVisiblePage)
//        canChangePhoto = true
    }

    func loadTemplateForImage() {
        let frame = CGRect.init(
            x: pageWidth*CGFloat(imageViews.count),
            y: 0,
            width: pageWidth,
            height: pageHeight)
        let newImage = UIImageView()

//        print("imageViews \(imageViews.count), frame = \(frame)")

        var leftConstrain: UIView = self.scrollView

        var leftView: UIView = self.view
        if let lastImage = imageViews.last {
            leftConstrain = lastImage
            leftView = lastImage
        }
        scrollView.addSubview(newImage)

        newImage.snp_makeConstraints { (make) in
//            make.size.equalTo(view)
//            make.left.equalTo(leftConstrain)

            make.top.bottom.equalTo(self.view)
            make.left.equalTo(leftConstrain.snp_right)
            make.width.equalTo(self.view)
//            make.size.equalTo(self.view)
//            make.height.equalTo(self.view)
        }
        print("newImage.frame.bounds.size = \(newImage.bounds.size)")

        newImage.contentMode = .ScaleAspectFit

        imageViews.append(newImage)

        self.scrollView.contentSize = CGSize.init(
            width: self.scrollView.contentSize.width + view.frame.width,
            height: view.frame.height)
    }

    func moveToPage (nextPage: Int) {
        lastPage = currentVisiblePage
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
////            make.centerY.equalTo(self.view)
//            make.top.bottom.left.right.equalTo(view)
////            make.height.equalTo(self.view)


//            make.centerY.equalTo(self.view)
            make.left.right.top.bottom.equalTo(view)
//            make.height.equalTo(self.view)
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
        lastPage = currentVisiblePage
//        canResizePhotos = false
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        canChangePhoto = false
        canResizePhotos = false
        disableBarButtonIfNeed()
        loadImagesForCurrentPage()
        canChangePhoto = true
    }


    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        canChangePhoto = true
        canResizePhotos = true
        lastPage = currentVisiblePage
    }
}
