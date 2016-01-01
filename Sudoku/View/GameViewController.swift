//
//  ViewController.swift
//  Sudoku
//
//  Created by Sashank Gogula on 12/7/15.
//  Copyright © 2015 sashankg. All rights reserved.
//

import UIKit
import Interstellar
@available(iOS 9.0, *)
class GameViewController: UIViewController, UIScrollViewDelegate {
	
	@IBOutlet weak var controlHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var bottomBoardConstraint: NSLayoutConstraint!
	@IBOutlet weak var settingsButton: UIButton!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var bottomBarConstraint: NSLayoutConstraint!
	@IBOutlet weak var topBarConstraint: NSLayoutConstraint!
	@IBOutlet weak var boardView: BoardView!
	@IBOutlet weak var scrollView: UIScrollView!
	var viewModel: GameViewModel!
	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.puzzleSignal.ensure(Thread.main)
			.next { squares in
				self.boardView.controller = self
				self.boardView.drawNumbersForSquares(squares!)
				self.activityIndicator.stopAnimating()
				self.scrollView.hidden = false
				self.scrollView.alpha = 0
				UIView.animateWithDuration(0.3, animations: {
					self.scrollView.alpha = 1
				})
		}
	}
	
	override func viewWillLayoutSubviews() {
		boardView.setNeedsDisplay()
	}
	@IBAction func tapped(sender: UITapGestureRecognizer) {
		if controlHeightConstraint.constant > 0
		{
			print("yellow")
			hideControl()
		}
		else
		{
			if CGRectContainsPoint(scrollView.frame, sender.locationOfTouch(0, inView: view))
			{
				zoomIn()
			}
			else
			{
				zoomOut()
			}
		}
	}
	
	func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
		return boardView
	}
	
	var previousScale: CGFloat = 1
	func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) {
		previousScale = scrollView.zoomScale
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		let leftMargin = (scrollView.frame.size.width - boardView.frame.size.width)*0.5
		let topMargin = (scrollView.frame.size.height - boardView.frame.size.height)*0.5
		scrollView.contentInset = UIEdgeInsetsMake(max(0, topMargin), max(0, leftMargin), 0, 0)
		if scrollView.zoomScale < previousScale
		{
			showBars()
		}
		else if scrollView.zoomScale > previousScale
		{
			hideBars()
		}
	}
	
	func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
		if scale < previousScale
		{
			zoomOut()
		}
		else if scale > previousScale
		{
			zoomIn()
		}
	}
	
	
	func zoomOut()
	{
		boardView.userInteractionEnabled = false
		view.layoutIfNeeded()
		showBars()
		UIView.animateWithDuration(0.3) {
			self.scrollView.zoomScale = 0.6
			let leftMargin = (self.scrollView.frame.size.width - self.boardView.frame.size.width)*0.5
			let topMargin = (self.scrollView.frame.size.height - self.boardView.frame.size.height)*0.5
			self.scrollView.contentInset = UIEdgeInsetsMake(max(0, topMargin), max(0, leftMargin), 0, 0)
		}
		boardView.setNeedsDisplay()
		
	}
	
	func zoomIn()
	{
		boardView.userInteractionEnabled = true
		hideBars()
		UIView.animateWithDuration(0.3) {
			self.scrollView.zoomScale = 2
			self.view.layoutIfNeeded()
		}
		boardView.setNeedsDisplay()
		
	}
	
	func showBars()
	{
		view.layoutIfNeeded()
		bottomBarConstraint.constant = 0
		topBarConstraint.constant = 0
		UIView.animateWithDuration(0.3) {
			self.view.layoutIfNeeded()
			
		}
	}
	
	func hideBars()
	{
		view.layoutIfNeeded()
		bottomBarConstraint.constant = -64
		topBarConstraint.constant = -64
		UIView.animateWithDuration(0.3) {
			self.view.layoutIfNeeded()
			
		}
	}
	
	func showControl()
	{
		hideBars()
		view.layoutIfNeeded()
		controlHeightConstraint.constant = view.frame.height / 2
		UIView.animateWithDuration(0.3) {
			self.scrollView.zoomScale = 2
			self.view.layoutIfNeeded()
		}
	}
	
	func hideControl()
	{
		scrollView.userInteractionEnabled = true
		view.layoutIfNeeded()
		controlHeightConstraint.constant = 0
		UIView.animateWithDuration(0.3) {
			self.view.layoutIfNeeded()
		}
	}
	
}

