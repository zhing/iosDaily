//
//  BeautyController.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/9/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit
import GPUImage

class BeautyController: UIViewController {
    var imageViewFront :UIImageView!
    var bilateralSlider :UISlider!
    var brightnessSlider :UISlider!
    var bilateralFilter :GPUImageBilateralFilter!
    var brightnessFilter :GPUImageBrightnessFilter!
    var videoCamera :GPUImageVideoCamera!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "beauty"
        self.view.backgroundColor = UIColor.white
        setupSubviews()
        
        processBeautyFilter()
    }

    func setupSubviews() {
        let label1 = UILabel()
        label1.text = "磨皮"
        self.view.addSubview(label1)
        label1.snp.makeConstraints { (make)->Void in
            make.leading.equalTo(20)
            make.bottom.equalTo(-50)
        }
        
        bilateralSlider = UISlider()
        bilateralSlider.minimumValue = 0
        bilateralSlider.maximumValue = 10
        bilateralSlider.setValue(0, animated: true)
        bilateralSlider.addTarget(self, action: #selector(bilateralSliderValueChanged), for: UIControlEvents.valueChanged)
        self.view.addSubview(bilateralSlider)
        bilateralSlider.snp.makeConstraints { (make)->Void in
            make.bottom.equalTo(-50)
            make.leading.equalTo(label1.snp.trailing).offset(20)
            make.trailing.equalTo(-50)
        }
        
        let label2 = UILabel()
        label2.text = "亮度"
        self.view.addSubview(label2)
        label2.snp.makeConstraints { (make)->Void in
            make.leading.equalTo(20)
            make.bottom.equalTo(bilateralSlider.snp.top).offset(-50)
        }
        
        brightnessSlider = UISlider()
        brightnessSlider.minimumValue = 0
        brightnessSlider.maximumValue = 1.0
        brightnessSlider.setValue(0, animated: true)
        brightnessSlider.addTarget(self, action: #selector(brightnessSliderValueChanged), for: UIControlEvents.valueChanged)
        self.view.addSubview(brightnessSlider)
        brightnessSlider.snp.makeConstraints { (make)->Void in
            make.bottom.equalTo(bilateralSlider.snp.top).offset(-50)
            make.leading.equalTo(label2.snp.trailing).offset(20)
            make.trailing.equalTo(-50)
        }
    }
    
    func processBeautyFilter() {
        // 创建视频源
        // SessionPreset:屏幕分辨率，AVCaptureSessionPresetHigh会自适应高分辨率
        // cameraPosition:摄像头方向
        videoCamera = GPUImageVideoCamera.init(sessionPreset: AVCaptureSessionPresetHigh, cameraPosition: AVCaptureDevicePosition.front)
        videoCamera.outputImageOrientation = UIInterfaceOrientation.portrait;
        
        // 创建最终预览View
        let captureVideoPreview :GPUImageView = GPUImageView.init(frame: self.view.bounds)
        self.view.insertSubview(captureVideoPreview, at: 0)
        
        // 创建滤镜：磨皮，美白，组合滤镜
        let groupFilter :GPUImageFilterGroup = GPUImageFilterGroup()
        
        // 磨皮滤镜
        bilateralFilter = GPUImageBilateralFilter()
        groupFilter.addTarget(bilateralFilter);
        
        // 美白滤镜
        brightnessFilter = GPUImageBrightnessFilter();
        groupFilter.addTarget(brightnessFilter);
        
        // 设置滤镜组链
        bilateralFilter.addTarget(brightnessFilter);
        groupFilter.initialFilters = [bilateralFilter]
        groupFilter.terminalFilter = brightnessFilter;
        
        // 设置GPUImage响应链，从数据源 => 滤镜 => 最终界面效果
        videoCamera.addTarget(groupFilter)
        groupFilter.addTarget(captureVideoPreview)
        
        // 必须调用startCameraCapture，底层才会把采集到的视频源，渲染到GPUImageView中，就能显示了。
        // 开始采集视频
        videoCamera.startCapture()
    }
    
    func bilateralSliderValueChanged(sender: UISlider?) {
        let maxValue:CGFloat = 10
        bilateralFilter.distanceNormalizationFactor = maxValue - CGFloat((sender?.value)!)
    }
    
    func brightnessSliderValueChanged(sender: UISlider?) {
        brightnessFilter.brightness = CGFloat((sender?.value)!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
