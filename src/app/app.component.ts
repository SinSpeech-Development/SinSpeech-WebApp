import { Component, ViewChild, ElementRef } from '@angular/core';
import { FileService } from './file.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  sentence: string = "";
  selectedFile: string = "";
  status: string = "";

  constructor(private fileService: FileService) {}

  onUploadFiles(files: File[]): void {
    const formData = new FormData();
    for (const file of files) {
      this.selectedFile = file.name;
      formData.append('file', file, file.name);
    }
    this.status = "processing";
    this.fileService.upload(formData)
      .subscribe(
        sentence => {
          this.status = "finished";
          this.sentence = sentence!;
        }
      );
  }
}
