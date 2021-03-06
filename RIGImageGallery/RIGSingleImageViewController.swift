//
//  RIGSingleImageViewController.swift
//  RIGPhotoViewer
//
//  Created by Michael Skiba on 2/8/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

class RIGSingleImageViewController: UIViewController {

    var viewerItem: RIGImageGalleryItem? {
        didSet {
            viewerItemUpdated()
        }
    }

    let scrollView = RIGAutoCenteringScrollView()

    convenience init(viewerItem: RIGImageGalleryItem) {
        self.init()
        self.viewerItem = viewerItem
        viewerItemUpdated()
    }

    override func loadView() {
        automaticallyAdjustsScrollViewInsets = false
        view = scrollView
        view.backgroundColor = .black
        view.clipsToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
    }

}

private extension RIGSingleImageViewController {

    func viewerItemUpdated() {
        scrollView.allowZoom = viewerItem?.image != nil
        scrollView.zoomImage = viewerItem?.image ?? viewerItem?.placeholderImage
    }

}
