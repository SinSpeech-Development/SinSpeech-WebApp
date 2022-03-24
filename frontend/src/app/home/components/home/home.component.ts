import { Component, OnInit } from '@angular/core';
import { DomSanitizer } from '@angular/platform-browser';
import { Router } from '@angular/router';
import { FileService } from '../../services/file.service';

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

  constructor(private fileService: FileService, private sanitization: DomSanitizer, private router: Router) {}

  ngOnInit(): void {
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
