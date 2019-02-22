//
//  PIEMainPageViewController.swift
//  PageImageExample
//
//  Created by Brandon Askea on 2/16/19.
//  Copyright © 2019 Brandon Askea. All rights reserved.
//

import UIKit

private let mainPageErrorMessage = "The was an error loading the main page."

@objc protocol PIEMainPageViewControllerDelegate {
    func didFinishRefreshing()
}

class PIEMainPageViewController: UIPageViewController {
    
    private var contentViewControllers:[UIViewController] = []
    private var isRefreshing: Bool = false;
    @objc public var del:PIEMainPageViewControllerDelegate!
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        view.backgroundColor = .black
        refresh()
    }
    
    @objc public func refresh() {
        /*
            Load the content
        */
        PIENetworkManager().downloadImageContent { (errorMessage, content) in
            if let errorMessage = errorMessage {
                self.presentAlertWith(errorMessage)
            }
            else {
                self.loadViewControllersFor(content)
            }
        }
    }
    
    private func loadViewControllersFor(_ metadata: [PIEMetadata]) {
        /*
            Iterate through the content
            objects and create the view
            controllers that the
            UIPageViewController will
            display.
        */
        self.contentViewControllers.removeAll()
        for md in metadata {
            guard let vc = UIStoryboard(name: "Content", bundle: .main).instantiateInitialViewController() as? PIEContentViewController else { continue }
            vc.metadata = md
            contentViewControllers.append(vc)
        }
        DispatchQueue.main.async {
            if let firstVC = self.contentViewControllers.first {
                self.setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
            }
            else {
                self.presentAlertWith(mainPageErrorMessage)
            }
            self.del.didFinishRefreshing()
        }
    }
    
    private func presentAlertWith(_ errorMessage: String) {
        let alert = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: UIPageViewControllerDatasource

extension PIEMainPageViewController: UIPageViewControllerDataSource {
    internal func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = contentViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0,
        contentViewControllers.count > previousIndex
        else { return nil }
        return contentViewControllers[previousIndex]
    }
    
    internal func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = contentViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = currentIndex + 1
        guard contentViewControllers.count != nextIndex,
        contentViewControllers.count > nextIndex
        else { return nil }
        return contentViewControllers[nextIndex]
    }
}
