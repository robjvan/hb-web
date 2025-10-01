import { Routes } from '@angular/router';
import { HomePage } from './pages/home-page/home-page';
import { NoContentPage } from './pages/no-content-page/no-content-page';

export const routes: Routes = [
  {
    path: '',
    component: HomePage,
  },
  {
    path: '**',
    pathMatch: 'full',
    component: NoContentPage,
  },
];
