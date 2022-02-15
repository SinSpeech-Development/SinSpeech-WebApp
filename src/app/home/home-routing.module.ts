import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { HomeComponent } from './components/home/home.component';
import { RecordComponent } from './components/record/record.component';
import { UploadComponent } from './components/upload/upload.component';

const routes: Routes = [
  { path: '', component: HomeComponent },
  { path: 'record', component: RecordComponent },
  { path: 'upload', component: UploadComponent }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class HomeRoutingModule { }
