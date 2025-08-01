//
//  LBZSpinner.swift
//  LBZSpinner
//
//  Created by LeBzul on 18/02/2016.
//  Customized by dip kasyap dpd.ghimire@gmail.com
//************ dip added type ********/
//  Copyright © 2016 LeBzul. All rights reserved.
//

// Fuente: https://github.com/LeBzul/LBZSpinner/blob/master/example/LBZSpinner/LBZSpinner.swift

import Foundation
import UIKit

enum SpinnerType:Int {
    case dip = 0
    case LeBzul = 1
}

@IBDesignable class LBZSpinner : UIView, UITableViewDelegate, UITableViewDataSource {
    
    
    fileprivate var lastSuperView: UIView?
    fileprivate var firstDraw: Bool = true
    
    let heightTableviewCell: CGFloat = 45
    var heightTableview: CGFloat = 200
    
    //public variable
    static var INDEX_NOTHING = 0
    
    //spinner
    @IBInspectable var textFont: UIFont = UIFont.systemFont(ofSize: 19.0) { didSet{ updateUI() } }
    @IBInspectable var textColor: UIColor = UIColor.gray { didSet{ updateUI() } }
    @IBInspectable var lineColor: UIColor = UIColor.gray { didSet{ updateUI() } }
    @IBInspectable var list: [String]  = [String]() { didSet{ updateUI() } }
    @IBInspectable var text: String = "" { didSet{ updateUI() } }
    
    //spinner type
    @IBInspectable var type: Int =  SpinnerType.dip.rawValue { didSet{ updateUI() } }
    
    
    //Drop down list
    @IBInspectable var dDLMaxSize: CGFloat = 200
    @IBInspectable var dDLColor: UIColor = UIColor.white
    @IBInspectable var dDLTextColor: UIColor = UIColor.gray
    @IBInspectable var dDLStroke: Bool = true
    @IBInspectable var dDLStrokeColor: UIColor = UIColor.gray
    @IBInspectable var dDLStrokeSize: CGFloat = 1
    
    
    //Drop down list view back
    @IBInspectable var dDLblurEnable: Bool = true
    
    
    var delegate:LBZSpinnerDelegate!
    
    //actual seleted index
    fileprivate(set) internal var selectedIndex = INDEX_NOTHING
    
    fileprivate var labelValue: UILabel!
    fileprivate var blurEffectView: UIVisualEffectView!
    fileprivate var viewChooseDisable: UIView!
    fileprivate var tableviewChoose: UITableView!
    fileprivate var tableviewChooseShadow: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initCustomView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initCustomView()
    }
    
    override func prepareForInterfaceBuilder() {
        backgroundColor = UIColor.clear  // clear black background IB
    }
    
    
    
    fileprivate func initCustomView() {
        backgroundColor = UIColor.clear  // clear black background
        /*NotificationCenter.default.addObserver(
         self,
         selector: #selector(LBZSpinner.orientationChanged),
         name: NSNotification.Name.UIDevice.orientationDidChangeNotification, object: nil)*/
        
        /*NotificationCenter.default.addObserver(
         self,
         selector: #selector(LBZSpinner.orientationChanged),
         name: NSNotification.Name.orientat, object: nil) //You can use any subclass of UIResponder too*/
        
        //Open spinner click
        let gesture = UITapGestureRecognizer(target: self, action: #selector(LBZSpinner.openSpinner(_:)))
        addGestureRecognizer(gesture)
        heightTableview = heightTableviewCell*CGFloat(list.count)
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if firstDraw {
            //create spinner label
            var frame = bounds
            frame.origin = CGPoint(x: frame.origin.x + 10, y: frame.origin.y)
            
            labelValue = UILabel(frame: frame)
            addSubview(labelValue)
            
            //labelValue.backgroundColor = UIColor.gray
            
            updateUI()
            firstDraw = false
        }
        
        drawCanvas(frame: rect)
    }
    
    func changeSelectedIndex(_ index:Int) {
        if list.count > index {
            selectedIndex = index
            text = list[selectedIndex]
            updateUI()
            
            if (delegate != nil) {
                delegate.spinnerChoose(self,index:selectedIndex, value: list[selectedIndex])
            }
        }
    }
    
    fileprivate func updateUI() {
        if (labelValue != nil) {
            labelValue.font = textFont
            labelValue.text = text
            labelValue.textColor = textColor
        }
        setNeedsDisplay()
    }
    
    //Config spinner style
    func decoratedSpinner(_ textColor:UIColor!,lineColor:UIColor!,text:String!) {
        if(textColor != nil) { self.textColor=textColor }
        if(lineColor != nil) { self.lineColor=lineColor }
        if(text != nil) { self.text=text }
    }
    
    //Config drop down list style
    func decoratedDropDownList(_ backgroundColor:UIColor!,textColor:UIColor!,withStroke:Bool!,strokeSize:CGFloat!,strokeColor:UIColor!) {
        
        if(backgroundColor != nil) { dDLColor=backgroundColor }
        if(textColor != nil) { dDLTextColor=textColor }
        if(withStroke != nil) { dDLStroke=withStroke }
        if(strokeSize != nil) { dDLStrokeSize=strokeSize }
        if(strokeColor != nil) { dDLStrokeColor=strokeColor }
    }
    
    
    //Update drop down list
    func updateList(_ list:[String]) {
        self.list = list;
        heightTableview = heightTableviewCell*CGFloat(list.count)
        if(tableviewChoose != nil) {
            tableviewChoose.reloadData()
        }
    }
    
    
    //Open spinner animation
    @objc func openSpinner(_ sender:UITapGestureRecognizer){
        
        heightTableview = heightTableviewCell*CGFloat(list.count)
        let parentView = findLastUsableSuperview()
        let globalPoint = convert(bounds.origin, to:parentView) // position spinner in superview
        viewChooseDisable = UIView(frame: parentView.frame) // view back click
        if(dDLblurEnable) {  // with blur effect
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.alpha = 0 // blur effect alpha
            blurEffectView.frame = viewChooseDisable.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            viewChooseDisable.addSubview(blurEffectView)
        }
        
        
        var expandBottomDirection = true
        if((globalPoint.y+heightTableview) < parentView.frame.height) {
            expandBottomDirection = true
        } else if((globalPoint.y-heightTableview) > 0) {
            expandBottomDirection = false
        } else {
            
            //find best direction
            let margeBot = parentView.frame.height - globalPoint.y
            let margeTop =  parentView.frame.height - (parentView.frame.height - globalPoint.y)
            
            if( margeBot > margeTop ) {
                expandBottomDirection = true
                heightTableview = margeBot - 5
            } else {
                expandBottomDirection = false
                heightTableview = margeTop - 5
            }
            
        }
        
        if(heightTableview > dDLMaxSize) {
            heightTableview = dDLMaxSize
        }
        
        // expand bottom animation
        if (expandBottomDirection) {
            tableviewChoose = UITableView(frame:  CGRect(x: globalPoint.x , y: globalPoint.y, width: frame.size.width, height: 0))
            tableviewChooseShadow = UIView(frame: tableviewChoose.frame)
            
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           options: UIView.AnimationOptions.transitionFlipFromBottom,
                           animations: {
                            self.tableviewChoose.frame.size.height = self.heightTableview
                            self.tableviewChooseShadow.frame.size.height = self.heightTableview
                            
                            if self.blurEffectView != nil {
                                self.blurEffectView.alpha = 0.5
                            }
                            
            },
                           completion: { finished in
            })
            
        }
            // expand top animation
        else {
            
            tableviewChoose = UITableView(frame:  CGRect(x: globalPoint.x , y: globalPoint.y, width: frame.size.width, height: self.frame.height))
            tableviewChooseShadow = UIView(frame: tableviewChoose.frame)
            
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           options: UIView.AnimationOptions.transitionFlipFromBottom,
                           animations: {
                            self.tableviewChoose.frame.origin.y = globalPoint.y-self.heightTableview+self.frame.height
                            self.tableviewChoose.frame.size.height = self.heightTableview
                            self.tableviewChooseShadow.frame.origin.y = globalPoint.y-self.heightTableview+self.frame.height
                            self.tableviewChooseShadow.frame.size.height = self.heightTableview
                            
                            if self.blurEffectView != nil {
                                self.blurEffectView.alpha = 0.5
                            }
            },
                           completion: { finished in
            })
            
        }
        
        
        // config tableview drop down list
        tableviewChoose.backgroundColor = dDLColor
        tableviewChoose.tableFooterView = UIView() //Eliminate Extra separators below UITableView
        tableviewChoose.delegate = self
        tableviewChoose.dataSource = self
        tableviewChoose.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        tableviewChoose.isUserInteractionEnabled = true
        tableviewChoose.showsHorizontalScrollIndicator = false
        tableviewChoose.showsVerticalScrollIndicator = false
        tableviewChoose.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableviewChoose.layer.cornerRadius = 5
        
        //Show stroke
        if(dDLStroke) {
            tableviewChoose.layer.borderColor = dDLStrokeColor.cgColor
            tableviewChoose.layer.borderWidth = dDLStrokeSize
        }
        
        // config shadow drop down list
        tableviewChooseShadow.backgroundColor = dDLColor
        tableviewChooseShadow.layer.shadowOpacity = 0.5;
        tableviewChooseShadow.layer.shadowOffset = CGSize(width: 3, height: 3);
        tableviewChooseShadow.layer.shadowRadius = 5;
        tableviewChooseShadow.layer.cornerRadius = 5
        tableviewChooseShadow.layer.masksToBounds = false
        tableviewChooseShadow.clipsToBounds = false
        
        
        // add to superview
        parentView.addSubview(viewChooseDisable)
        parentView.addSubview(tableviewChooseShadow)
        parentView.addSubview(tableviewChoose)
        
        // close spinner click back
        let gesture = UITapGestureRecognizer(target: self, action: #selector(LBZSpinner.closeSpinner))
        viewChooseDisable.addGestureRecognizer(gesture)
        
    }
    
    
    // close spinner animation
    @objc func closeSpinner() {
        
        if(tableviewChoose != nil) {
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           options: UIView.AnimationOptions.transitionFlipFromBottom,
                           animations: {
                            self.tableviewChoose.alpha = 0.0
                            self.tableviewChooseShadow.alpha = 0.0
                            self.viewChooseDisable.alpha = 0.0
            },
                           completion: { finished in
                            
                            // delete dropdown list
                            self.tableviewChoose.removeFromSuperview()
                            self.viewChooseDisable.removeFromSuperview()
                            self.tableviewChooseShadow.removeFromSuperview()
                            
                            self.tableviewChoose = nil
                            self.tableviewChooseShadow = nil
                            self.viewChooseDisable = nil
            })
        }
    }
    
    
    // find usable superview
    fileprivate func findLastUsableSuperview() -> UIView {
        if lastSuperView == nil {
            var lastView: UIView = self
            var continueWhile = true
            while continueWhile {
                if let superView = lastView.superview {
                    lastView = superView
                } else {
                    continueWhile = false
                }
            }
            
            lastSuperView = lastView
        }
        
        return lastSuperView!
    }
    
    
    //draw background spinner
    fileprivate func drawCanvas(frame: CGRect = CGRect(x: 0, y: 0, width: 86, height: 11)) {
        
        
        
        
        let bezierPath = UIBezierPath()
        
        switch type {
        case SpinnerType.dip.rawValue:
            
            bezierPath.move(to: frame.origin)
            bezierPath.addLine(to: CGPoint(x: frame.minX, y: frame.maxY))
            bezierPath.addLine(to: CGPoint(x: frame.maxX, y: frame.maxY))
            bezierPath.addLine(to: CGPoint(x: frame.maxX, y: frame.minY))
            bezierPath.addLine(to: frame.origin)
            
            
            lineColor.setStroke()
            bezierPath.stroke()
            
            let traingle = UIBezierPath()
            
            //make three points
            let hMargin:CGFloat = 10.0
            let vMargin:CGFloat = frame.height/3
            
            //with of traingle
            let tWidth = frame.height - 2*vMargin
            
            let firstPoint = CGPoint(x: frame.width - hMargin - tWidth / sqrt(2/3), y: vMargin)
            let secondPoint = CGPoint(x: frame.width - hMargin, y: vMargin)
            let thirdPoint = CGPoint(x: frame.width - hMargin - tWidth / sqrt(2/3) / 2, y: vMargin + tWidth)
            
            traingle.move(to: firstPoint)
            traingle.addLine(to: secondPoint)
            traingle.addLine(to: thirdPoint)
            traingle.close()
            lineColor.setFill()
            traingle.fill()
            
            break
            
        case SpinnerType.LeBzul.rawValue :
            
            bezierPath.move(to: CGPoint(x: frame.maxX - 11, y: frame.maxY))
            bezierPath.addLine(to: CGPoint(x: frame.maxX, y: frame.maxY))
            bezierPath.addLine(to: CGPoint(x: frame.maxX, y: frame.maxY - 11))
            bezierPath.addLine(to: CGPoint(x: frame.maxX - 11, y: frame.maxY))
            bezierPath.close()
            bezierPath.lineCapStyle = .square;
            bezierPath.lineJoinStyle = .bevel;
            
            lineColor.setFill()
            bezierPath.fill()
            
            let rectanglePath = UIBezierPath(rect: CGRect(x: frame.minX, y: frame.minY + frame.height - 1, width: frame.width, height: 1))
            lineColor.setFill()
            rectanglePath.fill()
            
            break
            
        default:
            break
        }
        
    }
    
    @objc func orientationChanged()
    {
        /*
         if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
         {}
         if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
         {}
         */
        closeSpinner()
    }
    
    /**
     * TableView Delegate method
     **/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        labelValue.text = list[indexPath.row]
        if (delegate != nil) {
            delegate.spinnerChoose(self,index: indexPath.row, value: list[indexPath.row])
        }
        selectedIndex = indexPath.row
        closeSpinner()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath) as UITableViewCell
        cell.contentView.backgroundColor = dDLColor
        cell.textLabel?.backgroundColor = UIColor.clear
        cell.detailTextLabel?.backgroundColor = UIColor.clear
        cell.textLabel?.text = list[indexPath.row]
        cell.textLabel?.textColor = dDLTextColor
        return cell
    }
}


protocol LBZSpinnerDelegate{
    func spinnerChoose(_ spinner:LBZSpinner, index:Int,value:String)
}
