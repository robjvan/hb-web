import { Injectable } from '@angular/core';
import { IHaiku } from '../models/haiku.interface';
import { BehaviorSubject, Subject } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { HAIKU_ENDPOINT, SERVER_URL } from '../constants';

@Injectable({
  providedIn: 'root',
})
export class HaikuService {
  constructor(private http: HttpClient) {}

  private destroy$ = new Subject<void>();

  public haiku$ = new BehaviorSubject<IHaiku | null>(null);

  async getNewHaiku() {
    console.log(`Fetching haiku from "${SERVER_URL}/${HAIKU_ENDPOINT}/random"`);
    return this.http.get(`${SERVER_URL}/${HAIKU_ENDPOINT}/random`).subscribe((val: any) => {
      console.log(`Haiku received successfully!`);
      console.log(val);
      this.haiku$.next(val);
    });
  }

  async getHaikuByTheme(theme: string) {
    return this.http.get(`${SERVER_URL}/${HAIKU_ENDPOINT}/${theme}`).subscribe((val: any) => {
      this.haiku$.next(val);
    });
  }

  async generateNewHaiku() {
    return this.http
      .post(`${SERVER_URL}/${HAIKU_ENDPOINT}/generate/random`, null)
      .subscribe((val: any) => {
        this.haiku$.next(val);
      });
  }

  async generateHaikuFromTheme(theme: string) {
    return this.http
      .post(`${SERVER_URL}/${HAIKU_ENDPOINT}/generate/${theme}`, null)
      .subscribe((val: any) => {
        this.haiku$.next(val);
      });
  }

  ngOnDestroy() {
    this.destroy$.next();
    this.destroy$.unsubscribe();
  }
}
