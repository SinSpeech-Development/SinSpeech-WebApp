import { Component, OnInit } from '@angular/core';
import { DomSanitizer } from '@angular/platform-browser';
import { FileService } from '../../services/file.service';
import * as RecordRTC from 'recordrtc';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {
  uiState: string = "home";
  urlObj: any;
  selectedFile: string = "";
  uploadStatus: string = "";
  decodedText: string = "";

  recordingStatus: string = "notRecording";
  recorder: any;
  recordedFile: any;

  constructor(private fileService: FileService, private sanitization: DomSanitizer) {}

  ngOnInit(): void {
  }

  recordButtonClicked() {
    this.uiState = "record";
    this.recordingStatus = "notRecording";
  }

  startRecording() {
    let mediaConstraints = {
      video: false,
      audio: true
    };
    navigator.mediaDevices.getUserMedia(mediaConstraints)
      .then(this.successCallback.bind(this), this.errorCallback.bind(this));
  }

  successCallback(stream: any) {
    this.recordingStatus = "recordingStarted";
    var options = {
      type: "audio",
      mimeType: "audio/flac",
      numberOfAudioChannels: 1,
      sampleRate: stream.sampleRate
    };
    var StereoAudioRecorder = RecordRTC.StereoAudioRecorder;
    this.recorder = new StereoAudioRecorder(stream, options);
    this.recorder.record();
  }

  errorCallback(error: string) {
    this.recordingStatus = "recordingError";
  }

  stopRecording() {
    this.recordingStatus = "recordingStopped";
    this.recorder.stop(this.processRecording.bind(this));
    console.log("SAMPLE RATE: ", this.recorder.sampleRate);
  }

  processRecording(blob: any) {
    this.recordedFile = new File([blob], "recording.flac");
    this.onUploadFiles([this.recordedFile]);
  }

  onUploadFiles(files: File[]): void {
    const formData = new FormData();
    for (const file of files) {
      this.urlObj = this.sanitization.bypassSecurityTrustResourceUrl(URL.createObjectURL(file));
      this.selectedFile = file.name;
      formData.append('file', file, file.name);
    }
    this.uploadStatus = "processing";
    this.fileService.upload(formData)
      .subscribe({
        next: (decodedText) => {
            this.uploadStatus = "finished";
            this.decodedText = decodedText!;
        },
        error: () => {
          this.uploadStatus = "error";
          this.decodedText = "";
        } 
      });
    this.uiState = "upload";
  }

  copyDecodedText() {
    navigator.clipboard.writeText(this.decodedText);
  }

  goToHomePage() {
    window.location.reload();
  }
}
