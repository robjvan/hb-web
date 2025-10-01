import { ICountry } from './country.interface';

export interface IHaiku {
  lineOne: string;
  lineTwo: string;
  lineThree: string;
  theme: string;
  country?: ICountry;
}
