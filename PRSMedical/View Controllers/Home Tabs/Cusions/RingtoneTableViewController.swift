//
//  RingtoneTableViewController.swift
//  PRSMedical
//
//  Created by Arun Kumar on 20/05/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit
import AVFoundation


class RingtoneTableViewController: UITableViewController {

    var ringtoneName  = ""
    var volume : Float = 0.0
    private var audioFiles = [URL]()
    override func viewDidLoad() {
        super.viewDidLoad()

         let url = URL.init(fileURLWithPath: "/Library/Ringtones")
  
        do {
            audioFiles = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
        }
        catch{
            debugPrint(error.localizedDescription)
        }
     
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.stop()
    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return audioFiles.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let ringtone = audioFiles[indexPath.row].lastPathComponent.components(separatedBy: ".").first
        cell.accessoryType = ringtone == ringtoneName ? .checkmark : .none
        cell.textLabel?.text = ringtone
        // Configure the cell...

        return cell
    }
    private var player: AVAudioPlayer?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: audioFiles[indexPath.row], fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            player.volume = volume
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        ringtoneName = audioFiles[indexPath.row].lastPathComponent.components(separatedBy: ".").first ?? ""
        tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
