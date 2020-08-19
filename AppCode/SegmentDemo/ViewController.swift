//
//  ViewController.swift
//  SegmentDemo
//
//  Created by MOHAVE on 19/08/20.
//  Copyright © 2020 Vyas. All rights reserved.
//

import UIKit
import Segmentio

let COLOR_BG_Tab_Selected = Color_Hex(hex: "#1a355a")
let COLOR_BG_Tab = Color_Hex(hex: "#05162d")
let COLOR_Text_Header = Color_Hex(hex: "#a7691b")
let COLOR_Gold_Text = Color_Hex(hex: "#e5ac36")

let FONT_Bold = "Roboto-Bold"

public func Color_Hex(hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}



func segmentioStates() -> SegmentioStates {
    //let font = UIFont.init(name: FONT_Bold, size: 16)
    let font = UIFont.systemFont(ofSize: 16)
    return SegmentioStates(
        defaultState: segmentioState(backgroundColor: .white, titleFont: font, titleTextColor: COLOR_Gold_Text),
        selectedState: segmentioState(backgroundColor: COLOR_BG_Tab, titleFont: font, titleTextColor: COLOR_Gold_Text),
        highlightedState: segmentioState(backgroundColor: COLOR_BG_Tab_Selected, titleFont: font, titleTextColor: COLOR_Gold_Text)
    )
}

func segmentioState(backgroundColor: UIColor, titleFont: UIFont, titleTextColor: UIColor) -> SegmentioState {
    return SegmentioState(backgroundColor: backgroundColor, titleFont: titleFont, titleTextColor: titleTextColor)
}

class ViewController: UIViewController {

    //MARK:-
    @IBOutlet weak var segmentioView: Segmentio!
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var scrollView: UIScrollView!
    
    //MARK:-
    private lazy var viewControllers: [UIViewController] = {
        return self.preparedViewControllers()
    }()
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //TODO: Screens
        setupScrollView()
        
        //TODO: Segment
        self.setupSegment()
    }
    
    //MARK:-
    func setupSegment() {
        let img = UIImage.init()
        let arrSegment : [SegmentioItem] = [SegmentioItem.init(title: "Tab1", image: img),
                                        SegmentioItem.init(title: "Tab2", image: img),
                                        SegmentioItem.init(title: "Tab3", image: img),
                                        SegmentioItem.init(title: "Tab4", image: img),
                                        SegmentioItem.init(title: "Tab5", image: img),
                                        SegmentioItem.init(title: "Tab6", image: img)]
        
        let segmentPosition = SegmentioPosition.fixed(maxVisibleItems: 3)
        let opt_Indicator = SegmentioIndicatorOptions.init(type: .bottom, ratio: 1, height: 8, color: COLOR_Gold_Text)
        let opt_horizontalSeparator = SegmentioHorizontalSeparatorOptions.init(type: .bottom, height: 0, color: UIColor.clear)
        let opt_VerticalSeparatorOptions = SegmentioVerticalSeparatorOptions.init(ratio: 1, color: UIColor.clear)
        
        let opt : SegmentioOptions = SegmentioOptions.init(backgroundColor: COLOR_BG_Tab,
                                                           segmentPosition: segmentPosition,
                                                           scrollEnabled: true,
                                                           indicatorOptions: opt_Indicator,
                                                           horizontalSeparatorOptions: opt_horizontalSeparator,
                                                           verticalSeparatorOptions: opt_VerticalSeparatorOptions,
                                                           imageContentMode: .scaleAspectFit,
                                                           labelTextAlignment: .center,
                                                           labelTextNumberOfLines: 2,
                                                           segmentStates: segmentioStates(),
                                                           animationDuration : 0.3)
        self.segmentioView.setup(content: arrSegment,
                                 style: SegmentioStyle.onlyLabel,
                                 options: opt)
        self.segmentioView.selectedSegmentioIndex = 3
        
        
        segmentioView.valueDidChange = { [weak self] _, segmentIndex in
            if let scrollViewWidth = self?.scrollView.frame.width {
                let contentOffsetX = scrollViewWidth * CGFloat(segmentIndex)
                self?.scrollView.setContentOffset(
                    CGPoint(x: contentOffsetX, y: 0),
                    animated: true
                )
            }
        }
        
    }
    
    private func preparedViewControllers() -> [ContentViewController] {
           let tornadoController = ContentViewController.create()
           tornadoController.disaster = Disaster(
               cardName: "Before tornado",
               hints: ["111"]
           )
           
           let earthquakesController = ContentViewController.create()
           earthquakesController.disaster = Disaster(
               cardName: "Before earthquakes",
               hints: ["Hints.earthquakes"]
           )
           
           let extremeHeatController = ContentViewController.create()
           extremeHeatController.disaster = Disaster(
               cardName: "Before extreme heat",
               hints: ["Hints.extremeHeat"]
           )
           
           let eruptionController = ContentViewController.create()
           eruptionController.disaster = Disaster(
               cardName: "Before eruption",
               hints: ["Hints.eruption"]
           )
           
           let floodsController = ContentViewController.create()
           floodsController.disaster = Disaster(
               cardName: "Before floods",
               hints: ["Hints.floods"]
           )
           
           let wildfiresController = ContentViewController.create()
           wildfiresController.disaster = Disaster(
               cardName: "Before wildfires",
               hints: ["Hints.wildfires"]
           )
           
           return [
               tornadoController,
               earthquakesController,
               extremeHeatController,
               eruptionController,
               floodsController,
               wildfiresController
           ]
       }
       
    
    // MARK: - Setup container view
       
       private func setupScrollView() {
           scrollView.contentSize = CGSize(
               width: UIScreen.main.bounds.width * CGFloat(viewControllers.count),
               height: containerView.frame.height
           )
           
           for (index, viewController) in viewControllers.enumerated() {
               viewController.view.frame = CGRect(
                   x: UIScreen.main.bounds.width * CGFloat(index),
                   y: 0,
                   width: view.frame.width,
                   height: view.frame.height
               )
               addChild(viewController)
               scrollView.addSubview(viewController.view, options: .useAutoresize) // module's extension
               viewController.didMove(toParent: self)
           }
       }       
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = floor(scrollView.contentOffset.x / scrollView.frame.width)
        self.segmentioView.selectedSegmentioIndex = Int(currentPage)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 0)
    }
}
