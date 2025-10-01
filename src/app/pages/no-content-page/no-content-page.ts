import { Component } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-no-content-page',
  imports: [],
  templateUrl: './no-content-page.html',
  styleUrl: './no-content-page.css',
})
export class NoContentPage {
  constructor(private readonly router: Router) {}

  goBack() {
    this.router.navigateByUrl('/home');
  }
}
