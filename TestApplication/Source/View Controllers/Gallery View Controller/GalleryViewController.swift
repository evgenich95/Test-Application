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

    var imageNames: [String] {
        get {
            var array = [String]()
            for i in 0...10 {
                array.append("\(i)")
            }
            return array
        }
    }

    var canLoadNextPhoto: Bool {
        return (currentImageIndex+1) > (imageNames.count-1) ?  false : true
    }

    var canLoadPreviousPhoto: Bool {
        return (currentImageIndex-1) < 0 ? false : true
    }

    var pageWidth: CGFloat {
        return self.view.frame.width
    }

    var pageHeight: CGFloat {
        return self.view.frame.height
    }

    var imageViews  = [UIImageView]()
    var currentImageIndex: Int = 0
    var canChangePhoto: Bool = true

    var lastpage = CGFloat()
    var currentPage: CGFloat {

        let currentPage: CGFloat = CGFloat(
            (self.scrollView.contentOffset.x-pageWidth)/pageWidth/2+1
        )
        return currentPage
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
        //меняем размер картинок и contentSize у scrollView

        //если все картинки прогрузились и отобразились
        if canChangePhoto {

            self.scrollView.contentSize = CGSize(width: 0, height: 0)

            for image in imageViews {
                guard let index = imageViews.indexOf(image)
                    else { return }

                var leftConstrain = self.scrollView.snp_left

                if index > 0 {
                    leftConstrain = imageViews[index-1].snp_right
                }

                image.snp_updateConstraints {(make) in
                    make.left.equalTo(leftConstrain)
                    make.top.equalTo(view)
                }

                self.scrollView.contentSize = CGSize.init(
                    width: self.scrollView.contentSize.width + pageWidth,
                    height: pageWidth)
            }

            self.scrollView.scrollRectToVisible(imageViews[currentImageIndex].frame, animated: false)
        }
    }

    override func viewWillAppear(animated: Bool) {
        scrollView.scrollEnabled = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Photo gallery"

        configureView()
        setupNavigationItem()
        setupGestureRecognizer()
        setupAutoLayoutConstrains()

        //загрузил шаблоны для будущих фотографий
        for _ in imageNames {
            loadPatternsForImage()
        }

        //загружаю фотографии для 0 и 1 страницы
        loadImageForCurrentPage(1)
    }

    //MARK: Help functions
    func loadImageForCurrentPage(derection: Int) {

        if imageViews[currentImageIndex].image == nil {
            let name = imageNames[currentImageIndex]
            imageViews[currentImageIndex].setImageWithoutCache(name)
        }

        let indexForDelete = currentImageIndex - 2 * derection

        if indexForDelete >= 0 || indexForDelete <= imageNames.count-1 {

            switch (indexForDelete >= 0, indexForDelete <= imageNames.count-1) {
            case (true, true):
                imageViews[indexForDelete].image = nil
            default:
                break
            }

            let neighborImage = currentImageIndex + derection

            switch (derection, canLoadNextPhoto, canLoadPreviousPhoto) {
            case (1, true, _):
                imageViews[neighborImage].setImageWithoutCache(
                    imageNames[neighborImage])
            case (-1, _, true):
                imageViews[neighborImage].setImageWithoutCache(
                    imageNames[neighborImage])
            default:
                break
            }
        }
    }

    @objc func handleOneTap(recognizer: UITapGestureRecognizer) {

        let zoomController = ZoomedPhotoViewController()
        zoomController.imageView = UIImageView(image: UIImage(
                named: imageNames[currentImageIndex])
        )

        zoomController.hidesBottomBarWhenPushed = true

        self.navigationController?.pushViewController(zoomController, animated: true)
    }

    func loadPatternsForImage() {

        let newImage = UIImageView()

        var leftConstrain = self.scrollView.snp_left

        if let lastImage = imageViews.last {
            leftConstrain = lastImage.snp_right
        }
        scrollView.addSubview(newImage)

        newImage.snp_makeConstraints { (make) in
            make.left.equalTo(leftConstrain)
            make.centerY.equalTo(view)
            make.width.equalTo(view)
        }

        newImage.contentMode = .ScaleAspectFit

        imageViews.append(newImage)

        self.scrollView.contentSize = CGSize.init(
            width: self.scrollView.contentSize.width + pageWidth,
            height: pageWidth)

    }

    func moveToNextPage (direction offset: Int) {
        self.scrollView.scrollRectToVisible(imageViews[currentImageIndex].frame, animated: true)
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

    func setupGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleOneTap))
        doubleTap.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(doubleTap)
    }

    func setupAutoLayoutConstrains() {
        scrollView.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.view)
            make.left.right.equalTo(view)
            make.height.equalTo(self.view)
        }
    }

    //MARK: addTarget's function
    @objc func arrowBarButtonAction(sender: UIBarButtonItem) {

        if !canChangePhoto {
            return
        }

        //leftButton.tag = -1
        //rightButton.tag = 1
        currentImageIndex+=sender.tag
        loadImageForCurrentPage(sender.tag)
        moveToNextPage(direction: sender.tag)
        disableBarButtonIfNeed()

        canChangePhoto = false
    }

    func disableBarButtonIfNeed() {

        if !canLoadNextPhoto {
            self.navigationItem.rightBarButtonItem?.enabled = false
            return
        }

        if !canLoadPreviousPhoto {
            self.navigationItem.leftBarButtonItem?.enabled = false
            return
        }

        self.navigationItem.rightBarButtonItem?.enabled = true
        self.navigationItem.leftBarButtonItem?.enabled = true
    }
}

//MARK: -
//MARK: Extension
//MARK: - UIScrollViewDelegate

extension GalleryViewController: UIScrollViewDelegate {

    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        canChangePhoto = true
    }

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        lastpage = currentPage
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //Чтобы прорисовка изображений не было прервана свайпами по экрану
        scrollView.scrollEnabled = false
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {

        defer {
            //разрешаем пользователю свайпать дальше
            self.scrollView.scrollEnabled = true
        }

        if currentPage == lastpage {
            return
        }

        //блокируем свайпы пользователя
        self.scrollView.scrollEnabled = false

        let offset = ((currentPage) < lastpage) ? -1 : 1

        let canChangeValue = (offset>0) ?
            canLoadNextPhoto : canLoadPreviousPhoto

        if canChangeValue {
            currentImageIndex += offset
            loadImageForCurrentPage(offset)
            disableBarButtonIfNeed()
        }
    }
}
