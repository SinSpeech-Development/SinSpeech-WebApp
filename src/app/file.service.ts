import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { map } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class FileService {
  private serverUrl = "http://localhost:5000";

  constructor(private http: HttpClient) { }

  upload(formData: FormData) {
    return this.http.post<any>(`${this.serverUrl}/offline-decode`, formData, {observe: 'body', responseType: 'json'})
      .pipe(map(res => res.message));
  }
}
