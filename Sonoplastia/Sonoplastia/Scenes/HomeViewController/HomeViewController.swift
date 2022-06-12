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
    lazy var selectedAudios: [String] = []
    var audios: [AudioModel] = [AudioModel(name: "Ratinho", assetName: "Ratinho_audio"),
                                AudioModel(name: "Ai", assetName: "Ai_audio"),
                                AudioModel(name: "Cavalo", assetName: "Cavalo_audio"),
                                AudioModel(name: "Dança Gatinho", assetName: "DancaGatinho_audio"),
                                AudioModel(name: "Demais", assetName: "Demais_audio"),
                                AudioModel(name: "Ele Gosta", assetName: "EleGosta_audio"),
                                AudioModel(name: "Não", assetName: "Nao_audio"),
                                AudioModel(name: "Pare", assetName: "Pare_audio"),
                                AudioModel(name: "Rapaz", assetName: "Rapaz_audio"),
                                AudioModel(name: "Atumalaca", assetName: "Atumalaca_audio"),
                                AudioModel(name: "Tome", assetName: "Tome_audio"),
                                AudioModel(name: "Tapa", assetName: "Tapa_audio"),
                                AudioModel(name: "Ui", assetName: "Ui_audio"),
                                AudioModel(name: "Vamo Dança", assetName: "VamoDancar_audio")
    ]
 
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sonoplastia"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancelButtonAction))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonAction))
        self.configTableViewEditing(editingMode: false)
        configTableView()
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
 
    func configTableView() {
        view.addSubview(tableView)
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func playAudio(audioName: String) {
        guard let path = Bundle.main.path(forResource: audioName, ofType: "mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            player.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc func cancelButtonAction() {
        configTableViewEditing(editingMode: false)
        selectedAudios.removeAll()
    }
    
    @objc func shareButtonAction() {
        var activityItems: [URL] = []
        selectedAudios.forEach { audioName in
            let activityItem = URL.init(fileURLWithPath: Bundle.main.path(forResource: audioName, ofType: "mp3")!)
            activityItems.append(activityItem)
        }
        
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityVC.completionWithItemsHandler = { [weak self] _, success, _, _ in
            guard let self = self else { return }
            
            if success {
                self.configTableViewEditing(editingMode: false)
                self.selectedAudios.removeAll()
            }
        }
        present(activityVC, animated: true)
    }
    
    func configTableViewEditing(editingMode: Bool) {
        tableView.setEditing(editingMode, animated: true)
        if editingMode {
            navigationItem.rightBarButtonItem?.isHidden = false
            navigationItem.leftBarButtonItem?.isHidden = false
        } else {
            navigationItem.rightBarButtonItem?.isHidden = true
            navigationItem.leftBarButtonItem?.isHidden = true
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
        cell.imageView?.image = UIImage(systemName: "music.note")
        return cell
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard tableView.isEditing else { return }
        let selectedRow = audios[indexPath.row].assetName
        if let index = selectedAudios.firstIndex(of: selectedRow) {
            selectedAudios.remove(at: index)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            let selectedRow = audios[indexPath.row].assetName
            selectedAudios.append(selectedRow)
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        playAudio(audioName: audios[indexPath.row].assetName)
    }
 
    func makeContextMenu(indexPath: IndexPath) -> UIMenu {
        let share = UIAction(title: "Compartilhar", image: UIImage(systemName: "square.and.arrow.up")) { [weak self] action in
            guard let self = self else { return }
            self.configTableViewEditing(editingMode: true)
            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            self.selectedAudios.append(self.audios[indexPath.row].assetName)
        }
        return UIMenu(title: "", children: [share])
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
            return self.makeContextMenu(indexPath: indexPath)
        })
    }
}
