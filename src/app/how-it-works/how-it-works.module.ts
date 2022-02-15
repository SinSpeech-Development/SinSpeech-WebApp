import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HowItWorksComponent } from './components/how-it-works/how-it-works.component';
import { HowItWorksRoutingModule } from './how-it-works-routing.module';

@NgModule({
  declarations: [
    HowItWorksComponent
  ],
  imports: [
    CommonModule,
    HowItWorksRoutingModule
  ]
})
export class HowItWorksModule { }
