import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AboutComponent } from './components/about/about.component';
import { AboutProjectRoutingModule } from './about-project-routing.module';

@NgModule({
  declarations: [
    AboutComponent
  ],
  imports: [
    CommonModule,
    AboutProjectRoutingModule
  ]
})
export class AboutProjectModule { }
