//
//  ViewController.swift
//  Sonoplastia
//
//  Created by Claudio Noberto on 07/06/22.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {
    lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    lazy var player = AVAudioPlayer()
    var audios = [AudioModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sonoplastia"
        configTableView()
        configData()
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func configData() {
        let audioOne = AudioModel(name: "Ratinho", assetName: "Ratinhoo")
        let audioTwo = AudioModel(name: "Ai", assetName: "Ai")
        let audioThree = AudioModel(name: "Cavalo", assetName: "Cavalo")
        let audioFour = AudioModel(name: "Dança Gatinho", assetName: "DancaGatinhoDanca")
        let audioFive = AudioModel(name: "Demais", assetName: "Demais")
        let audioSix = AudioModel(name: "Ele Gosta", assetName: "EleGosta")
        let audioSeven = AudioModel(name: "Não", assetName: "Nao")
        let audioEight = AudioModel(name: "Pare", assetName: "Pare")
        let audioNine = AudioModel(name: "Rapaz", assetName: "Rapais")
        let audioTen = AudioModel(name: "Atumalaca", assetName: "Risada")
        let audioEleven = AudioModel(name: "Tome", assetName: "Tome")
        let audioTwelve = AudioModel(name: "Tapa", assetName: "Tuff")
        let audioThirteen = AudioModel(name: "Ui", assetName: "Ui")
        let audioFourteen = AudioModel(name: "Vamo Dança", assetName: "VamoDancar")
        audios.append(audioOne)
        audios.append(audioTwo)
        audios.append(audioThree)
        audios.append(audioFour)
        audios.append(audioFive)
        audios.append(audioSix)
        audios.append(audioSeven)
        audios.append(audioEight)
        audios.append(audioNine)
        audios.append(audioTen)
        audios.append(audioEleven)
        audios.append(audioTwelve)
        audios.append(audioThirteen)
        audios.append(audioFourteen)
    }
    
    func configTableView() {
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func playAudio(audioName: String) {
        guard let audioData = NSDataAsset(name: audioName)?.data else { return }
        
        do {
            player = try AVAudioPlayer(data: audioData)
            player.play()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Sons"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let data = audios[indexPath.row]
        cell.textLabel?.text = data.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        playAudio(audioName: audios[indexPath.row].assetName)
    }
    
    func makeContextMenu(Data: AudioModel) -> UIMenu {
        let share = UIAction(title: "Compartilhar", image: UIImage(systemName: "square.and.arrow.up")) { action in
            guard let audioData = NSDataAsset(name: Data.assetName)?.data else { return }
            //let item = URL.init(dataRepresentation: audioData, relativeTo: nil)
            let ac = UIActivityViewController(activityItems: [audioData], applicationActivities: [])
            self.present(ac,animated: true)
        }
        return UIMenu(title: "", children: [share])
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let selectedCell = audios[indexPath.row]
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            return self.makeContextMenu(Data: selectedCell)
        })
    }
}
