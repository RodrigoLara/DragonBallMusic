//
//  WalkthroughViewController.swift
//  MusicBattles
//
//  Created by Rodrigo Lara Ruano on 09/02/20.
//  Copyright © 2020 Rodrigo Lara Ruano. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var closeButton: UIButton!
    
    var pageController: UIPageViewController!
    
    var pagesContent: [[String:String]] = [["image":"1", "description":"¡Bienvenido a Dragon Ball Music!"],
                                           ["image":"2", "description":"Donde encontrarás los mejores openings de tu anime favorito."],
                                           ["image":"3", "description":"Iniciemos creando tu perfil, da click en continuar."]]
    var pages: [WalkthroughPageView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createPages()
        self.setupPageScrollView()

        self.pageControl.numberOfPages = self.pagesContent.count
        self.pageControl.currentPage = 0
    }
    
    func createPages() {
        for i in 0 ..< pagesContent.count {
            let pageData = pagesContent[i]
            
            let pageView = WalkthroughPageView(frame: UIScreen.main.bounds)
            pageView.imagePage.image = UIImage(named: pageData["image"]!)
            pageView.titlePage.text = pageData["description"]
            
            pages.append(pageView)
        }
    }
    
    func setupPageScrollView() {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(pages.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        for i in 0 ..< pages.count {
            pages[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(pages[i])
        }
    }
    
    //MARK: Actions
    
    @IBAction func closeAction(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        appDelegate.window?.rootViewController = UINavigationController(rootViewController: ProfileViewController(nibName: "ProfileViewController", bundle: nil))
    }
}

//MARK: UIScrollViewDelegate

extension WalkthroughViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        if Int(pageIndex) == pagesContent.count-1 {
            closeButton.setTitle("Continuar", for: UIControl.State.normal)
            closeButton.titleLabel?.numberOfLines = 2
            closeButton.titleLabel?.textAlignment = .center
        } else {
            closeButton.setTitle("Omitir", for: UIControl.State.normal)
        }

        /*
         * below code changes the background color of view on paging the scrollview
         */
        //        self.scrollView(scrollView, didScrollToPercentageOffset: percentageHorizontalOffset)
        
    }
}
