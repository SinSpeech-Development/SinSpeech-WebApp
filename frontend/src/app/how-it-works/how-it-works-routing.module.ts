import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { HowItWorksComponent } from './components/how-it-works/how-it-works.component';

const routes: Routes = [
  { path: '', component: HowItWorksComponent }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class HowItWorksRoutingModule { }
