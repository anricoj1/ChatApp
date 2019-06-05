//
//  conversationsViewController.swift
//  ChatApp
//
//  Created by Towsif Uddin on 11/26/18.
//  Copyright © 2018 Towsif Uddin. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class conversationsViewController: JSQMessagesViewController
{
    
    var messages = [JSQMessage]()
    
    
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }()
    
    @IBOutlet weak var timeTextfield: UITextField!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        senderId = email
        senderDisplayName = ""
        inputToolbar.contentView.leftBarButtonItem = nil
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
      //  grabChat()
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   // func grabChat(){
        
   //     messages.append(JSQMessage(senderId: "1234", displayName: "null", text: "hi"))
   //     messages.append(JSQMessage(senderId: "1", displayName: "null", text: "yo"))
   //     messages.append(JSQMessage(senderId: "1234", displayName: "null", text: "whats up"))
   //     messages.append(JSQMessage(senderId: "1", displayName: "null", text: "nothin"))
    //    messages.append(JSQMessage(senderId: "1234", displayName: "null", text: "cool"))
        
      //  finishReceivingMessage()
        
      //  collectionView.reloadData()
        
        
   // }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        
        send_messageRequest(message: text!)
        
        //messages.append(JSQMessage(senderId: "1234", displayName: "null", text: "hi"))
        
        //finishSendingMessage()
        
        //collectionView.reloadData()
        
        
    }
 //


    func send_messageRequest(message: String){
        
        let time_stamp = NSDate().timeIntervalSince1970
        
        var encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        guard let url = URL(string: "http://dreamteam.x10host.com/send_message.php?email=\(email)&password=\(password)&message=\(encodedMessage!)&sent_time=\(time_stamp)") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                //print(jsonResponse) //Response result
                
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                //print(jsonArray)
                //Now get title value
                let outputValue = jsonArray[0]["output"] as? String
                
                if (outputValue == "Successfully sent message!"){
                    
                    print("successfully sent message")
                    
                    DispatchQueue.main.sync(){
                        self.messages.append(JSQMessage(senderId: email, displayName: "null", text: message))
                        self.finishSendingMessage()
                        self.collectionView.reloadData()
                    }
                    
                } else {
                    print("invalid username password")
                }
                
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
        
    }
}

