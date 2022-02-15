import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

const routes: Routes = [
  { path: '', redirectTo: 'home', pathMatch: 'full'},
  { path: 'home', loadChildren: () => import('./home/home.module').then(m => m.HomeModule)},
  { path: 'about', loadChildren: () => import('./about-project/about-project.module').then(m => m.AboutProjectModule)},
  { path: 'howItWorks', loadChildren: () => import('./how-it-works/how-it-works.module').then(m => m.HowItWorksModule)},
  { path: 'resources', loadChildren: () => import('./resources/resources.module').then(m => m.ResourcesModule)},
  { path: 'faq', loadChildren: () => import('./faq/faq.module').then(m => m.FaqModule)}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
