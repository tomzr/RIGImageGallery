//
//  RIGAutoCenteringScrollView.swift
//  RIGPhotoViewer
//
//  Created by Michael Skiba on 2/9/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

class RIGAutoCenteringScrollView: UIScrollView {

    var allowZoom: Bool = false

    var baseInsets: UIEdgeInsets = UIEdgeInsets() {
        didSet {
            updateZoomScale(preserveScale: true)
        }
    }

    var zoomImage: UIImage? {
        didSet {
            if oldValue === zoomImage {
                return
            }
            if let img = zoomImage {
                let imageView: UIImageView
                if let img = contentView {
                    imageView = img
                }
                else {
                    imageView = UIImageView()
                    contentView = imageView
                    addSubview(imageView)
                }
                imageView.frame = CGRect(origin: CGPoint(), size: img.size)
                imageView.image = img
            }
            else {
                contentView?.removeFromSuperview()
                contentView = nil
            }
            updateZoomScale(preserveScale: false)
        }
    }

	var contentView: UIImageView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var frame: CGRect {
        didSet {
            updateZoomScale(preserveScale: true)
        }
    }

}

extension RIGAutoCenteringScrollView {

    func toggleZoom(animated: Bool = true) {
        if zoomScale != minimumZoomScale {
            setZoomScale(minimumZoomScale, animated: animated)
        }
        else {
            setZoomScale(maximumZoomScale, animated: animated)
        }
    }

}

private extension RIGAutoCenteringScrollView {

    func updateZoomScale(preserveScale: Bool) {
        guard let image = zoomImage else {
            contentSize = frame.size
            minimumZoomScale = 1
            maximumZoomScale = 1
            setZoomScale(1, animated: false)
            return
        }

        let adjustedFrame = UIEdgeInsetsInsetRect(frame, baseInsets)

        let wScale = adjustedFrame.width / image.size.width
        let hScale = adjustedFrame.height / image.size.height

        let oldMin = minimumZoomScale

        minimumZoomScale = min(wScale, hScale)
        maximumZoomScale = max(1, minimumZoomScale * 3)

        if preserveScale {
            if zoomScale <= oldMin || zoomScale <= minimumZoomScale {
                contentSize = image.size
                setZoomScale(minimumZoomScale, animated: false)
            }
        }
        else {
            contentSize = image.size
            setZoomScale(minimumZoomScale, animated: false)
        }

        centerContent()
    }

    // After much fiddling, using insets to correct zoom behavior was found at: http://petersteinberger.com/blog/2013/how-to-center-uiscrollview/
    func centerContent() {
        guard !contentSize.equalTo(CGSize()) else {
            return
        }
        let adjustedSize = UIEdgeInsetsInsetRect(bounds, baseInsets).size
        let vertical: CGFloat
        let horizontal: CGFloat

        if contentSize.width < adjustedSize.width {
            horizontal = floor((adjustedSize.width - contentSize.width) * 0.5)
        }
        else {
            horizontal = 0
        }

        if contentSize.height < adjustedSize.height {
            vertical = floor((adjustedSize.height - contentSize.height) * 0.5)
        }
        else {
            vertical = 0
        }

        contentInset = UIEdgeInsets(top: vertical + baseInsets.top, left: horizontal + baseInsets.left, bottom: vertical + baseInsets.bottom, right: horizontal + baseInsets.right)
    }

}

extension RIGAutoCenteringScrollView: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return allowZoom ? contentView : nil
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerContent()
    }

}
