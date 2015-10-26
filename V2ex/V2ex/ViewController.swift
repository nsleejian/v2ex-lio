//
//  ViewController.swift
//  V2ex
//
//  Created by Cocoa Lee on 9/28/15.
//  Copyright © 2015 lio. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

let VIEW_W:CGFloat  =  UIScreen.mainScreen().bounds.size.width
let VIEW_H:CGFloat  =  UIScreen.mainScreen().bounds.size.height


class ViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    let cellID = "home"
    var json:JSON = nil
    var tableView:UITableView = UITableView()
    var titleSizeArray:NSMutableArray  = NSMutableArray()
    var contentSizeArray:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
     
        
        
//       table
        tableView  = UITableView(frame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height), style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(NewFeedCell.self, forCellReuseIdentifier: cellID)
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor.whiteColor()
        
        self.getNewFeed()
    }
    
    
//    请求最新数据
    func getNewFeed() ->Void{
       
        Alamofire.request(.GET, V2_NEW, parameters:nil)
            .responseJSON { (request, response, result) -> Void in
             self.json = JSON(result.value!)
                print(self.json)
                
                self.computeHeight(self.json)
                self.tableView.reloadData()

                
        }
        
    }
    
//    计算高度
    func computeHeight(json:JSON)->Void{
        
       
        for var i = 0;i < self.json.count;i++ {
            let title:String = self.json[i]["title"].string!
            let titleHeight = title.heightWithConstrainedWidth(VIEW_W - 20, font: UIFont.systemFontOfSize(15))
            self.titleSizeArray.addObject(titleHeight)
            let content = json[i]["content"].string!
            let contentHeight = content.heightWithConstrainedMax120Width(VIEW_W - 20, font: UIFont.systemFontOfSize(12))
            self.contentSizeArray.addObject(contentHeight)
   
            
        }
        
    }
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.json.count
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:NewFeedCell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! NewFeedCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let urlString = V2_BASE + json[indexPath.section]["member"]["avatar_normal"].string!
        cell.vAvatar.kf_setImageWithURL(NSURL(string:urlString)!)
        cell.contentView.backgroundColor = UIColor.whiteColor()
        cell.vName.text = json[indexPath.section]["member"]["username"].string
        cell.vTitle.text = json[indexPath.section]["title"].string
        cell.vContent.text = json[indexPath.section]["content"].string!
        
        let timestring = json[indexPath.section]["created"].intValue
        let t = timeStampToString("\(timestring)")
        cell.vTime.text  = t
        print("time \(timestring)")
        
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {


      return 55 + CGFloat(titleSizeArray[indexPath.row] as! NSNumber) + CGFloat(contentSizeArray[indexPath.row] as! NSNumber)
    }
    
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let  feedDetatil :FeedDetatilViewController = FeedDetatilViewController()
        self.navigationController?.pushViewController(feedDetatil, animated: true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        title = "V2EX・最新"
//        删除多余导航条的样式设置
//        self.view.backgroundColor = RGBA(242, g: 242, b: 242, a: 1)
//        self.navigationController?.navigationBar.barTintColor = RGBA(0, g: 134, b: 117, a: 1)
//        self.navigationController?.navigationBar.translucent = false
//        self.navigationController?.navigationBar.layer.shadowColor = navigationController?.navigationBar.barTintColor!.CGColor
//        self.navigationController?.navigationBar.layer.shadowOffset = CGSizeMake(0, 1)
//        self.navigationController?.navigationBar.layer.shadowOpacity = 0.5;
//        self.navigationController?.navigationBar.clipsToBounds = false
//        let shadownPath = UIBezierPath(rect: (navigationController?.navigationBar.bounds)!)
//        self.navigationController?.navigationBar.layer.shadowPath = shadownPath.CGPath

        
    }
    
    
    func RGBA (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat)->UIColor {
        return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }

    
   
    
}


extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: VIEW_W - 20 , height: 40)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    
    func heightWithConstrainedMax120Width(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: VIEW_W - 20 , height: 120)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        print("height \(boundingBox.height)")
      
        return boundingBox.height + 5
    }
    
    
    
}



