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

    var scrollWidth = CGFloat()
    var viewFrame = CGRect() {
        didSet {
            print("viewFrame has changed on \(viewFrame)")
        }
    }

    var pageWidth: CGFloat {
        return self.view.frame.width
    }

    var pageHeight: CGFloat {
        return self.view.frame.height
    }

    var imageViews  = [UIImageView]()

    var canChangePhoto = true {
        didSet {
            disableBarButtonIfNeed()
        }
    }
    var screenIsRotating = false {
        didSet {
            print("screenIsRotating changed on \(screenIsRotating)")
        }
    }
    var canResizePhotos = false {
        didSet {
            lastPage = currentVisiblePage
        }
    }
    var current = Int(0)
    var last = Int(0)
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

        let scrollView = UIScrollView(frame: self.view.frame)
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
        print("\n----\nviewWillLayoutSubviews\n")
        if scrollWidth != scrollView.frame.width {
            screenIsRotating = true

            self.scrollView.frame = CGRect.init(
                x: 0, y: 0,
                width: view.bounds.width,
                height: view.bounds.height)

            self.scrollView.contentSize = CGSize.init(
                width: self.scrollView.frame.width * CGFloat(imageViews.count),
                height: self.scrollView.frame.height)


            for i in 0...imageViews.count - 1 {
                let index = CGFloat(Double(i))

                imageViews[i].frame = CGRect.init(x: self.scrollView.frame.width * index, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
                }


//                self.scrollView.contentOffset.x = CGFloat(current) * scrollView.frame.width

            self.scrollView.scrollRectToVisible(imageViews[current].frame,animated: false)

                scrollWidth = self.scrollView.frame.width

        }
        screenIsRotating = false
        print("viewWillLayoutSubviews END \n-----")

    }
//
//    }
//    override func viewWillLayoutSubviews() {
////screenIsRotating = true
//        print("\n--->viewWillLayoutSubviews\n")
//
////        var count = Int(0)
////        print("viewWillLayoutSubviews --- currentVisiblePage\(currentVisiblePage)")
//////        if canResizePhotos {
//        print("\(scrollWidth) != \(scrollView.frame.width) is = \(scrollWidth != scrollView.frame.width)")
//        if scrollWidth != scrollView.frame.width {
//            print("-----\nneed to reload contentSize")
//            print("currentVisiblePage = \(currentVisiblePage)")
//            print("CONSTANT CURRENT = \(current)")
//            print("lastPage\(lastPage)")
//
////            screenIsRotating = true
//
//            self.scrollView.frame = CGRect.init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
//            self.scrollView.contentSize = CGSize.init(width: self.scrollView.frame.width * CGFloat(imageViews.count), height: self.scrollView.frame.height)
//
//            scrollWidth = self.scrollView.frame.width
////          
//            for i in 0...imageViews.count - 1 {
//                let index = CGFloat(Double(i))
////                views[i].configureScrollView()
//                imageViews[i].frame = CGRect.init(x: self.scrollView.frame.width * index, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
//            }
//
//            self.scrollView.scrollRectToVisible(imageViews[current].frame,animated: false)
//
////            self.scrollView.contentOffset.x = CGFloat(current) * scrollView.frame.width
//
////            loadImagesForCurrentPage(current)
//            print("currentVisiblePage after = \(currentVisiblePage)")
//       }
////        screenIsRotating = false
//     }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
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
//        scrollWidth = self.scrollView.frame.width
        disableBarButtonIfNeed()
//        viewFrame = view.frame
//        print("viewFrame = \(viewFrame)")
    }

    //MARK: Help functions
    func loadImagesForCurrentPage(newPage: Int) {
        print("loadImagesForCurrentPage")

        var direction: Int = 0

        if lastPage - newPage > 0 {
            direction = -1
        } else if lastPage - newPage < 0 {
            direction = 1
        }

        if
//            screenIsRotating ||
            direction == 0  ||
            (lastPage, newPage) == indexLastTransition {
            return
        }

        print("load image")

        let deletionIdx = newPage - 2 * direction
        let loadingIdx = newPage + direction

        if deletionIdx >= 0 && deletionIdx < imageViews.count {
            print("---->delete for index = \(deletionIdx)")
            imageViews[deletionIdx].image = nil
        }

        if loadingIdx >= 0 && loadingIdx < imageViews.count {
            print("load for index = \(loadingIdx)")
            imageViews[loadingIdx].setImageWithoutCache(imageNames[loadingIdx])
        }
        indexLastTransition = (lastPage, newPage)
    }

    func loadTemplateForImage() {
        let frame = CGRect.init(
            x: pageWidth*CGFloat(imageViews.count),
            y: 0,
            width: pageWidth,
            height: pageHeight)
        let newImage = UIImageView(frame: frame)

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
//        canResizePhotos = false
//        canChangePhoto = false

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
//        canChangePhoto = false

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

    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
//        lastPage = currentVisiblePage
//        current = currentVisiblePage
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//        canResizePhotos = false
//        canChangePhoto = false

    }

    func scrollViewDidScroll(scrollView: UIScrollView) {

        print("\n-----\nscrollViewDidScroll\n")

        print("\(view.frame.width) ==  \(scrollWidth)")

        if  screenIsRotating || view.frame.width != scrollWidth {
            return
        }
        print("current = \(current)")
        print("lastPage = \(lastPage)")
        current = currentVisiblePage
        print("loading photo")
        loadImagesForCurrentPage(currentVisiblePage)
        lastPage = currentVisiblePage
        print("change last page = \(lastPage)")
        navigationItem.title = "last= \(lastPage); current= \(currentVisiblePage) "
        print("scrollViewDidScroll END\n----")


    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        lastPage = currentVisiblePage
//        current = currentVisiblePage
    }
}
