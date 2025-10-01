import { Component, OnInit, signal, WritableSignal } from '@angular/core';
import { ThemeService } from '../../services/theme.service';
import { Subject, takeUntil } from 'rxjs';
import { IHaiku } from '../../models/haiku.interface';
import { HaikuService } from '../../services/haiku.service';

@Component({
  selector: 'app-home-page',
  templateUrl: './home-page.html',
  styleUrl: './home-page.css',
})
export class HomePage implements OnInit {
  constructor(private themeService: ThemeService, private haikuService: HaikuService) {}

  haiku: WritableSignal<IHaiku | undefined> = signal(undefined);

  ngOnInit(): void {
    this.haikuService.getNewHaiku();

    this.haikuService.haiku$.pipe(takeUntil(this.destroy$)).subscribe({
      next: (val) => {
        if (val) {
          this.haiku.set(val);
        }
      },
      error: (err) => {
        console.error(err);
      },
    });
  }

  private destroy$ = new Subject<void>();

  changeTheme(theme: string) {
    this.themeService.setTheme(theme);
  }

  getNewHaiku() {
    this.haikuService.getNewHaiku();
  }

  ngOnDestroy() {
    this.destroy$.next();
    this.destroy$.unsubscribe();
  }
}
