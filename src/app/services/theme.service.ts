import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root',
})
export class ThemeService {
  setTheme(themeName: string): void {
    const body = document.body;

    // Remove any old theme classes
    body.classList.forEach((cls) => {
      if (cls.startsWith('theme-')) {
        body.classList.remove(cls);
      }
    });

    // Add the new theme class
    body.classList.add(`theme-${themeName}`);

    console.log(`Theme changed to ${themeName}`);
  }
}
