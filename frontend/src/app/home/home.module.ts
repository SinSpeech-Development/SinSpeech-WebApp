import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { HomeRoutingModule } from './home-routing.module';
import { HomeComponent } from './components/home/home.component';
import { RecordComponent } from './components/record/record.component';
import { UploadComponent } from './components/upload/upload.component';

@NgModule({
  declarations: [
    HomeComponent,
    RecordComponent,
    UploadComponent
  ],
  imports: [
    CommonModule,
    HomeRoutingModule  
  ]
})
export class HomeModule { }
